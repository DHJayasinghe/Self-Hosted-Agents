$packages = @(
  'azure-cli',
  'az.powershell'
  'bicep',
  'azcopy10'
)

Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-PackageProvider -Name NuGet
Install-Module -Name SqlServer -Force -Scope AllUsers

foreach ($package in $packages) {
  Invoke-Expression -Command "choco install $package -y"
}