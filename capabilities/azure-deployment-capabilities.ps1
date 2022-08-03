$packages = @(
  'azure-cli',
  'az.powershell'
  'bicep',
  'azcopy10'
)

# Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-PackageProvider -Name NuGet -Force

foreach ($package in $packages) {
  Invoke-Expression -Command "choco install $package -y --no-progress"
}

Remove-Item 'C:\Users\ContainerAdministrator\AppData\Local\Temp\chocolatey' -Recurse -Force