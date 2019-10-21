<#
.NOTES
  Version:        1.0
  Author:         Thomas V Fischer
  Creation Date:  20190315
  Purpose/Change: Initial script development
.SYNOPSIS
   Script: Open-SRUMTable
   Open access to the table so we can read the contents
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
Function Open-SRUMTable{
  Param(
        [Parameter(Position=0,Mandatory = $true)]
        [ValidateNotNull()]
        $Session,
        ## Need to figure out if I should include the variable type [Microsoft.Isam.Esent.Interop.JET_SESID].
        ## Don't think so but using it might be safer to ensure proper variable is passed
        [Parameter(Position=1,Mandatory = $true)]
        [ValidateNotNull()]
        $DatabaseId,
        [Parameter(Position=2,Mandatory = $true)]
        [ValidateNotNull()]
        $TableName       
  )

  Begin{
  }

  Process{
    #set-up a state condition variable maybe in the future we can expand on state
    $JETState="OK"
    #Before we proceed, let's get all the table names and check it exists in the list if not leave.
    $TableNames = Get-SRUMTableNames $Session $DatabaseId

    if ( $TableNames.StatusID -ne 1) {
        $tableopen = [PSCustomObject]@{
        TableState="Unable to query table names";
        StatusID=2 }
        return $tableopen
      }
    if ( -Not($TableNames.Tables -Contains $TableName )){
        Write-Warning "${TableName} does not exist"
        $tableopen = [PSCustomObject]@{
        TableState="Table does not exist";
        StatusID=2 }
        return $tableopen
    }
    Try{
      
      [Microsoft.Isam.Esent.Interop.Table]$Table = New-Object -TypeName Microsoft.Isam.Esent.Interop.Table($Session, $DatabaseId, $TableName, [Microsoft.Isam.Esent.Interop.OpenTableGrbit]::None)
      $JETState="Table ${TableName} open"      
    }
    Catch{
      # Something went wrong so return a big no way
      $JETState="Something FAILED"
      Write-Warning "Unable to open database ${TableName}"
      $tableopen = [PSCustomObject]@{
         TableState=$JETState;
         StatusID=0 }
      Break
    }
    $tableopen = [PSCustomObject]@{
      StatusID = 1;
      TableState = $JETState;
      TableName = $TableName;
      TablePtr = $Table }

    #Write-Output -InputObject ($dbconnect)
    Write-Host "Table ${TableName} open status is ${JETState}"
    Return $tableopen
  }

  End{
  }
}
