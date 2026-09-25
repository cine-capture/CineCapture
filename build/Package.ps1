# Creates the versioned CineCapture release archive and its build metadata.
param(
    [Parameter(Mandatory = $true)]
    [string]$RepositoryDirectory,
    [Parameter(Mandatory = $true)]
    [string]$PackageDirectory,
    [Parameter(Mandatory = $true)]
    [string]$ArtifactsDirectory,
    [Parameter(Mandatory = $true)]
    [string]$UnityVersion
)

$assemblyInfo = Get-Content -LiteralPath "$RepositoryDirectory/Properties/AssemblyInfo.cs" -Raw
$match = [regex]::Match($assemblyInfo, 'AssemblyInformationalVersion\("([^"]+)"\)')
if (-not $match.Success) {
    throw 'AssemblyInformationalVersion is missing from Properties/AssemblyInfo.cs.'
}
$version = $match.Groups[1].Value
if ($version -notmatch '^[0-9]+\.[0-9]+\.[0-9]+(?:-[0-9A-Za-z.-]+)?$') {
    throw "AssemblyInformationalVersion must use semantic versioning: $version"
}

$hashes = [ordered]@{}
foreach ($name in 'CineCapture.dll', 'Direct3DVideoEncoder.dll') {
    $file = Get-Item -LiteralPath "$PackageDirectory/$name"
    if ($file.Length -eq 0) {
        throw "The packaged $name is empty."
    }
    $hashes[$name] = (Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash
}
foreach ($name in 'README.md', 'LICENSE') {
    if (-not (Test-Path -LiteralPath "$PackageDirectory/$name" -PathType Leaf)) {
        throw "The packaged $name is missing."
    }
}

[ordered]@{
    version = "v$version"
    unityVersion = $UnityVersion
    builtUtc = [DateTime]::UtcNow.ToString('O')
    platform = 'Windows x64'
    framework = '.NET Standard 2.1'
    components = [ordered]@{
        CameraOperator = (git -C "$RepositoryDirectory/CameraOperator" rev-parse HEAD)
        FFmpegMediaWriter = (git -C "$RepositoryDirectory/UnityRuntimeCameraRecorder/Dependencies/FFmpegMediaWriter" rev-parse HEAD)
        UnityRuntimeCameraRecorder = (git -C "$RepositoryDirectory/UnityRuntimeCameraRecorder" rev-parse HEAD)
        Direct3DVideoEncoder = (git -C "$RepositoryDirectory/UnityRuntimeCameraRecorder/Dependencies/Direct3DVideoEncoder" rev-parse HEAD)
    }
    fileSha256 = $hashes
} | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath "$PackageDirectory/build-info.json" -Encoding utf8

$archive = "$ArtifactsDirectory/CineCapture-v$version-windows-x64.zip"
Compress-Archive -Path "$PackageDirectory/*" -DestinationPath $archive -Force
Write-Output "Created $archive"
