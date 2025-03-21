$Props = convertfrom-stringdata (get-content versions.properties | Select-String -pattern "^#" -NotMatch)
$YqVersion = $Props.UPSTREAM_VERSION
"Building Upstream Version: $YqVersion"
""

$ChecksumOrderResponse = (Invoke-WebRequest -Uri "https://github.com/mikefarah/yq/releases/download/v$YqVersion/checksums_hashes_order").tostring()
$Sha256FieldNumber = ($ChecksumOrderResponse -split "[`r`n]" | Select-String "SHA-256").LineNumber

$ChecksumResponse = (Invoke-WebRequest -Uri "https://github.com/mikefarah/yq/releases/download/v$YqVersion/checksums").tostring()
$ChecksumList64 = $ChecksumResponse -split "[`r`n]" | Select-String "yq_windows_amd64.exe" | select -First 1
$Checksum64 = (($ChecksumList64 -split "  ")[$Sha256FieldNumber]).ToUpper()

$ChecksumList = $ChecksumResponse -split "[`r`n]" | Select-String "yq_windows_386.exe" | select -First 1
$Checksum = (($ChecksumList -split "  ")[$Sha256FieldNumber]).ToUpper()

"Checksums:"
"  386: $Checksum"
"  x64: $Checksum64"

if (Test-Path -LiteralPath .\target) {
    Remove-Item -LiteralPath .\target -Recurse
}
New-Item -ItemType Directory -Force -Path .\target\tools | Out-Null

(Get-Content .\src\tools\chocolateyinstall.template.ps1) `
    -replace '%%VERSION%%', $YqVersion `
    -replace '%%CHECKSUM%%', $Checksum `
    -replace '%%CHECKSUM64%%', $Checksum64 |
        Out-File -Encoding utf8 ".\target\tools\chocolateyinstall.ps1"
(Get-Content .\src\yq.template.nuspec) -replace '%%VERSION%%', $YqVersion | Out-File -Encoding utf8 ".\target\yq.nuspec"

