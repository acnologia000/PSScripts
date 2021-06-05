[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)][string]$Command ,
    [Parameter(Mandatory=$false)][string]$TargetOS="linux",
    [Parameter(Mandatory=$false)][string]$arch="amd64"
)

$goosList = "aix android darwin dragonfly freebsd hurd illumos ios js linux nacl netbsd openbsd plan9 solaris windows zos".Split(" ")
$goarchList = "386 amd64 amd64p32 arm armbe arm64 arm64be ppc64 ppc64le mips mipsle mips64 mips64le mips64p32 mips64p32le ppc riscv riscv64 s390 s390x sparc sparc64 wasm".Split(" ")

function RevertChanges {
    $env:GOOS = "windows"
    $env:GOARCH = "amd64"
}

function GoBuild([string]$os,[string]$arch) {
    $env:GOOS = $os
    $env:GOARCH = $arch

    Write-Host (go env).Split(" ") -join '`n'

    Write-Host "building for $os on $arch"
    $name = ((Get-Location).path.Split("\")[-1] + "_" + $os + "_" + $arch)
    Write-Host $name
    go build -o $name
}

if ($Command -eq "nix") {   # compile for all BSDs/linux for amd64
    foreach ($os in $goosList) {
        if ($os -match "bsd" -or $os -match "linux" -or $os -match "dragonfly") {
            GoBuild $os $arch
        }
    }
} elseif ($Command -eq "bsdX64") { # compile for all BSDs for x64 (amd64)
    $arch = "amd64"
    foreach ($os in $goosList) {
        if ($os -match "bsd" -or $os -match "dragonfly") {
            GoBuild $os $arch
        }
    }
} elseif ($Command -eq "bsd4All") { # compile for all BSDs for all arch
    $ErrorActionPreference = "SilentlyContinue"
    $arch = "amd64"
    foreach ($os in $goosList) {
        foreach($arch in $goarchList){
            if ($os -match "bsd" -or $os -match "dragonfly") {
                GoBuild $os $arch
            }
        }
    }
} elseif ($Command -eq "openbsdX64") { # compile for all openBSD for x64 (amd64)
    $arch = "amd64"
    $os = "openbsd"
    GoBuild $os $arch
} else {
    GoBuild $TargetOS $arch
}


RevertChanges


python.exe -m http.server



