# save-images.ps1
# Watches Downloads folder and renames Gemini images to the right project paths in order.
# Run this BEFORE you start clicking download buttons in Gemini.
# Press Ctrl+C when done.

$downloads = "C:\Users\r\Downloads"
$dest = "C:\Users\r\Dropbox\1.ParkingBOXX\ClaudeAgents\AuthoritySites\aimstravel-astro\public\images"

$names = @(
    "dest-asia-hero.png",
    "dest-europe-hero.png",
    "dest-americas-hero.png",
    "dest-middleeast-hero.png",
    "home-hero.png",
    "about-hero.png"
)

# Track which files existed before we started
$existing = Get-ChildItem $downloads -Filter "Gemini_Generated_Image_*.png" | Select-Object -ExpandProperty FullName

$index = 0
Write-Host ""
Write-Host "=== AIMS Travel Image Saver ===" -ForegroundColor Cyan
Write-Host "Watching Downloads folder for new Gemini images..." -ForegroundColor Green
Write-Host ""
Write-Host "Next image to save: $($names[$index])" -ForegroundColor Yellow
Write-Host ""
Write-Host "Open these Gemini URLs and click 'Download full size image' on each:"
Write-Host "  2. Asia (Angkor Wat):     https://gemini.google.com/app/1a0826d6d65b6401" -ForegroundColor White
Write-Host "  3. Europe (Santorini):    https://gemini.google.com/app/efce3c5f78a3937c" -ForegroundColor White
Write-Host "  4. Americas (Machu P.):   https://gemini.google.com/app/96e39d91bc857fe5" -ForegroundColor White
Write-Host "  5. Middle East (Pyramids):https://gemini.google.com/app/e4701d3719710b08" -ForegroundColor White
Write-Host "  6. Home hero:             https://gemini.google.com/app/f3343f2c2f8b191c" -ForegroundColor White
Write-Host "  7. About hero (travelers):https://gemini.google.com/app/b843d4ad30a0cd33" -ForegroundColor White
Write-Host ""

while ($index -lt $names.Count) {
    Start-Sleep -Milliseconds 500

    $current = Get-ChildItem $downloads -Filter "Gemini_Generated_Image_*.png" | Select-Object -ExpandProperty FullName
    $newFiles = $current | Where-Object { $_ -notin $existing }

    if ($newFiles) {
        $newest = $newFiles | Sort-Object { (Get-Item $_).LastWriteTime } | Select-Object -Last 1

        $targetName = $names[$index]
        $targetPath = Join-Path $dest $targetName

        Copy-Item $newest $targetPath -Force
        $size = [math]::Round((Get-Item $targetPath).Length / 1KB, 0)

        Write-Host "[$($index+1)/$($names.Count)] Saved: $targetName ($size KB)" -ForegroundColor Green

        $existing = $current
        $index++

        if ($index -lt $names.Count) {
            Write-Host "    Next: $($names[$index])" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "All 6 images saved to public/images!" -ForegroundColor Cyan
Write-Host "Run 'git add -A && git commit' in the project to deploy." -ForegroundColor Gray
