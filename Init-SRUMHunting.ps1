<#
.NOTES
  Version:        1.0
  Author:         Thomas V Fischer
  Creation Date:  20190315
  Purpose/Change: Initial script development
.SYNOPSIS
   Script: Init-SRUMHunting
   This script helps to initialise the needed tools and constants to be able to open and process the SRUM database
.DESCRIPTION
  <Brief description of script>
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>


.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>
#####################################################################################
#                Declarations
#####################################################################################
#Script Version
$sScriptVersion = "0.1"
#$sDebug = $DebugMode

#####################################################################################
#                Initialisations
#####################################################################################
$StdSIDS = @(
    [pscustomobject]@{SID="S-1-5-32-545";Name="Users"},
    [pscustomobject]@{SID="S-1-5-32-544";Name="Administrators"},
    [pscustomobject]@{SID="S-1-5-32-547";Name="Power Users"},
    [pscustomobject]@{SID="S-1-5-32-546";Name="Guests"},
    [pscustomobject]@{SID="S-1-5-32-569";Name="BUILTIN\Cryptographic Operators"},
    [pscustomobject]@{SID="S-1-16-16384";Name="System Mandatory Level "},
    [pscustomobject]@{SID="S-1-5-32-551";Name="Backup Operators"},
    [pscustomobject]@{SID="S-1-16-8192";Name="Medium Mandatory Level "},
    [pscustomobject]@{SID="S-1-5-80";Name="NT Service "},
    [pscustomobject]@{SID="S-1-5-32-548";Name="Account Operators"},
    [pscustomobject]@{SID="S-1-5-32-561";Name="BUILTIN\Terminal Server License Servers"},
    [pscustomobject]@{SID="S-1-5-64-14";Name="SChannel Authentication "},
    [pscustomobject]@{SID="S-1-5-32-562";Name="BUILTIN\Distributed COM Users"},
    [pscustomobject]@{SID="S-1-5-64-21";Name="Digest Authentication "},
    [pscustomobject]@{SID="S-1-5-19";Name="NT Authority"},
    [pscustomobject]@{SID="S-1-3-0";Name="Creator Owner"},
    [pscustomobject]@{SID="S-1-5-80-0";Name="All Services "},
    [pscustomobject]@{SID="S-1-5-20";Name="NT Authority"},
    [pscustomobject]@{SID="S-1-5-18";Name="Local System"},
    [pscustomobject]@{SID="S-1-5-32-552";Name="Replicators"},
    [pscustomobject]@{SID="S-1-5-32-579";Name="BUILTIN\Access Control Assistance Operators"},
    [pscustomobject]@{SID="S-1-16-4096";Name="Low Mandatory Level "},
    [pscustomobject]@{SID="S-1-16-12288";Name="High Mandatory Level "},
    [pscustomobject]@{SID="S-1-2-0";Name="Local "},
    [pscustomobject]@{SID="S-1-16-0";Name="Untrusted Mandatory Level "},
    [pscustomobject]@{SID="S-1-5-3";Name="Batch"},
    [pscustomobject]@{SID="S-1-5-2";Name="Network"},
    [pscustomobject]@{SID="S-1-5-1";Name="Dialup"},
    [pscustomobject]@{SID="S-1-5-7";Name="Anonymous"},
    [pscustomobject]@{SID="S-1-5-6";Name="Service"},
    [pscustomobject]@{SID="S-1-5-4";Name="Interactive"},
    [pscustomobject]@{SID="S-1-5-9";Name="Enterprise Domain Controllers"},
    [pscustomobject]@{SID="S-1-5-8";Name="Proxy"},
    [pscustomobject]@{SID="S-1-5-32-550";Name="Print Operators"},
    [pscustomobject]@{SID="S-1-0-0";Name="Nobody"},
    [pscustomobject]@{SID="S-1-5-32-559";Name="BUILTIN\Performance Log Users"},
    [pscustomobject]@{SID="S-1-5-32-578";Name="BUILTIN\Hyper-V Administrators"},
    [pscustomobject]@{SID="S-1-5-32-549";Name="Server Operators"},
    [pscustomobject]@{SID="S-1-2-1";Name="Console Logon "},
    [pscustomobject]@{SID="S-1-3-1";Name="Creator Group"},
    [pscustomobject]@{SID="S-1-5-32-575";Name="BUILTIN\RDS Remote Access Servers"},
    [pscustomobject]@{SID="S-1-3-3";Name="Creator Group Server"},
    [pscustomobject]@{SID="S-1-3-2";Name="Creator Owner Server"},
    [pscustomobject]@{SID="S-1-5-32-556";Name="BUILTIN\Network Configuration Operators"},
    [pscustomobject]@{SID="S-1-5-32-557";Name="BUILTIN\Incoming Forest Trust Builders"},
    [pscustomobject]@{SID="S-1-5-32-554";Name="BUILTIN\Pre-Windows 2000 Compatible Access"},
    [pscustomobject]@{SID="S-1-5-32-573";Name="BUILTIN\Event Log Readers "},
    [pscustomobject]@{SID="S-1-5-32-576";Name="BUILTIN\RDS Endpoint Servers"},
    [pscustomobject]@{SID="S-1-5-83-0";Name="NT VIRTUAL MACHINE\Virtual Machines"},
    [pscustomobject]@{SID="S-1-16-28672";Name="Secure Process Mandatory Level "},
    [pscustomobject]@{SID="S-1-5-11";Name="Authenticated Users"},
    [pscustomobject]@{SID="S-1-1-0";Name="Everyone"},
    [pscustomobject]@{SID="S-1-5-32-555";Name="BUILTIN\Remote Desktop Users"},
    [pscustomobject]@{SID="S-1-16-8448";Name="Medium Plus Mandatory Level "},
    [pscustomobject]@{SID="S-1-5-17";Name="This Organization "},
    [pscustomobject]@{SID="S-1-5-32-580";Name="BUILTIN\Remote Management Users"},
    [pscustomobject]@{SID="S-1-5-15";Name="This Organization "},
    [pscustomobject]@{SID="S-1-5-14";Name="Remote Interactive Logon "},
    [pscustomobject]@{SID="S-1-5-13";Name="Terminal Server Users"},
    [pscustomobject]@{SID="S-1-5-12";Name="Restricted Code"},
    [pscustomobject]@{SID="S-1-5-32-577";Name="BUILTIN\RDS Management Servers"},
    [pscustomobject]@{SID="S-1-5-10";Name="Principal Self"},
    [pscustomobject]@{SID="S-1-3";Name="Creator Authority"},
    [pscustomobject]@{SID="S-1-2";Name="Local Authority"},
    [pscustomobject]@{SID="S-1-1";Name="World Authority"},
    [pscustomobject]@{SID="S-1-0";Name="Null Authority"},
    [pscustomobject]@{SID="S-1-5-32-574";Name="BUILTIN\Certificate Service DCOM Access "},
    [pscustomobject]@{SID="S-1-5";Name="NT Authority"},
    [pscustomobject]@{SID="S-1-4";Name="Non-unique Authority"},
    [pscustomobject]@{SID="S-1-5-32-560";Name="BUILTIN\Windows Authorization Access Group"},
    [pscustomobject]@{SID="S-1-16-20480";Name="Protected Process Mandatory Level "},
    [pscustomobject]@{SID="S-1-5-64-10";Name="NTLM Authentication "},
    [pscustomobject]@{SID="S-1-5-32-558";Name="BUILTIN\Performance Monitor Users"}
)

#####################################################################################
#                Functions
#####################################################################################
#Dot Source required Function Libraries
#. "<filepath>.ps1"

<# Function TBD{
  Param()

  Begin{
  }

  Process{
    Try{
      <code goes here>
    }

    Catch{
       <code goes here>
      Break
    }
  }

  End{
    If($?){
       <code goes here>
    }
  }
}#>

## Code starts here
