#Mount the TP5 Disk Image

$ServerISO = "C:\OperatingSystems\14300.1000.160324-1723.RS1_RELEASE_SVC_SERVER_OEMRET_X64FRE_EN-US.ISO"

$MountISO = Mount-DiskImage -ImagePath $ServerISO -PassThru

#Retrieve Mount Drive Letter
$MountDriveLetter = ($MountISO | Get-Volume).DriveLetter

$MediaPath = $MountDriveLetter + ':'


#Create Working Directory

$WorkingPath = "C:\NanoWorkingDirectory"

if(!(Test-Path -Path $WorkingPath )) {New-Item -ItemType Directory -Path $WorkingPath }

#Copy NanoServer folder from mountpoint

#Copy-Item -Path $MediaPath\NanoServer -Destination "$WorkingPath\" -Recurse

#Set location path

Set-Location $MediaPath\NanoServer

#Import Nano Server Image Generator Module

Import-Module .\NanoServerImageGenerator\NanoServerImageGenerator.psd1 -ErrorAction SilentlyContinue -force




$Password =  ConvertTo-SecureString -String "Neo6201417" -AsPlainText -Force

$BasePath = Join-Path $WorkingPath 'Base'



#Parameters

#Parameters

$Params = @{
    MediaPath = $MediaPath
    BasePath = $BasePath
    TargetPath = "$WorkingPath\NanoDSC.wim"
    MaxSize = 5GB
    #GuestDrivers = $true
    #ReverseForwarders = $true
    #Containers = $true
    #Defender = $true
    Packages = 'Microsoft-NanoServer-DSC-Package'
    EnableRemoteManagementPort = $true
    AdministratorPassword = $Password
    Verbose = $true
    Deployment = "Guest"
    Edition = "Standard"
    }

New-NanoServerImage @Params



Dismount-DiskImage -ImagePath $ServerISO
