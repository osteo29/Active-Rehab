import {getCurrentUser, supabase} from '../lib/supabase';
import type {Json, TableInsert, TableRow, TableUpdate} from '../lib/supabaseDatabase';

const MEDIA_BUCKET = 'cms-media';
const MAX_MAIN_WIDTH = 1600;
const MAX_THUMB_WIDTH = 480;

export type MediaAssetRow = TableRow<'media_assets'>;
export type MediaAssetInsert = TableInsert<'media_assets'>;
export type MediaAssetUpdate = TableUpdate<'media_assets'>;
export type MediaAssetUsageRow = TableRow<'media_asset_usages'>;
export type MediaAssetUsageInsert = TableInsert<'media_asset_usages'>;

export type UploadMediaOptions = {
  folder: string;
  altText: string;
};

type PreparedImageAsset = {
  width: number;
  height: number;
  mainBlob: Blob;
  thumbnailBlob: Blob;
  blurPlaceholder: string;
};

function ensureSupabase() {
  if (!supabase) {
    throw new Error('Supabase is not configured.');
  }

  return supabase;
}

function sanitizePathSegment(value: string) {
  return value
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9/_-]+/g, '-')
    .replace(/-+/g, '-')
    .replace(/^\/+|\/+$/g, '') || 'uploads';
}

function buildStorageBasePath(folder: string, fileName: string) {
  const folderPath = sanitizePathSegment(folder);
  const datedFolder = new Date().toISOString().slice(0, 7);
  const baseName = sanitizePathSegment(fileName.replace(/\.[^.]+$/, ''));
  const assetId = globalThis.crypto?.randomUUID?.() || `${Date.now()}-${Math.random().toString(16).slice(2)}`;
  return `${folderPath}/${datedFolder}/${assetId}-${baseName}`;
}

async function loadImageBitmap(file: Blob) {
  const objectUrl = URL.createObjectURL(file);

  try {
    const image = await new Promise<HTMLImageElement>((resolve, reject) => {
      const element = new Image();
      element.onload = () => resolve(element);
      element.onerror = () => reject(new Error('Could not process the selected image.'));
      element.src = objectUrl;
    });

    return image;
  } finally {
    URL.revokeObjectURL(objectUrl);
  }
}

function drawToCanvas(image: HTMLImageElement, targetWidth: number) {
  const ratio = image.naturalWidth > targetWidth ? targetWidth / image.naturalWidth : 1;
  const width = Math.max(1, Math.round(image.naturalWidth * ratio));
  const height = Math.max(1, Math.round(image.naturalHeight * ratio));
  const canvas = document.createElement('canvas');
  canvas.width = width;
  canvas.height = height;

  const context = canvas.getContext('2d');
  if (!context) {
    throw new Error('Canvas is not available in this browser.');
  }

  context.drawImage(image, 0, 0, width, height);
  return {canvas, width, height};
}

async function canvasToBlob(canvas: HTMLCanvasElement, type: string, quality?: number) {
  return new Promise<Blob>((resolve, reject) => {
    canvas.toBlob(
      (blob) => {
        if (!blob) {
          reject(new Error('Could not export the image.'));
          return;
        }

        resolve(blob);
      },
      type,
      quality,
    );
  });
}

async function prepareImageAsset(file: File): Promise<PreparedImageAsset> {
  const image = await loadImageBitmap(file);
  const main = drawToCanvas(image, MAX_MAIN_WIDTH);
  const thumbnail = drawToCanvas(image, MAX_THUMB_WIDTH);
  const blur = drawToCanvas(image, 24);

  const [mainBlob, thumbnailBlob] = await Promise.all([
    canvasToBlob(main.canvas, 'image/webp', 0.84),
    canvasToBlob(thumbnail.canvas, 'image/webp', 0.72),
  ]);

  return {
    width: main.width,
    height: main.height,
    mainBlob,
    thumbnailBlob,
    blurPlaceholder: blur.canvas.toDataURL('image/webp', 0.55),
  };
}

function matchesAssetReference(asset: MediaAssetRow, value: string | null | undefined) {
  if (!value) return false;
  return value.includes(asset.storage_path) || value.includes(asset.public_url);
}

export async function listMediaAssets() {
  const client = ensureSupabase();
  const {data, error} = await client.from('media_assets').select('*').order('created_at', {ascending: false});
  if (error) throw error;
  return data || [];
}

export async function listMediaAssetUsages() {
  const client = ensureSupabase();
  const {data, error} = await client
    .from('media_asset_usages')
    .select('*')
    .order('created_at', {ascending: false});
  if (error) throw error;
  return data || [];
}

export async function updateMediaAsset(id: string, input: MediaAssetUpdate) {
  const client = ensureSupabase();
  const {data, error} = await client.from('media_assets').update(input).eq('id', id).select('*').single();
  if (error) throw error;
  return data;
}

export async function deleteMediaAsset(id: string) {
  const client = ensureSupabase();
  const {data: asset, error: assetError} = await client.from('media_assets').select('*').eq('id', id).single();
  if (assetError) throw assetError;

  const {count, error: usageError} = await client
    .from('media_asset_usages')
    .select('*', {head: true, count: 'exact'})
    .eq('asset_id', id);

  if (usageError) throw usageError;
  if ((count || 0) > 0) {
    throw new Error('This asset is still referenced by content. Remove its usages before deleting it.');
  }

  const {error: storageError} = await client.storage.from(asset.bucket_name).remove([
    asset.storage_path,
    typeof asset.variants === 'object' && asset.variants && !Array.isArray(asset.variants) && typeof asset.variants.thumbnailPath === 'string'
      ? asset.variants.thumbnailPath
      : '',
  ].filter(Boolean));

  if (storageError) throw storageError;

  const {error} = await client.from('media_assets').delete().eq('id', id);
  if (error) throw error;
}

export async function uploadMediaAsset(file: File, options: UploadMediaOptions) {
  const client = ensureSupabase();
  const currentUser = await getCurrentUser().catch(() => null);
  const prepared = await prepareImageAsset(file);
  const basePath = buildStorageBasePath(options.folder, file.name);
  const mainPath = `${basePath}.webp`;
  const thumbnailPath = `${basePath}-thumb.webp`;

  const {error: mainError} = await client.storage
    .from(MEDIA_BUCKET)
    .upload(mainPath, prepared.mainBlob, {contentType: 'image/webp', upsert: false});
  if (mainError) throw mainError;

  try {
    const {error: thumbError} = await client.storage
    .from(MEDIA_BUCKET)
    .upload(thumbnailPath, prepared.thumbnailBlob, {contentType: 'image/webp', upsert: false});
  if (thumbError) throw thumbError;

  const publicUrl = client.storage.from(MEDIA_BUCKET).getPublicUrl(mainPath).data.publicUrl;
  const thumbnailUrl = client.storage.from(MEDIA_BUCKET).getPublicUrl(thumbnailPath).data.publicUrl;

  const insertPayload: MediaAssetInsert = {
    bucket_name: MEDIA_BUCKET,
    storage_path: mainPath,
    public_url: publicUrl,
    file_name: file.name,
    mime_type: 'image/webp',
    file_size: prepared.mainBlob.size,
    width: prepared.width,
    height: prepared.height,
    alt_text: options.altText.trim() || null,
    folder: sanitizePathSegment(options.folder),
    uploaded_by: currentUser?.id || null,
    processing_status: 'ready',
    blur_placeholder: prepared.blurPlaceholder,
    variants: {
      thumbnailPath,
      thumbnailUrl,
      originalMimeType: file.type,
      originalSize: file.size,
    },
  };

  const {data, error} = await client.from('media_assets').insert(insertPayload).select('*').single();
  if (error) throw error;
  return data;
  } catch (error) {
    // Remove only objects created by this attempt, never preexisting assets.
    try {
      const {error: cleanupError} = await client.storage.from(MEDIA_BUCKET).remove([mainPath, thumbnailPath]);
      if (cleanupError) console.warn('Could not clean up incomplete media upload.', cleanupError);
    } catch (cleanupError) {
      console.warn('Could not clean up incomplete media upload.', cleanupError);
    }
    throw error;
  }
}

async function replaceAllUsageRows(rows: MediaAssetUsageInsert[]) {
  const client = ensureSupabase();
  const {error: deleteError} = await client.from('media_asset_usages').delete().neq('id', '00000000-0000-0000-0000-000000000000');
  if (deleteError) throw deleteError;

  if (!rows.length) return [];

  const {data, error} = await client.from('media_asset_usages').insert(rows).select('*');
  if (error) throw error;
  return data || [];
}

export async function refreshMediaAssetUsages() {
  const client = ensureSupabase();
  const [assets, articleRows, homepageRows, exerciseRows] = await Promise.all([
    listMediaAssets(),
    client.from('article_workflows').select('lang, slug, image, og_image'),
    client
      .from('homepage_settings')
      .select('lang, hero_cta_href, featured_post_slugs, banner_cta_href, hero_title, banner_title'),
    client.from('exercise_library_entries').select('slug, name, thumbnail_path'),
  ]);

  if (articleRows.error) throw articleRows.error;
  if (homepageRows.error) throw homepageRows.error;
  if (exerciseRows.error) throw exerciseRows.error;

  const usageRows: MediaAssetUsageInsert[] = [];

  for (const asset of assets) {
    for (const article of articleRows.data || []) {
      if (matchesAssetReference(asset, article.image)) {
        usageRows.push({
          asset_id: asset.id,
          content_type: 'article',
          content_key: article.slug,
          field_name: 'image',
          lang: article.lang,
          usage_context: {slug: article.slug} satisfies Json,
        });
      }

      if (matchesAssetReference(asset, article.og_image)) {
        usageRows.push({
          asset_id: asset.id,
          content_type: 'article',
          content_key: article.slug,
          field_name: 'og_image',
          lang: article.lang,
          usage_context: {slug: article.slug} satisfies Json,
        });
      }
    }

    for (const homepage of homepageRows.data || []) {
      const homepageFields: Array<[string, string | null | undefined]> = [
        ['hero_cta_href', homepage.hero_cta_href],
        ['banner_cta_href', homepage.banner_cta_href],
      ];

      for (const [fieldName, value] of homepageFields) {
        if (matchesAssetReference(asset, value)) {
          usageRows.push({
            asset_id: asset.id,
            content_type: 'homepage',
            content_key: homepage.lang,
            field_name: fieldName,
            lang: homepage.lang,
            usage_context: {lang: homepage.lang} satisfies Json,
          });
        }
      }
    }

    for (const exercise of exerciseRows.data || []) {
      if (matchesAssetReference(asset, exercise.thumbnail_path)) {
        usageRows.push({
          asset_id: asset.id,
          content_type: 'exercise',
          content_key: exercise.slug,
          field_name: 'thumbnail_path',
          lang: null,
          usage_context: {slug: exercise.slug, name: exercise.name} satisfies Json,
        });
      }
    }
  }

  return replaceAllUsageRows(usageRows);
}
