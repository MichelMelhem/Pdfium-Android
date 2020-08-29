# Pdfium Android library

Original Android pdfium has few rendering issues.

# Build tweaks:

Natives shall be build manually. Read more about setup OS and build scripts from links below. Use `gclient config --unmanaged --custom-var=checkout_android=True https://pdfium.googlesource.com/pdfium.git`, `./build.sh` and `build.diff`

  * library renamed to `libmodpdfium.so` because API21 && API22 failed to lookup symbols due to conflict with `/system/lib/libpdfium.so`.

Some portion of jni code shared with:

  * https://github.com/barteksc/PdfiumAndroid

## Example

``` java
    ParcelFileDescriptor fd = ...;
    int pageNum = 0;
    Pdfium pdfium = new Pdfium();
    pdfium.open(fd);
    Pdfium.Size size = pdfium.getPageSize(pageNum);
    Pdfium.Page page = pdfium.getPage(pageNum);

    // ARGB_8888 - best quality, high memory usage, higher possibility of OutOfMemoryError
    // RGB_565 - little worse quality, twice less memory usage
    Bitmap bitmap = Bitmap.createBitmap(size.width, size.height, Bitmap.Config.RGB_565);
    
    pdfium.render(bitmap, 0, 0, bm.getWidth(), bm.getHeight());

    Log.e(TAG, "title = " + pdfium.getMeta(Pdfium.META_TITLE));
    Log.e(TAG, "author = " + pdfium.getMeta(Pdfium.META_AUTHOR));

    for (Pdfium.Bookmark b : pdfium.getTOC()) {
        Log.e(TAG, String.format("- %s, p %d", sep, b.title, b.page));
    }

    p.close();
    
    pdfium.close();
```

## Reading links

``` java
    ParcelFileDescriptor fd = ...;
    int pageNum = 0;
    Pdfium pdfium = new Pdfium();
    pdfium.open(fd);
    Pdfium.Page page = pdfium.getPage(pageNum);
    List<Pdfium.Link> links = page.getLinks();
    for (Pdfium.Link link : links) {
        Rect mappedRect = p.mapRectToDevice(..., link.getBounds())

        if (clickedArea(mappedRect)) {
            String uri = link.getUri();
            if (link.getDestPageIdx() != null) {
                // jump to page
            } else if (uri != null && !uri.isEmpty()) {
                // open URI using Intent
            }
        }
    }
```

## Links

  * https://pdfium.googlesource.com/pdfium/
  * https://chromium.googlesource.com/chromium/src/+/master/docs/android_build_instructions.md
  * https://github.com/pvginkel/PdfiumViewer/wiki/Building-PDFium
  * https://github.com/barteksc/PdfiumAndroid
