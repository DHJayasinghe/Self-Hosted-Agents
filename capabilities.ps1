$packages = @(
'powershell-core',
'dotnet-6.0-sdk',
'dotnetcore-sdk',
'nodejs --version=12.22.12',
'nodejs --version=14.20.0',
'nodejs --version=16.16.0',
'nodejs-lts',
'azure-cli',
'azurepowershell',
'bicep',
'git'
)

foreach ($package in $packages)
{
  Invoke-Expression -Command "choco install $package -y"
}