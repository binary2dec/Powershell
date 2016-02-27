<#
Tile: Active Directory Backup 
Description: This script scrapes a single DNS Forward Lookup Zone and exports DNA "A" and "CNAME" records.
Author: JM
Date: 1-10-2016
Version: 1.0
Usage: User must provide ZoneName Parameter in order to use this script.  Example: C:\ActiveDirectoryDNS.ps1 -ZoneName <ZoneName>. Data folder in root of C must be present.
Notes: NA
#>

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$ZoneName)


$ObjArray = @()
$Record = @{ 
  "Hostname" = ""
  "RecordType" = ""
  "RecordData" = ""
  
}

$ArrayofArecords = Get-DnsServerResourceRecord -ZoneName $PSBoundParameters.ZoneName  | Where-Object {$_.recordtype -eq "A"}| select HostName, RecordType, @{Name='RecordData';Expression={$_.RecordData.IPv4Address.ToString()}} 
$ArrayofCNAMERecords = Get-DnsServerResourceRecord -ZoneName $PSBoundParameters.ZoneName  | Where-Object {$_.recordtype -eq "CNAME"}| select HostName, RecordType, @{Name='RecordData';Expression={$_.RecordData.HostNameAlias.ToString()}} 
Foreach ($x in $ArrayofArecords) {
                                    $Record."HostName" = $x.Hostname
                                    $Record."RecordType" = $x.RecordType
                                    $Record."RecordData"  = $x.RecordData

                                       $objRecord = New-Object PSObject -property $Record
                                       $objArray += $objrecord
                                       }

Foreach ($x in $ArrayofCNAMERecords) {
                                        $Record."HostName" = $x.Hostname
                                        $Record."RecordType" = $x.RecordType
                                        $Record."RecordData"  = $x.RecordData

                                       $objRecord = New-Object PSObject -property $Record
                                       $objArray += $objrecord
                                       }
                                       
$objArray | export-csv "C:\data\dns.csv" -NoTypeInformation