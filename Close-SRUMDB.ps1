<#
.NOTES
  Version:        1.0
  Author:         Thomas V Fischer
  Creation Date:  20190315
  Purpose/Change: Initial script development
.SYNOPSIS
   Script: Get-SRUMDB
   Open the SRUM database with ESENT DLL
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
Function Connect-SRUMDB{
  Param(
    [Parameter(Position=0,Mandatory = $true,
     ParameterSetName = "SRUMConnection")]
    [ValidateNotNull()]
    $SRUMDBConnection
  )

  Begin{
    #The input needs to be the object containing all the connection Parameters
    <# [PSCustomObject]@{
      JETState=$JETState;
      Instance=$Instance;
      Session=$Session;
      DatabaseId=$DatabaseId;
      Path=$Path;
      ConnectState=$Connect;
      DBType=$DBType;
      DBPageSize=$PageSize; DBFileType=$FileType}
    #>
    # Do a check avoid any bad calls.DESCRIPTION


  }

  Process{
    $DBPath = $SRUMDBConnection.Path
    Try{
      Write-Verbose -Message "Shutting down database ${DBPath} due to normal close operation."
      [Microsoft.Isam.Esent.Interop.Api]::JetCloseDatabase($SRUMDBConnection.Session, $SRUMDBConnection.DatabaseId, [Microsoft.Isam.Esent.Interop.CloseDatabaseGrbit]::None)
      [Microsoft.Isam.Esent.Interop.Api]::JetDetachDatabase($SRUMDBConnection.Session, $SRUMDBConnection.Path)
      [Microsoft.Isam.Esent.Interop.Api]::JetEndSession($SRUMDBConnection.Session, [Microsoft.Isam.Esent.Interop.EndSessionGrbit]::None)
      [Microsoft.Isam.Esent.Interop.Api]::JetTerm($SRUMDBConnection.Instance)
      Write-Verbose -Message "Completed shut down successfully."

    }
    Catch{
      # Something went wrong so return a big no way
      Write-Warning "Unable to cloase the session with the database ${DBPath}"
      return $false
    }

    #Write-Output -InputObject ($dbconnect)
    Write-Host "Connection to ${DBPath} status is closed"
    return $true
  }

  End{
  }
}
