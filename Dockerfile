# escape=`

FROM  mcr.microsoft.com/powershell:7.2-nanoserver-ltsc2022

RUN pwsh -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        Invoke-WebRequest `
            -UseBasicParsing `
            -Uri https://chocolatey.org/install.ps1 `
            -OutFile chocolatey-install.ps1

RUN pwsh ./chocolatey-install.ps1
RUN pwsh -Command Remove-Item -Force chocolatey-install.ps1

WORKDIR /cap
COPY capabilities/ .

RUN pwsh ./basic-cli-capabilities.ps1
RUN pwsh ./dotnet-build-capabilities.ps1
RUN pwsh ./npm-build-capabilities.ps1
RUN pwsh ./azure-deployment-capabilities.ps1

WORKDIR /azp
COPY start.ps1 .

CMD pwsh .\start.ps1