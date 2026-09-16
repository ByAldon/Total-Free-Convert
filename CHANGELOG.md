# Changelog

## 1.3.0 - 2026-09-16

- Added a local Image/JPG to PDF tool for single-image PDF export.
- Added a local ZIP Creator for arbitrary files.
- Added local Unit Converter and Time Converter utilities.
- Preserved TFC's no-upload privacy model for all built-in tools.
- Bumped the website, desktop source and installer source to 1.3.0.

## 1.2.0 - 2026-09-16

- Added built-in local image tools: Image Compressor, JPEG Compressor, PNG Optimizer, Resize Image, Crop Image, Color Picker, Rotate Image, Flip Image and Image Enlarger.
- Added exact pixel crop controls and a preview color picker with HEX/RGB output.
- Kept all built-in processing local in the browser/device; no TFC file-upload backend was added.
- Kept ClipSnap and ProPDF as clearly separated external links with their own privacy/terms notice.
- Did not add non-working video/audio/PDF tools as fake features.
- Bumped the project to 1.2.0 for the website, desktop source and installer source.

## 1.1.0 - 2026-09-16

- Added working local rotate-left, rotate-right, horizontal-flip and vertical-flip image tools.
- Limited advertised output formats to formats TFC can actually create locally: PNG, JPG, WebP, BMP and TGA.
- Split input format information into confirmed local support and browser-dependent formats instead of implying guaranteed support.
- Added optional external links to ClipSnap and ProPDF with a clear privacy/terms notice.
- Updated the desktop source so allowed ClipSnap and ProPDF links open in the user's default browser.
- Bumped the project to 1.1.0 because this is a larger feature update.

## 1.0.5 - 2026-09-16

- Refined the Output settings panel with cleaner cards for format/quality and resize controls.
- Redesigned the action area with a clearer queue status card and better button layout for Convert and Download all.
- Bumped the project version to 1.0.5 for the website, desktop source and installer source.

## 1.0.4 - 2026-09-16

- Added the full specialist image-format catalog from the referenced image-converter list as recognized input extensions.
- Added local PPM (P3/P6) decoding.
- Added clear unsupported-browser messages for recognized specialist formats instead of generic decode failures.
- Added an expandable input-format list to the website.
- Bumped website, desktop source and installer source to 1.0.4.

## 1.0.3 - 2026-09-16

- Added new output formats: GIF, TIFF, SVG and PSD.
- Expanded the format picker so the converter now offers PNG, JPG, WebP, GIF, BMP, TGA, TIFF, SVG and PSD.
- Bumped the project version to 1.0.3 for the website, desktop source and installer source.

## 1.0.2 - 2026-09-16

- Replaced the site logo with a new blue/green Total Free Convert brand logo based on the TFC monogram.
- Updated the website header branding, favicon and social preview to match the new logo.
- Bumped the web, desktop source and installer source version to 1.0.2.
- Kept the light theme and the multi-file ZIP download workflow introduced in earlier updates.

All notable changes to Total Free Convert are documented here.

## 1.0.1 - 2026-09-16

- Added multi-file **Download all (.zip)** support.
- Refreshed the interface with a light white theme and blue/green accents.
- Updated visible branding to **Total Free Convert**.
- Added the live demo link to the README.
- Added visible website and Windows application version information.

## 1.0.0 - 2026-09-16

### Added
- Local browser-based image conversion for PNG, JPG/JPEG, WebP, BMP and TGA.
- Multi-file queue with sequential processing to reduce memory peaks.
- Per-file resize controls, aspect-ratio handling and JPG/WebP quality settings.
- Individual downloads for completed conversions.
- **Download all (.zip)** for downloading multiple converted files at once.
- Static shared-hosting build in `dist/`.
- Windows WebView2 desktop wrapper and Inno Setup installer source.
- Privacy, security and contribution documentation.
