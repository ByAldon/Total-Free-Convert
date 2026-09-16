Add-Type -AssemblyName System.Drawing

$sizes = @(16, 20, 24, 32, 40, 48, 64, 128, 256)
$images = [System.Collections.Generic.List[byte[]]]::new()

foreach ($size in $sizes) {
    $bitmap = [System.Drawing.Bitmap]::new($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.Clear([System.Drawing.Color]::Transparent)

    $orange = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 255, 150, 92))
    $dark = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 25, 25, 25))
    $cream = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(255, 255, 247, 240), [Math]::Max(1.0, $size * 0.07))
    $cream.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
    $cream.EndCap = [System.Drawing.Drawing2D.LineCap]::Round

    $radius = $size * 0.23
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $diameter = $radius * 2
    $path.AddArc(0, 0, $diameter, $diameter, 180, 90)
    $path.AddArc($size - $diameter, 0, $diameter, $diameter, 270, 90)
    $path.AddArc($size - $diameter, $size - $diameter, $diameter, $diameter, 0, 90)
    $path.AddArc(0, $size - $diameter, $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    $graphics.FillPath($orange, $path)

    $graphics.FillRectangle($dark, $size * 0.25, $size * 0.27, $size * 0.50, $size * 0.14)
    $graphics.FillRectangle($dark, $size * 0.43, $size * 0.30, $size * 0.14, $size * 0.50)
    $graphics.DrawLine($cream, $size * 0.18, $size * 0.17, $size * 0.47, $size * 0.17)
    $graphics.DrawLine($cream, $size * 0.47, $size * 0.17, $size * 0.39, $size * 0.09)
    $graphics.DrawLine($cream, $size * 0.47, $size * 0.17, $size * 0.39, $size * 0.25)
    $graphics.DrawLine($cream, $size * 0.82, $size * 0.83, $size * 0.53, $size * 0.83)
    $graphics.DrawLine($cream, $size * 0.53, $size * 0.83, $size * 0.61, $size * 0.75)
    $graphics.DrawLine($cream, $size * 0.53, $size * 0.83, $size * 0.61, $size * 0.91)

    $stream = [System.IO.MemoryStream]::new()
    $bitmap.Save($stream, [System.Drawing.Imaging.ImageFormat]::Png)
    $images.Add($stream.ToArray())

    $stream.Dispose(); $path.Dispose(); $cream.Dispose(); $dark.Dispose(); $orange.Dispose(); $graphics.Dispose(); $bitmap.Dispose()
}

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
