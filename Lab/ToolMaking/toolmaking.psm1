Function Set-TServiceLogon {
    [CmdletBinding()]
    Param(
   [Parameter(ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True,Mandatory=$True)]
    [string[]]$ComputerName,
    [string]$NewPassword,
    [string]$NewUserLogon,
    [string]$Errorlogpath,
    [string]$Protocol = "wsman",
    [string]$ServiceName,
    [switch]$ProtocolFallback
    )

Begin { #Nothing

}#end Begin

Process{
    foreach ($computer in $ComputerName) {
#Arguments

        if ($PSBoundParameters.ContainsKey('NewUserLogon')){
        $args = @{'StartName' = $NewUserLogon
                  'StartPassword' = $NewPassword}
        } #End if
            else {
                    $args = @{'StartPassword' = $NewPassword}
                } #End else

#Determine ProtocolOption

        if ($Protocol -eq "Dcom") {

        $option = New-CimSessionOption -Protocol Dcom -Verbose
        } #end if
            else {
            $option = New-CimSessionOption -Protocol Wsman -Verbose
                }#end else

#Create Sessison

    $session = New-CimSession -ComputerName $computer -SessionOption $option -Verbose

#Action = Call Change Method

    $SetService = Invoke-CimMethod -CimSession $session -MethodName Change -Query "SELECT * FROM Win32_Service WHERE Name = '$ServiceName' " -Arguments $args -ErrorAction SilentlyContinue -Verbose

#Logging
    $log = @{'ComputerName' = $computer
        'ReturnValue' = $($SetService.ReturnValue) }

    $log | ConvertTo-Json | Add-Content -Path "C:\data\log.json"

#Remove Session
    $session | Remove-CimSession

    } #end foreach
        } #end 
            } #end Process


#Set-TServiceLogon -ComputerName "ms01" -ServiceName "spooler" -NewUserLogon "Local Service" 

