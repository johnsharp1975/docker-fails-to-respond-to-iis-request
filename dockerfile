# escape=`
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8

WORKDIR C:\\inetpub\\wwwroot\\files
WORKDIR C:\\inetpub\\wwwroot\\web1
WORKDIR C:\\inetpub\\wwwroot\\web2
WORKDIR C:\\installers\\

RUN Import-Module ServerManager ; `
    Add-WindowsFeature Web-Scripting-Tools ; `
    Import-Module WebAdministration

RUN New-WebAppPool pe ; `
    New-WebAppPool pf ; `
    New-WebAppPool pg
# 	Set-ItemProperty -Path IIS:\AppPools\g -Name managedRuntimeVersion -Value ''

RUN Remove-IISSite -Name 'Default Web Site' -Confirm:$false ; `
    New-IISSite -Name 'e' -BindingInformation '*:2020:' -PhysicalPath 'C:\inetpub\wwwroot\files' ; `
    New-IISSite -Name 'f' -BindingInformation '*:2021:' -PhysicalPath 'C:\inetpub\wwwroot\web1' ; `
    New-IISSite -Name 'g' -BindingInformation '*:2022:' -PhysicalPath 'C:\inetpub\wwwroot\web2'

RUN Import-Module WebAdministration ; `
    Set-ItemProperty IIS:\sites\e -name applicationPool -value pe ; `
    Set-ItemProperty IIS:\sites\f -name applicationPool -value pf ; `
    Set-ItemProperty IIS:\sites\g -name applicationPool -value pg

RUN Get-IISSite

EXPOSE 2020
EXPOSE 2021
EXPOSE 2022

COPY *.htm c:\\inetpub\\wwwroot\\files\\
COPY large.htm c:\\inetpub\\wwwroot\\files\\large.js
COPY large.htm c:\\inetpub\\wwwroot\\files\\large.json
COPY large.htm c:\\inetpub\\wwwroot\\files\\large.css
COPY webapplication1\\webapplication1 c:\\inetpub\\wwwroot\\web1\\
COPY webapplication2\\webapplication2\\bin\\pubsite c:\\inetpub\\wwwroot\\web2\\
COPY installers c:\\installers\\

RUN Install-WindowsFeature Web-Mgmt-Service;
RUN New-ItemProperty -Path HKLM:\software\microsoft\WebManagement\Server -Name EnableRemoteManagement -Value 1 -Force
RUN net user iisadmin Password1234 /ADD;
RUN net localgroup administrators iisadmin /add
RUN net start wmsvc

# SHELL ["cmd"]
RUN c:/installers/dotnet-hosting-5.0.14-win.exe /quiet /install /log c:\\installers\\log.txt

ENTRYPOINT [ "powershell" ]
