# escape=`
ARG core=mcr.microsoft.com/windows/servercore:ltsc2019
ARG target=mcr.microsoft.com/powershell:7.2-nanoserver-1809

FROM $core as installer

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN powershell -Command Invoke-WebRequest `
    -UseBasicParsing `
    -Uri https://chocolatey.org/install.ps1 `
    -OutFile chocolatey-install.ps1

RUN powershell -Command ./chocolatey-install.ps1

COPY ./capabilities/ .

RUN powershell -Command ./npm-build-capabilities.ps1
RUN powershell -Command ./dotnet-build-capabilities.ps1
RUN powershell -Command ./azure-deployment-capabilities.ps1

FROM  $target

ARG src="C:\Program Files\nodejs\node.exe"
ARG target="C:\Program Files\nodejs/"
COPY --from=installer ${src} ${target}

ARG src="C:\Program Files\dotnet/"
ARG target="C:\Program Files\dotnet/"
COPY --from=installer ${src} ${target}

ARG src="C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2/"
ARG target="C:\Program Files\azure-cli/"
COPY --from=installer ${src} ${target}

USER ContainerAdministrator
RUN setx /M PATH "%PATH%C:\Program Files\nodejs\;C:\Program Files\dotnet\;C:\Program Files\azure-cli\wbin/"
USER ContainerUser

SHELL ["pwsh", "-c", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENTRYPOINT [ "cmd","/c ping -t localhost > NUL" ]