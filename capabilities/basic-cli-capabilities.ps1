$packages = @(
  # 'powershell-core',
  'git'
)

foreach ($package in $packages) {
  Invoke-Expression -Command "choco install $package -y"
}