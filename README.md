<img src="dist/assets/tfc-logo.svg" alt="Total Free Convert (TFC)" width="294">

# Total Free Convert (TFC)

A free image converter that runs in the visitor's browser. No database, backend,
account, API key or installation is required. The interface is in English.

**Live demo:** https://totalfreeconvert.life42.nl/

## Use it

Open `dist/index.html` in a modern browser, choose one or more images, select an
output format and click **Convert files**, then use the Download button beside
each completed file. When two or more conversions are complete, you can also use
**Download all (.zip)** to save all completed outputs in one archive.

You can also drag multiple images into the drop area, add more files later,
change dimensions per selected file, keep its aspect ratio, and adjust JPG or
WebP quality. There is no fixed file-count limit. The queue decodes and converts
strictly one image at a time to reduce memory peaks. Completed output remains in
browser memory until it is downloaded, removed, replaced by new settings, or the
page is closed, so available browser memory remains the practical batch limit.

## Formats

| Format | Input | Output |
| --- | --- | --- |
| PNG | Browser decoder | Lossless, with transparency |
| JPG / JPEG | Browser decoder | Adjustable quality; transparency becomes white |
| WebP | Browser decoder | Adjustable quality, when browser encoding is supported |
| BMP | Browser decoder | Uncompressed 32-bit bitmap; alpha handling varies by viewer |
| TGA | Built-in decoder | Uncompressed 32-bit TGA with alpha |

TGA input supports uncompressed and RLE true-color (16/24/32-bit) and grayscale
(8/16-bit) images. Color-mapped TGA is not supported. Other image input depends on
the browser. Animated input is converted to a still image, not an animation.

This is an image converter. Video, audio, office document, archive and PDF
conversion are not implemented. Metadata and color profiles are not preserved
reliably through browser canvas conversion. Do not use it as a metadata scrubber
or as a color-managed professional workflow.

## Shared hosting

1. Download or clone the repository.
2. Upload **the contents of `dist/`** to your domain's document root, often
   `public_html`, `www` or `htdocs`.
3. Open your domain in a browser.

For an existing website, upload to a new subdirectory, for example
`public_html/tfc/`, and open `/tfc/`. Avoid overwriting another website's index.
If the server prefers an existing `index.php`, use a separate folder or open
`index.html` explicitly.

No PHP, Node.js, database, special MIME configuration, `.htaccess`, URL rewrites,
build step or server-side image extension is needed. Only ordinary static HTML
hosting is required. Use HTTPS on public hosting.

## Windows desktop app

The repository includes the source for a Windows 10/11 (64-bit) desktop wrapper
and installer. Published binaries can be attached separately to a GitHub Release.

For a normal installation, build the installer and run the generated
`Total-Free-Convert-Setup-v1.0.0.exe`. For portable use, publish the desktop app
and keep the complete publish folder together; `TotalFreeConvert.exe` depends on
the files beside it.

The desktop app opens the same converter in a private local WebView2 window. It
does not start a web server or console window, and still uses no account,
database, upload service or internet connection. The Microsoft Edge WebView2
Runtime is required and is normally already present on supported Windows
installations. The installer is not code-signed, so Windows SmartScreen may show
an unknown-publisher warning.

The page contains its CSS, JavaScript and icon. It has no required CDN, external
font, analytics or conversion service. A hosting provider's custom security policy
must allow the page's inline styles/scripts and local blob downloads. No TGA file
is downloaded from the host: the browser creates it locally.

The bundled social-preview metadata uses a portable relative image path. Some
social networks require an absolute `og:image` and `twitter:image` URL. After the
site has its final domain, replace both values in `dist/index.html` with the full
HTTPS URL of `assets/tfc-social-preview.png` for the most reliable link previews.

## GitHub Pages

For GitHub Pages without a build workflow, copy `dist/index.html` to the root of
the branch you publish (or its `docs/` folder). Select that branch and folder in
the repository's Pages settings. There are no root-relative asset paths, so the
page can also run under a repository URL subdirectory.

## Development

Edit `dist/index.html`. A local server is optional; opening the file directly is
enough for normal use. If Python is installed, an optional preview is:

```sh
python -m http.server 4173 --bind 127.0.0.1 --directory dist
```

Then visit `http://127.0.0.1:4173/`. Python is only a development convenience; it is
not needed on the hosting account.

Before sharing changes, check multi-file selection, sequential queue processing,
individual downloads, multi-file ZIP download, a small image, transparency, TGA input/output,
invalid files, removal during an idle queue, and a narrow mobile window.
The limit is 64 MiB per input file, 16,384 pixels per dimension and 32 megapixels.
Actual capacity can be lower on mobile devices or browsers with smaller canvas
limits. Browser decoding itself can consume memory before dimensions are known.

### Build the Windows app

Install the .NET 8 SDK and Inno Setup 6, then run these commands from the
repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\create-tfc-icon.ps1
dotnet restore .\desktop\TotalFreeConvert.Desktop\TotalFreeConvert.Desktop.csproj
dotnet publish .\desktop\TotalFreeConvert.Desktop\TotalFreeConvert.Desktop.csproj -c Release -r win-x64 --self-contained true --no-restore -o .\work\desktop-publish
& "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe" .\installer\TotalFreeConvert.iss
```

The publish is self-contained for .NET; WebView2 remains a Windows runtime
dependency. From the source repository, run `tools/verify-desktop.ps1` after publishing. The installer reads
the complete publish folder, so rebuild it whenever the site or desktop shell
changes.

## Privacy and security

See [PRIVACY.md](PRIVACY.md) and [SECURITY.md](SECURITY.md). The application has no
database or backend and does not upload selected images. Hosting logs and any
scripts added by a hosting provider are outside the application's control.

## Repository files

- `dist/` — static web converter, ready for shared hosting or GitHub Pages.
- `desktop/` — Windows WebView2 desktop wrapper source.
- `installer/` — Inno Setup installer source.
- `tools/` — helper and verification scripts.
- `.github/` — CI workflow, issue templates and pull request template.
- `CHANGELOG.md` — release history.

## Contributing and license

See [CONTRIBUTING.md](CONTRIBUTING.md). TFC is available under the [MIT license](LICENSE),
which permits use, modification and redistribution with the license notice.
