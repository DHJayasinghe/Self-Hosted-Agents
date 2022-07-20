# escape=`

FROM  mcr.microsoft.com/windows/servercore:ltsc2022

RUN powershell -Command`
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        Invoke-WebRequest `
            -UseBasicParsing `
            -Uri https://chocolatey.org/install.ps1 `
            -OutFile chocolatey-install.ps1

RUN powershell -Command ./chocolatey-install.ps1
RUN powershell -Command Remove-Item -Force chocolatey-install.ps1

WORKDIR /cap
COPY ./capabilities/ .

RUN powershell -Command ./basic-cli-capabilities.ps1
RUN powershell -Command ./dotnet-build-capabilities.ps1
RUN powershell -Command ./npm-build-capabilities.ps1
RUN powershell -Command ./azure-deployment-capabilities.ps1

WORKDIR /azp
COPY ./start.ps1 .

CMD powershell -Command ./start.ps1