<#
.NOTES
  Version:        1.0
  Author:         Thomas V Fischer
  Creation Date:  20190315
  Purpose/Change: Initial script development
.SYNOPSIS
   Script: Get-SRUMTableDataRows
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
}
