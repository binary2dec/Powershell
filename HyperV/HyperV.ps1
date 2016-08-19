<#
Tile: VM Creation (Differencing Disk) 
Description: Creates a virtual machine based on the master differencing disk
Author: JM
Date: 8-18-2016
Version: 1.0
Usage: 
Notes: NA
#>

Function CreateVM {
    
    $VHDinput = Read-Host -Prompt 'What is the name of the virtual machine?'
    $VHDpath = "F:\Hyper-V\Virtual Hard Drives\$VHDinput.vhdx"
    New-VHD -Path $VHDpath -Differencing -ParentPath "F:\Hyper-V\ParentDiffVM\ParentDiffVM\Virtual Hard Disks\ParentDiffVM.vhdx"

    New-VM -Name $VHDinput -VHDPath $VHDpath -MemoryStartupBytes 1GB



}

CreateVM