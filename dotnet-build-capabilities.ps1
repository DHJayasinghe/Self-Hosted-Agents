$packages = @( =
  'dotnet-6.0-sdk',
  'dotnetcore-sdk'
)

foreach ($package in $packages) {
  Invoke-Expression -Command "choco install $package -y"
}