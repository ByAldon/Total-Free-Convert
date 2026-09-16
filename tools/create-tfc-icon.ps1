Add-Type -AssemblyName System.Drawing

$source = Join-Path $PSScriptRoot '..\dist\assets\tfc-icon.png'
if (-not (Test-Path $source)) {
    throw "Source icon not found: $source"
}

$sizes = @(16, 20, 24, 32, 40, 48, 64, 128, 256)
$images = [System.Collections.Generic.List[byte[]]]::new()
$sourceBitmap = [System.Drawing.Bitmap]::new($source)

foreach ($size in $sizes) {
    $bitmap = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.Clear([System.Drawing.Color]::Transparent)
    $graphics.DrawImage($sourceBitmap, 0, 0, $size, $size)

    $stream = [System.IO.MemoryStream]::new()
    $bitmap.Save($stream, [System.Drawing.Imaging.ImageFormat]::Png)
    $images.Add($stream.ToArray())

    $stream.Dispose(); $graphics.Dispose(); $bitmap.Dispose()
}
$sourceBitmap.Dispose()

$target = Join-Path $PSScriptRoot '..\desktop\TotalFreeConvert.Desktop\assets\tfc.ico'
$targetDirectory = Split-Path -Parent $target
[System.IO.Directory]::CreateDirectory($targetDirectory) | Out-Null
$file = [System.IO.File]::Create($target)
$writer = [System.IO.BinaryWriter]::new($file)
$writer.Write([uint16]0); $writer.Write([uint16]1); $writer.Write([uint16]$images.Count)
$offset = 6 + (16 * $images.Count)
for ($index = 0; $index -lt $images.Count; $index++) {
    $size = $sizes[$index]
    $writer.Write([byte]($(if ($size -eq 256) { 0 } else { $size })))
    $writer.Write([byte]($(if ($size -eq 256) { 0 } else { $size })))
    $writer.Write([byte]0); $writer.Write([byte]0)
    $writer.Write([uint16]1); $writer.Write([uint16]32)
    $writer.Write([uint32]$images[$index].Length); $writer.Write([uint32]$offset)
    $offset += $images[$index].Length
}
foreach ($image in $images) { $writer.Write($image) }
$writer.Dispose(); $file.Dispose()
Write-Output $target
