export const MAX_MEDIA_BYTES = 10 * 1024 * 1024;
export const MAX_MEDIA_PIXELS = 40_000_000;
export const ACCEPTED_MEDIA_TYPES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
export function validateMediaFile(file: Pick<File, 'type' | 'size'>): string | null {
  if (!ACCEPTED_MEDIA_TYPES.includes(file.type)) return 'Choose a JPEG, PNG, WebP or GIF image.';
  if (!file.size) return 'The image file is empty.';
  if (file.size > MAX_MEDIA_BYTES) return 'Choose an image no larger than 10 MB.';
  return null;
}
export function validateMediaDimensions(width: number, height: number): string | null {
  return !Number.isFinite(width) || !Number.isFinite(height) || width <= 0 || height <= 0 || width * height > MAX_MEDIA_PIXELS
    ? 'Choose an image with valid dimensions and no more than 40 megapixels.' : null;
}
