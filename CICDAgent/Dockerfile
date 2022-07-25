# escape=`

FROM  mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN powershell -Command Invoke-WebRequest `
    -UseBasicParsing `
    -Uri https://chocolatey.org/install.ps1 `
    -OutFile chocolatey-install.ps1; `
    ./chocolatey-install.ps1; `
    Remove-Item -Force chocolatey-install.ps1

WORKDIR /cap
COPY ./capabilities/ .

RUN powershell -Command ./basic-cli-capabilities.ps1
RUN powershell -Command ./dotnet-build-capabilities.ps1
RUN powershell -Command ./npm-build-capabilities.ps1


# USER ContainerAdministrator

RUN powershell -Command ./azure-deployment-capabilities.ps1

# USER ContainerUser


WORKDIR /azp
COPY ./start.ps1 .

CMD powershell -Command ./start.ps1
