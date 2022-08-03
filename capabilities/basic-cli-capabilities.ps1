$packages = @(
  'git'
)

foreach ($package in $packages) {
  Invoke-Expression -Command "choco install $package -y --no-progress"
}

Remove-Item 'C:\Users\ContainerAdministrator\AppData\Local\Temp\chocolatey' -Recurse -Force