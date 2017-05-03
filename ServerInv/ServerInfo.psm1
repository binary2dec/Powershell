Function Get-MachineInfo {

[CmdletBinding()]
Param (
        [Parameter(Mandatory = $True,
                   ValueFromPipelineByPropertyName=$True,
                   ValueFromPipeline=$True)]
        [string[]]$ComputerName = 'localhost',
        
        [string]$Protocol = "Wsman"
)

Foreach ($computer in $computername) {

#Kerberos vs NTLM
    if ($protocol -eq 'Dcom') {
        $Option = New-CimSessionOption -Protocol Dcom
        }else{
        $Option = New-CimSessionOption -Protocol Wsman
        }

#connect session

    $session = New-CimSession -ComputerName $ComputerName -SessionOption $session

#data

    $processor = Get-WmiObject -ComputerName $ComputerName -class win32_Processor | select caption,Name,SocketDesignation -First 1
    $os = Get-WmiObject -ComputerName $ComputerName -class win32_operatingsystem | select buildnumber, version
    $video = Get-WmiObject -Class win32_videocontroller | select Videoprocessor, AdapterRam
    $memory = Get-WmiObject -Class win32_Physicalmemory | select Name, BankLabel, ConfiguredClockSpeed, capacity

#output data

    $props = @{'Computername' = $env:COMPUTERNAME
               'Processor Name' = $processor.name
               'Processor Socket' = $processor.socketdesignation
               'OperatingSystem Build' = $os.buildnumber
               'OperatingSystem Version' = $os.version
               'Video Card Info' = $video.videoprocessor
               'Video Card Memory' = $video.AdapaterRam
               'Memory Name' = $memory.Name
               'Memory Bank' = $memory.Bank
               'Memory Clock Speed' = $memory.ConfiguredClockSpeed
               'Memory Size' = $memory.capacity
               }
        $obj = New-Object -TypeName PSObject -Property $props
        Write-Output $obj       

}#foreach

}#function