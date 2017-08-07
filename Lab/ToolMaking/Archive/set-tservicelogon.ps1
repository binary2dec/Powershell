Function Set-TServiceLogon {

Param(
    [string[]]$ComputerName,
    [string]$NewPassword,
    [string]$NewUserLogon,
    [string]$StartName,
    [string]$Errorlogpath,
    [string]$Protocol = "wsman",
    [string]$ServiceName,
    [switch]$ProtocolFallback
    )


foreach ($computer in $ComputerName) {
$computer | Add-Content -Path 'C:\Data\log.txt' -Verbose
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
} 
else {
    $Option = New-CimSessionOption -Protocol Wsman -Verbose
}#end else

#Create Sessison

$session = New-CimSession -ComputerName $computer -SessionOption $option -Verbose

#Action = Call Change Method

$SetService = Invoke-CimMethod -CimSession $session -MethodName Change -Query "SELECT * FROM Win32_Service WHERE Name = '$ServiceName' " -Arguments $args -ErrorAction SilentlyContinue -Verbose

#Logging
$log = @{'ComputerName' = $computer
        'ReturnValue' = $($SetService.ReturnValue) }

$log | ConvertTo-Json | Add-Content -Path "C:\data\log.json"

#DataOutput
} #end foreach
} #end 

Set-TServiceLogon -ComputerName "ms01" -ServiceName "spooler" -NewUserLogon "Local Service" 