$packages = @(
  'azure-cli',
  'az.powershell'
  'bicep',
  'azcopy10'
)

foreach ($package in $packages) {
  Invoke-Expression -Command "choco install $package -y"
}