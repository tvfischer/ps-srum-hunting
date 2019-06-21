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
        [Parameter(Position=0,Mandatory = $true),
        ParameterSetNAme = "Session"]
        [ValidateNotNull()]
        $Session
  )

  Begin{
  }

  Process{
    $DBNames = @()
    Try{
      [Microsoft.Isam.Esent.Interop.Api]::GetTableNames($Session, $DatabaseId)
    }

    Catch{
      Write-Output "Could not fetch table names"
      $TableNames = [PSCustomObject]@{StatusID=0;Status="Error";$DBNames}
      Break
    }
  }

  End{

  }
}
