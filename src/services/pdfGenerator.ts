function isMobileBrowser() {
  if (typeof window === 'undefined') return false;
  return /Android|iPhone|iPad|iPod|IEMobile|Opera Mini/i.test(window.navigator.userAgent);
}

function downloadBlob(blob: Blob, fileName: string) {
  const objectUrl = URL.createObjectURL(blob);
  const link = document.createElement('a');

  link.href = objectUrl;
  link.download = fileName;
  link.rel = 'noopener noreferrer';

  if (isMobileBrowser()) {
    link.target = '_blank';
  }

  document.body.appendChild(link);
  link.click();

  // Keep in DOM momentarily to ensure download triggers on all PC desktop browsers
  window.setTimeout(() => {
    if (link.parentNode) {
      link.parentNode.removeChild(link);
    }
    URL.revokeObjectURL(objectUrl);
  }, 30_000);
}

export async function generatePdfFromElement({
  element,
  fileName,
}: {
  element: HTMLElement;
  fileName: string;
}) {
  const [{default: html2canvas}, {jsPDF}] = await Promise.all([
    import('html2canvas'),
    import('jspdf'),
  ]);

  // Clone or ensure element is fully measurable and opaque for html2canvas
  // Save original styles if modified
  const originalDisplay = element.style.display;
  const originalVisibility = element.style.visibility;

  element.style.visibility = 'visible';
  if (originalDisplay === 'none') {
    element.style.display = 'block';
  }

  try {
    const rect = element.getBoundingClientRect();
    const renderWidth = Math.max(element.scrollWidth, Math.round(rect.width), 794);
    const renderHeight = Math.max(element.scrollHeight, Math.round(rect.height), 1123);

    const canvas = await html2canvas(element, {
      scale: Math.max(window.devicePixelRatio || 1, 2),
      useCORS: true,
      allowTaint: true,
      backgroundColor: '#ffffff',
      scrollX: 0,
      scrollY: 0,
      width: renderWidth,
      height: renderHeight,
      logging: false,
      windowWidth: renderWidth,
      windowHeight: renderHeight,
      onclone: (clonedDoc) => {
        // Ensure the cloned target in the virtual DOM is 100% visible and opaque
        const clonedSheet = clonedDoc.querySelector('[data-pdf-report-sheet="true"]') as HTMLElement | null;
        if (clonedSheet) {
          clonedSheet.style.opacity = '1';
          clonedSheet.style.visibility = 'visible';
          clonedSheet.style.transform = 'none';
        }
        // Also ensure any parent container in cloned document is not hidden
        const allHiddenParents = clonedDoc.querySelectorAll('[class*="opacity-0"], [class*="-left-"]');
        allHiddenParents.forEach((el) => {
          const htmlEl = el as HTMLElement;
          htmlEl.style.opacity = '1';
          htmlEl.style.position = 'static';
        });
      },
    });

    const pdf = new jsPDF({
      orientation: 'p',
      unit: 'mm',
      format: 'a4',
      compress: true,
    });

    const pageWidth = 210;
    const pageHeight = 297;
    const margin = 8;
    const contentWidth = pageWidth - margin * 2;
    const contentHeight = pageHeight - margin * 2;
    const pagePixelHeight = Math.floor((canvas.width * contentHeight) / contentWidth);

    let renderedHeight = 0;
    let pageIndex = 0;

    while (renderedHeight < canvas.height) {
      const sliceHeight = Math.min(pagePixelHeight, canvas.height - renderedHeight);
      const pageCanvas = document.createElement('canvas');
      pageCanvas.width = canvas.width;
      pageCanvas.height = sliceHeight;
      const context = pageCanvas.getContext('2d');

      if (!context) {
        throw new Error('Could not create PDF page context.');
      }

      context.drawImage(
        canvas,
        0,
        renderedHeight,
        canvas.width,
        sliceHeight,
        0,
        0,
        canvas.width,
        sliceHeight,
      );

      const imageData = pageCanvas.toDataURL('image/png', 0.95);
      const renderedHeightMm = (sliceHeight * contentWidth) / canvas.width;

      if (pageIndex > 0) {
        pdf.addPage();
      }

      pdf.addImage(
        imageData,
        'PNG',
        margin,
        margin,
        contentWidth,
        renderedHeightMm,
        undefined,
        'FAST',
      );

      renderedHeight += sliceHeight;
      pageIndex += 1;
    }

    const blob = pdf.output('blob');
    downloadBlob(blob, fileName);
  } finally {
    element.style.display = originalDisplay;
    element.style.visibility = originalVisibility;
  }
}
