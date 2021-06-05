[CmdletBinding()]
param (
    [Parameter(Mandatory=$false)][string]$Command,
    [Parameter(Mandatory=$false)][string]$TargetOS="linux",
    [Parameter(Mandatory=$false)][string]$arch="amd64"
)

$goosList = "aix android darwin dragonfly freebsd hurd illumos ios js linux nacl netbsd openbsd plan9 solaris windows zos".Split(" ")
$goarchList = "386 amd64 amd64p32 arm armbe arm64 arm64be ppc64 ppc64le mips mipsle mips64 mips64le mips64p32 mips64p32le ppc riscv riscv64 s390 s390x sparc sparc64 wasm".Split(" ")

$LinuxArchList = "386 amd64 amd64p32 arm armbe arm64 arm64be ppc64 ppc64le mips mipsle mips64 mips64le mips64p32 mips64p32le ppc riscv riscv64 s390 s390x sparc sparc64 wasm".Split(" ")
$WindowsArchList = "386 amd64 amd64p32 arm64".Split(" ")
$FreebsdArchList = "386 amd64 arm arm64 riscv riscv64".Split(" ")
$OpenbsdArchList = "386 amd64 arm arm64 riscv riscv64".Split(" ")
# add netBSd and arch for other OSes if you feel like


function RevertChanges {
    $env:GOOS = "windows"
    $env:GOARCH = "amd64"
}

function GoBuild([string]$os,[string]$arch) {
    $env:GOOS = $os
    $env:GOARCH = $arch
    go build $PSScriptRoot + "_" + $os + "_" + $arch
}

if ($Command -eq "nix") { # compile for all BSDs/linux for amd64
    foreach ($os in $goosList) {
        if ($os -match "bsd" -or $os -match "linux" -or $os -match "dragonfly") {
            GoBuild $os $arch
        }
    }
}

if ($Command -eq "bsdX64") { # compile for all BSDs for x64 (amd64)
    $arch = "amd64"
    foreach ($os in $goosList) {
        if ($os -match "bsd" -or $os -match "dragonfly") {
            GoBuild $os $arch
        }
    }
}


RevertChanges


python.exe -m http.server



