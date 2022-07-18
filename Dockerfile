# escape=`

FROM mcr.microsoft.com/windows/servercore:ltsc2019

RUN powershell -Command `
        $ErrorActionPreference = 'Stop'; `
        $ProgressPreference = 'SilentlyContinue'; `
        Invoke-WebRequest `
            -UseBasicParsing `
            -Uri https://chocolatey.org/install.ps1 `
            -OutFile chocolatey-install.ps1

RUN powershell -Command ./chocolatey-install.ps1

RUN powershell -Command Remove-Item -Force chocolatey-install.ps1

WORKDIR /cap

COPY capabilities.ps1 .

RUN powershell -Command ./capabilities.ps1

WORKDIR /azp

COPY start.ps1 .

CMD powershell .\start.ps1