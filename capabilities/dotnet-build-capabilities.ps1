$packages = @( 
  'dotnet-6.0-sdk',
  'dotnetcore-sdk'
)

foreach ($package in $packages) {
  Invoke-Expression -Command "choco install $package -y"
}

# Delete everything in the dotnet folder that's not needed in the SDK layer but will instead be derived from base layers
# Get-ChildItem -Exclude 'LICENSE.txt', 'ThirdPartyNotices.txt', 'packs', 'sdk', 'sdk-manifests', 'templates', 'shared' -Path 'C:\Program Files\dotnet' `
# | Remove-Item -Force -Recurse; `
#  Get-ChildItem -Exclude 'Microsoft.WindowsDesktop.App' -Path 'C:\Program Files\dotnet\shared' `
# | Remove-Item -Force -Recurse
