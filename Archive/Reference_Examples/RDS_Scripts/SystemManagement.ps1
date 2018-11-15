#Requires -version 2.0

# ***************************************************************************
# 
# File:      SystemManagement.ps1
#
# Version:   1.0
# 
# Author:    Michael Niehaus 
# 
# Purpose:   Create the AD "System Management" container needed for
#            ConfigMgr 2007 and 2012, and grant access to the current
#            computer account.
#
#            This requires PowerShell 2.0 and Windows Server 2008 R2.
#
# Usage:     Run this script as a domain administrator, from the ConfigMgr
#            server.  No parameters are required.
#
# ------------- DISCLAIMER -------------------------------------------------
# This script code is provided as is with no guarantee or waranty concerning
# the usability or impact on systems and may be used, distributed, and
# modified in any way provided the parties agree and acknowledge the 
# Microsoft or Microsoft Partners have neither accountabilty or 
# responsibility for results produced by use of this script.
#
# Microsoft will not provide any support through any means.
# ------------- DISCLAIMER -------------------------------------------------
#
# ***************************************************************************

# Load the AD module

Import-Module ActiveDirectory


# Figure out our domain

$root = (Get-ADRootDSE).defaultNamingContext


# Get or create the System Management container

$ou = $null
try
{
    $ou = Get-ADObject "CN=System Management,CN=System,$root"
}
catch
{
    Write-Verbose "System Management container does not currently exist."
}

if ($ou -eq $null)
{
    $ou = New-ADObject -Type Container -name "System Management" -Path "CN=System,$root" -Passthru
}


# Get the current ACL for the OU

$acl = get-acl "ad:CN=System Management,CN=System,$root"


# Get the computer's SID

$computer = get-adcomputer $env:ComputerName
$sid = [System.Security.Principal.SecurityIdentifier] $computer.SID


# Create a new access control entry to allow access to the OU

$ace = new-object System.DirectoryServices.ActiveDirectoryAccessRule $sid, "All"


# Add the ACE to the ACL, then set the ACL to save the changes

$acl.AddAccessRule($ace)
Set-acl -aclobject $acl "ad:CN=System Management,CN=System,$root"

