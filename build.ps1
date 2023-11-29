Write-Host "Generating gfx chr..."
$gfx = superfamiconv -v -i gfx/char.png -p gfx/char.pal -t gfx/char.chr -m gfx/char.map -B 4 -H 8 -W 8 
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error while generating gfx chr"
    Exit 1   
}

$clean = del output/rom.sfc
$build = asar --symbols=wla main.s output/rom.sfc

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build complete!"

    $run = mesen output/rom.sfc
} else {
    Write-Host "Error: $LASTEXITCODE"
}