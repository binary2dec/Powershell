#Tile: Active Directory Backup 
#Description: This script performs a basic Active Directory Backup and saves the content in CSV format.  This will allow DSC to pull from the data.
#Author: JM
#Date: 2-27-2016
#Version: 1.0
#Usage: Each function can be run independently or this can be saved as a PSM1.  
#Notes: NA

Function BackupLocation {

                        $GLobal:ObjTarDirectory = "C:\Data\ActiveDirectoryBackup\"
                        

                            If(!(Test-Path -Path $objTarDirectory)){
                               New-Item -ItemType Directory -path $ObjTarDirectory
                                        }
                        }

Function BackupADUsers {

                        Import-Module ActiveDirectory

                        Get-ADUser -Filter {Enabled -eq $True}| select GivenName, Surname, DisplayName, SamAccountName, Description, DistinguishedName, UserPrincipalName, Title, Mail, Office, Company, Department | Export-Csv -Path $ObjTarDirectory\ADuser.csv -NoTypeInformation
                        }

Function BackupADOU {

                        Get-ADOrganizationalUnit -Filter 'Name -like "*"' | select Name, DistinguishedName  | Export-Csv -Path $ObjTarDirectory\OU.csv -NoTypeInformation
                    }

Function BackupGroupPolicy {


If(!(Test-Path -Path $objTarDirectory\GroupPolicyBackup)){
                                          New-Item -ItemType Directory -path $ObjTarDirectory\GroupPolicyBackup
                                        }

Backup-Gpo -All -Path $ObjTarDirectory\GroupPolicyBackup  -Comment "Monthly Backup" 


#Get Group Policy Links and GUID associations
$ObjOU = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | Select Name, DistinguishedName
$LinkedGPOs = Get-ADOrganizationalUnit -Filter 'Name -like "*"' | select  -ExpandProperty LinkedGroupPolicyObjects            
$GUIDRegex = "{[a-zA-Z0-9]{8}[-][a-zA-Z0-9]{4}[-][a-zA-Z0-9]{4}[-][a-zA-Z0-9]{4}[-][a-zA-Z0-9]{12}}"            

$ObjArray = @()
$ObjArrayReport = @()

$Record = @{

            "GPOName" = ""
            "LinksTo" = ""
            "Enabled" = ""
            "NoOverride" = ""
            "CreatedDate" = ""
            "ModifiedDate" = ""
            
            } 



foreach($x in $LinkedGPOs) {            
    $result = [Regex]::Match($x,$GUIDRegex);            
    if($result.Success) {            
        $GPOGuid = $result.Value.TrimStart("{").TrimEnd("}")            
        $objResult = Get-GPO -Guid $GPOGuid  
        $objArray += $objResult 
                 
    }     
    
     
       
}

If(!(Test-Path -Path $objTarDirectory\GroupPolicyLink)){
                                          New-Item -ItemType Directory -path $ObjTarDirectory\GroupPolicyLink
                                        }

$ObjArray | Export-Csv -path "$ObjTarDirectory\GroupPolicyLink\GroupPolicyGUID.csv" -NoTypeInformation 

Foreach ($x in $ObjArray.DisplayName)  {

                                        [xml]$report = Get-GPOReport -Name $x -ReportType Xml -ErrorAction Stop

                                      

                                           $ObjRecord = New-Object PSObject -Property $Record
                                           $Record."GPOName" = $report.GPO.Name
                                           $Record."LinksTo" = $report.GPO.LinksTo.SOMName
                                           $Record."Enabled" = $report.GPO.LinksTo.Enabled
                                           $Record."NoOverride" = $report.GPO.LinksTo.NoOverride
                                           $Record."CreatedDate" = ([datetime]$report.GPO.CreatedTime).ToShortDateString()
                                           $Record."ModifiedDate" = ([datetime]$report.GPO.ModifiedTime).ToShortDateString()

                                          $ObjArrayReport += $ObjRecord

}
$ObjArray | Export-Csv -path "$ObjTarDirectory\GroupPolicyLink\GroupPolicyLinksto.csv" -NoTypeInformation
}