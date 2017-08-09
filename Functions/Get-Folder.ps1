Function Get-Folder {

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True)]
    [string[]]$Path

)#End Parameter

BEGIN {

$VerbosePreference = "continue"
}


PROCESS{
        Foreach ($Folder in $Path) { 
            Write-Verbose "Checking $Folder"
            if (Test-Path -Path $Folder) {
                Write-Verbose " + Path Exists"
                
            } else {
            Write-Verbose " - Path does not exist"

            }#end if statement



}#end foreach


}#end process


END{}





} #End get folder