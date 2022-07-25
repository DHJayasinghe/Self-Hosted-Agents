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
# RUN powershell -Command ./azure-deployment-capabilities.ps1

ENV PYTHON_VERSION 3.10.5
ENV PYTHON_HASH 9a99ae597902b70b1273e88cc8d41abd
ENV DESTINATION_FOLDER C:\\tools

RUN $python_url = ('https://www.python.org/ftp/python/{0}/python-{0}-amd64.exe' -f $env:PYTHON_VERSION); `
    Write-Host ('Downloading {0}...' -f $python_url); `
    mkdir tmp > $null; `
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; `
    (New-Object System.Net.WebClient).DownloadFile($python_url, 'c:\tmp\python-installer.exe'); `
    Write-Host ('Checking hash...' -f $python_url); `
    if ((Get-FileHash c:\tmp\python-installer.exe -Algorithm md5).Hash -ne $env:PYTHON_HASH) { Write-Host 'Python installer checksum verification failed!'; exit 1; }; `
    $install_folder = Join-Path -Path $env:DESTINATION_FOLDER -ChildPath 'python'; `
    Write-Host ('Installing into {0}...' -f $install_folder); `
    Start-Process c:\tmp\python-installer.exe -Wait -ArgumentList @('/quiet', 'InstallAllUsers=1', 'TargetDir={0}' -f $install_folder, 'PrependPath=1', 'Shortcuts=0', 'Include_doc=0','Include_pip=1', 'Include_test=0'); `
    Remove-Item tmp -Recurse -Force;

FROM  $target

ARG src="C:\Program Files\nodejs\node.exe"
ARG target="C:\Program Files\nodejs/"
COPY --from=installer ${src} ${target}

COPY --from=installer ["tools", "tools"]

ARG src="C:\Program Files\dotnet/"
ARG target="C:\Program Files\dotnet/"
COPY --from=installer ${src} ${target}

USER ContainerAdministrator
RUN setx /M PATH "%PATH%c:\tools\python\;c:\tools\python\Scripts\;C:\Program Files\nodejs\;C:\Program Files\dotnet\;c:\tools\AzCopy\;"

USER ContainerUser

SHELL ["pwsh", "-c", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR /cap

RUN python -m pip install --upgrade pip --no-cache-dir --disable-pip-version-check
RUN pip install azure-cli --no-cache-dir --disable-pip-version-check

RUN pwsh -c `
    Invoke-WebRequest -Uri "https://aka.ms/downloadazcopy-v10-windows" -OutFile AzCopy.zip -UseBasicParsing; `
    Expand-Archive ./AzCopy.zip ./AzCopy -Force; `
    New-Item "C:\tools\AzCopy" -itemType Directory; `
    Get-ChildItem ./AzCopy/*/azcopy.exe | Move-Item -Destination "C:\tools\AzCopy\AzCopy.exe"; `
    Remove-Item 'AzCopy' -Recurse -Force;

USER ContainerAdministrator

RUN pwsh -c [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

USER ContainerUser

WORKDIR /azp
COPY ./start.ps1 .

# CMD pwsh -c ./start.ps1
ENTRYPOINT [ "cmd","/c ping -t localhost > NUL" ]