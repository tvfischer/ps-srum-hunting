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
Function Get-SRUMDB{
  Param(
    [Parameter(Position=0,Mandatory = $true,
     ParameterSetName = "SRUMDBPath")]
    [ValidateNotNull()]
    $srumdbpath
  )

  Begin{
  }

  Process{
    Try{
      # we are assuming the EsentDll is already loaded
      ## Point the JET methods to the database file
      [System.Int32]$FileType = -1
      [System.Int32]$PageSize = -1
      [Microsoft.Isam.Esent.Interop.Api]::JetGetDatabaseFileInfo($srumdbpath, [ref]$PageSize, [Microsoft.Isam.Esent.Interop.JET_DbInfo]::PageSize)
      [Microsoft.Isam.Esent.Interop.Api]::JetGetDatabaseFileInfo($srumdbpath, [ref]$FileType, [Microsoft.Isam.Esent.Interop.JET_DbInfo]::FileType)
      [Microsoft.Isam.Esent.Interop.JET_filetype]$DBType = [Microsoft.Isam.Esent.Interop.JET_filetype]($FileType)

      # Need to check if we have database DBType (Will add later)
      ## To access the database we need to open a JET session
      [Microsoft.Isam.Esent.Interop.JET_INSTANCE]$Instance = New-Object -TypeName Microsoft.Isam.Esent.Interop.JET_INSTANCE
      [Microsoft.Isam.Esent.Interop.JET_SESID]$Session = New-Object -TypeName Microsoft.Isam.Esent.Interop.JET_SESID
      $Temp = [Microsoft.Isam.Esent.Interop.Api]::JetSetSystemParameter($Instance, [Microsoft.Isam.Esent.Interop.JET_SESID]::Nil, [Microsoft.Isam.Esent.Interop.JET_param]::DatabasePageSize, $PageSize, $null)
      $Temp = [Microsoft.Isam.Esent.Interop.Api]::JetSetSystemParameter($Instance, [Microsoft.Isam.Esent.Interop.JET_SESID]::Nil, [Microsoft.Isam.Esent.Interop.JET_param]::Recovery, [int]$Recovery, $null)
      $Temp = [Microsoft.Isam.Esent.Interop.Api]::JetSetSystemParameter($Instance, [Microsoft.Isam.Esent.Interop.JET_SESID]::Nil, [Microsoft.Isam.Esent.Interop.JET_param]::CircularLog, [int]$CircularLogging, $null)
      [Microsoft.Isam.Esent.Interop.Api]::JetCreateInstance2([ref]$Instance, "Instance", "Instance", [Microsoft.Isam.Esent.Interop.CreateInstanceGrbit]::None)
      $Temp = [Microsoft.Isam.Esent.Interop.Api]::JetInit2([ref]$Instance, [Microsoft.Isam.Esent.Interop.InitGrbit]::None)
      [Microsoft.Isam.Esent.Interop.Api]::JetBeginSession($Instance, [ref]$Session, $UserName, $Password)

      ## Ok Now open the database
      [Microsoft.Isam.Esent.Interop.JET_DBID]$DatabaseId = New-Object -TypeName Microsoft.Isam.Esent.Interop.JET_DBID
      $Temp = [Microsoft.Isam.Esent.Interop.Api]::JetAttachDatabase($Session, $Path, [Microsoft.Isam.Esent.Interop.AttachDatabaseGrbit]::ReadOnly)
      $Temp = [Microsoft.Isam.Esent.Interop.Api]::JetOpenDatabase($Session, $Path, $Connect, [ref]$DatabaseId, [Microsoft.Isam.Esent.Interop.OpenDatabaseGrbit]::ReadOnly)
      $DatabaseId
      $Session
      $Connect  ### Important tells us if the database is accessible

      #Check the session information
    }

    Catch{
      # Something went wrong so return a big no way
      $DBType="Connection FAILED"
      Break
    }
    $dbconnect = [PSCustomObject]@{
      Instance=$Instance;
      Session=$Session;
      DatabaseId=$DatabaseId;
      Path=$Path;
      ConnectState=$Connect;
      DBType=$DBType;
      DBPageSize=$PageSize; DBFileType=$FileType}

    Write-Output -InputObject ($dbconnect)
    Return $dbconnect
  }

  End{
  }
}
