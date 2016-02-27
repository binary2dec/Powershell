#Tile: Active Directory User Audit
#Description: Gather information about a list of users and export to CSV
#Author: JM
#Date: 1-8-2016
#Version: 1.0
#Usage: Ensure that the Data folder is created in the root of C.  Run as is 
#Notes: NA
#PowerShell Version: v4

Get-Module ActiveDirectory

$objUser = Import-Csv -Path C:\data\GUSRAudit.csv

$objArray = @()

Foreach ($x in $objUser) 
        {
          $objArrayUsers = Get-ADUser -identity $x.account -Properties * | select SamAccountName, Office, Department, EMailAddress, Company, Title

         
          
          Foreach ($User in $ObjArrayUsers) 
            {
            $objObject = New-Object PSObject -Property @{
                                                 "SamAccountName" = $User.samaccountname
                                                 "Office" = $User.office
                                                 "Department" = $User.Department
                                                 "EmailAddress" = $User.EmailAddress
                                                 "Company" = $User.Company
                                                 "Title" = $User.Title
                                            }
                 
            $ObjArray += $ObjObject
                
            }
        }

$ObjArray | Export-Csv "C:\DATA\newgusr.csv" -NoTypeInformation