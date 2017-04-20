<#
.NAME
 C:\Users\Binary2Dec\OneDrive\Git\Powershell\ServerInv\Get-AppInventory.ps1
.SYNOPSIS
Get-AppInventory retrieves application information from one or more computers.
.DESCRIPTION
Get-AppInventory uses WMI to retrieve win32_product instances from one or more computers.
.PARAMATER
.EXAMPLE
#>

[CmdletBinding()]
PARAM (
    [Parameter(Mandatory=$False)]
    [string]$computername = 'localhost',

    [Parameter(Mandatory=$True)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
)

Invoke-Command -Credential $Credential -Command {Get-WmiObject -Class win32_product -ComputerName $computername}
 