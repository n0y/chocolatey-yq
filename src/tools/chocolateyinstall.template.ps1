$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
    PackageName    = 'yq'
    Url            = 'https://github.com/mikefarah/yq/releases/download/v%%VERSION%%/yq_windows_386.exe'
    Checksum       = '%%CHECKSUM%%'
    ChecksumType   = 'sha256'
    Url64bit       = 'https://github.com/mikefarah/yq/releases/download/v%%VERSION%%/yq_windows_amd64.exe'
    Checksum64     = '%%CHECKSUM64%%'
    ChecksumType64 = 'sha256'
    FileFullPath   = "$toolsDir\yq.exe"
}

Get-ChocolateyWebFile @packageArgs
