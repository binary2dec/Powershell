Function Set-TMServiceLogon
{
    Param(
        [String]$ServiceName,
        [String[]]$ComputerName,
        [String]$NewPassword,
        [String]$NewUser,
        [String]$ErrorLogFilePath

    )

Foreach ($Computer in $Computername) {

        $option = New-CimSessionOption -Protocol Wsman
        $session = New-CimSession -SessionOption $option -ComputerName $Computer  

        If ($PSBoundParameters.ContainsKey('NewUser')) {
                $args = @{'StartName' = $NewUser
                          'StartPassword' = $NewPassword}
        } Else {
                $args = @{'StartPassword' = $NewPassword}

        }#else

        Invoke-CimMethod -ComputerName $Computer -MethodName Change -Query "SELECT * FROM Win32_Service WHERE Name = $ServiceName" `
                         -Arguments $arg | Select-Object -Property @{n='ComupterName';e={$Computer}},
                                                                   @{n='Result';e={$_.ReturnValue}}

        $session | Remove-CimSession

        }#foreach




} #function



