Skip to content
This repository
Search
Pull requests
Issues
Gist
 @binary2dec
 Unwatch 1
  Star 0
  Fork 0 binary2dec/Powershell
 Code  Issues 0  Pull requests 0  Projects 0  Wiki  Pulse  Graphs  Settings
Branch: master Find file Copy pathPowershell/ActiveDirectory/PasswordPolicyRemote.ps1
f6f8316  4 minutes ago
@jmanzzullo jmanzzullo added If/else statements
1 contributor
RawBlameHistory     
144 lines (90 sloc)  4.04 KB
<#
 .SYNOPSIS
    Queries Servers for their password and lockout policy
 .DESCRIPTION
    This script will run against all enabled computer objects in Active Directory and query Password and Lockout Policy
.INPUTS
    <Inputs if any, otherwise none>
.OUTPUTS
    
    <Outputs if any, otherwise none>
.NOTES
    Version: 1.0
    Author: Binary2Dec
    Creation Date: 9-19-2016
    Purpose/Change
.EXAMPLE
#>



Function Get-PasswordPolicy { #Begin Function
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False,Position=1)]
    [string] $ComputerName
        )    



Begin {

#Verify ActiveDirectory Module is loaded into shell
If (!(Get-Module -Name "ActiveDirectory")) { #start if statement
                    Import-Module ActiveDirectory

                       } #End If statement

#$ErrorActionPreference is normally set to "Continue", this will set the variable to SilentlyContinue
$ErrorActionPreference = "SilentlyContinue"




}

Process {

$Array = @()
$BadArray = @()

$Record = @{ #begin hash

"Hostname" = ""
"Minimum Password Age" = ""
"Maximum Password Age" = ""
"Minimum Password Length" = ""
"Password History Length" = ""
"Password Lockout Threshold" = ""
"Password Lockout Duration" = ""
"Password Lockout Observation" = ""

}#end hash


$ServerList = Get-ADComputer -Filter * -Properties * | Where-Object {$_.Enabled -eq $true} | Select-Object Name

ForEach ($x in $ServerList) { #Begin Foreach Loop

    Try {#Begin Try
            #Command variable leveraging a here string to grab net accounts
            
            $Invoke = Invoke-Command -ComputerName $x.name {net accounts}
            

            #Populate Net Account variables while inside foreach loop

            $ServerName = $x.name
            $MinPassAge = ($Invoke[1]).Substring(54) #This is the length of the minumum password age in days
            $MaximumPassAge = ($Invoke[2]).Substring(54) #This is the length of the maximum password age in days
            $MinPassLength = ($Invoke[3]).Substring(54) #This is the length of the minimum password length in days
            $PassHistory = ($Invoke[4]).Substring(54) #This is the length of the password history maintained
            $PassLockThresh = ($Invoke[5]).Substring(54) #This is the length of the lockout threshold
            $PassLockDur = ($Invoke[6]).Substring(54) #This is the length of the lockout duration in minutes
            $PassLockObs = ($Invoke[7]).Substring(54) #This is the length of the lockout observation windows in minutes

            #Poputlate Hash Table

            $Record."Hostname" = $ServerName
            $Record."Minimum Password Age" = $MinPassAge
            $Record."Maximum Password Age" = $MaximumPassAge
            $Record."Minimum  Password Length" = $MinPassLength
            $Record."Password History Length" = $PassHistory
            $Record."Password Lockout Threshold" = $PassLockThresh
            $Record."Password Lockout Duration" = $PassLockDur
            $Record."Password Lockout Observation" = $PassLockObs

            If ($Record."Minimum Password Age" -ne "15" -or $Record."Maximum Password Age" -ne "90" -or $Record."Minimum  Password Length" -ne "8" -or $Record."Password History Length" -ne "8"`
                -or $Record."Password Lockout Threshold" -ne "4" -or $Record."Password Lockout Duration" -ne "30" -or $Record."Password Lockout Observation" -ne "10" )

                {#Begin If
                
                $ObjThrown = New-Object PSObject -Property $Record
                $BadArray += $Objthrown
               
                Write-Host -ForegroundColor Cyan ""$Record.Hostname" is not compliant"
                
                }#End If

            Else
                {#Begin Else
                #Create Object
                $ObjRecord = New-Object PSObject -Property $Record

                #Populate Array
                $Array += $ObjRecord
                }#End Else


       } #End Try

    Catch   {#Start Catch
    
            $Status = "Inaccessible"
    
            }#End Catch


} #End ForEach Loop



}

End {

Write-Host -ForegroundColor "Green"  $Array
Write-Host -ForegroundColor "Blue"   $BadArray

}






} # End Function

Get-PasswordPolicy
