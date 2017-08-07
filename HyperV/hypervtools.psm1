
Function New-LbVhd {
[CmdletBinding()]
 Param (
        [Parameter(Mandatory = $True)]
        [string]$VMName,
        
        [uint64]$MemStart = 2GB     
 )


#Executions

#set switch
$switch = Get-VMSwitch -Name *external* | select -ExpandProperty Name

#create initial vm without hard disk
New-VM -Name $VMName -MemoryStartupBytes $MemStart -SwitchName $switch -Path  "F:\Hyper-V\"

#create virtual hard disks folder
$Folder = New-Item -ItemType Directory -Path "F:\Hyper-V\$VMName\Virtual Hard Disks"

#variable for hard disk folder
$vhdpath = "F:\Hyper-V\$VMName\Virtual Hard Disks"

#copy template hard drive to destination folder and change name
Copy-Item -Path 'F:\Hyper-V\Virtual Hard Disks\Windows 2016 Core Template\core-2016.vhd' -Destination $vhdpath\$VMName.vhd

Add-VMHardDiskDrive -VMName $VMName -Path $vhdpath\$vmName.vhd
 
}


