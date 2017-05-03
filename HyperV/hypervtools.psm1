
Function Set-LbVhd {
[CmdletBinding()]
 Param (
        [uint64]$SizeBytes = 30GB,
        
        
        [string]$Path ,

        [string]$VHDName      

 )


if (!$Path) {
                $Path = (Read-Host -Prompt "Please enter a valid vhd path" )

} #if

#Command

New-VHD -SizeBytes $SizeBytes -Path $Path -Dynamic 

}

Set-LbVhd 
