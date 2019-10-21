<#
.NOTES
  Version:        1.01
  Author:         Thomas V Fischer
  Creation Date:  20190315
  Purpose/Change: Initial script development
.SYNOPSIS
   Script: Get-SRUMTableColumnNames
   Once a session has been created to the SRUMDB, we can pull out the table name references.
   This function uses the Jet session to query database for which tables are available and returns a list of table names
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
Function Get-SRUMTableNames{
  Param(
        [Parameter(Position=0,Mandatory = $true)]
        [ValidateNotNull()]
        $Session,
        ## Need to figure out if I should include the variable type [Microsoft.Isam.Esent.Interop.JET_SESID].
        ## Don't think so but using it might be safer to ensure proper variable is passed
        [Parameter(Position=1,Mandatory = $true)]
        [ValidateNotNull()]
        $DatabaseId
  )

  Begin{
  }

  Process{
    $TableNames = [PSCustomObject]@{StatusID=0;Status="";Tables=@()}
    $DBNames = @()
    Try{
      $DBNames = [Microsoft.Isam.Esent.Interop.Api]::GetTableNames($Session, $DatabaseId)
    }
    Catch{
      Write-Warning "Could not fetch table names"
      $TableNames.StatusID=0
      $TableNames.Status="Error"
      $TableNames
      Break
    }
    $TableNames.StatusID=1
    $TableNames.Status="OK"
    $TableNames.Tables=$DBNames
    return $TableNames
  }

  End{

  }
}
