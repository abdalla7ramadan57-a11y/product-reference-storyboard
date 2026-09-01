$ErrorActionPreference = "Stop"

$Repository = "abdalla7ramadan57-a11y/product-reference-storyboard"
$Version = "v2.0.0"
$AssetName = "product-reference-skill-v2.0.0.zip"
$ExpectedSha256 = "F707D844CCF4E692090115294A8C65338075D31165CAE58E49B005F6CC3F9BFE"
$DownloadUrl = "https://github.com/$Repository/releases/download/$Version/$AssetName"
$TemporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("product-reference-storyboard-" + [guid]::NewGuid().ToString("N"))
$ArchivePath = Join-Path $TemporaryDirectory $AssetName
$ExtractPath = Join-Path $TemporaryDirectory "extracted"

try {
    New-Item -ItemType Directory -Path $TemporaryDirectory | Out-Null
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ArchivePath -UseBasicParsing

    $ActualSha256 = (Get-FileHash -LiteralPath $ArchivePath -Algorithm SHA256).Hash
    if ($ActualSha256 -ne $ExpectedSha256) {
        throw "Downloaded package checksum mismatch. Expected $ExpectedSha256 but received $ActualSha256."
    }

    Expand-Archive -LiteralPath $ArchivePath -DestinationPath $ExtractPath
    $InstallerPath = Join-Path $ExtractPath "product-reference-storyboard\install.ps1"
    if (-not (Test-Path -LiteralPath $InstallerPath -PathType Leaf)) {
        throw "The release package does not contain product-reference-storyboard\install.ps1."
    }

    & $InstallerPath
}
finally {
    if (Test-Path -LiteralPath $TemporaryDirectory) {
        Remove-Item -LiteralPath $TemporaryDirectory -Recurse -Force
    }
}
