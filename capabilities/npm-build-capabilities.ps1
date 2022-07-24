$packages = @(
  # 'nodejs --version=12.22.12',
  # 'nodejs --version=14.20.0',
  'nodejs --version=16.16.0'
  # 'nodejs-lts',
)

foreach ($package in $packages) {
  Invoke-Expression -Command "choco install $package -y"
}