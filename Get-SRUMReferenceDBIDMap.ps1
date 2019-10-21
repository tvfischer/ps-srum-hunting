<#
.NOTES
  Version:        1.0
  Author:         Thomas V Fischer
  Creation Date:  20190315
  Purpose/Change: Initial script development
.SYNOPSIS
   Script: Get-SRUMReferenceDBIDMap
   Open the SRUM database with ESENT DLL
.DESCRIPTION
  This function retrieves the ID Map values and puts them into a table for mapping IDs with-in the other tables to values or constants
  Uses the SruDbIdMapTable and maps the id to a blob of data that is typed either as a string or as GUID
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS

.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>

<# The SruDbIdMapTable
    The database is configured as follows
        Name    Columnid                  Coltyp   Cp MaxLength DefaultValue                            Grbit
        ----    --------                  ------   -- --------- ------------                            -----
        IdBlob  JET_COLUMNID(0x100)   LongBinary None         0                                  ColumnTagged
        IdIndex JET_COLUMNID(0x2)           Long None         4              ColumnFixed, ColumnAutoincrement
        IdType  JET_COLUMNID(0x1)   UnsignedByte None         1                                   ColumnFixed
    Important here is the IdType which determines what is in the IdBlob
    IdType configued as follows:
        Value   Id                         Description
        -----   ------------               ----------------------
        0       Application Path++???      IdBlob contains an UTF-16 enconded string
        1       Services ???               IdBlob contains an UTF-16 enconded string
        2       MSApps, Service-SubProc    IdBlob contains an UTF-16 enconded string
        3       User Identifier            IdBlob contains a Windows NT Security Identifier (SID)

#>
Function Get-SRUMReferenceDBIDMap{
  Param(
      [Parameter(Position=0,Mandatory = $true)]
      [ValidateNotNull()]
      $Session,
        ## Need to figure out if I should include the variable type [Microsoft.Isam.Esent.Interop.JET_SESID].
        ## Don't think so but using it might be safer to ensure proper variable is passed
      [Parameter(Position=1,Mandatory = $true)]
      [ValidateNotNull()]
      $DatabaseId,
      # Optional 3rd parameter is the name of the database, defaults to SruDbIdMapTable using this mechanism in case it changes in the future
      [Parameter(Position=2,Mandatory = $false)]
      [ValidateNotNull()]
      $TableName="SruDbIdMapTable"
  )

  Begin{
  }

  Process{
    #set-up a state condition variable maybe in the future we can expand on state
    $JETState="OK"
    #Open the table
    $PtrTable = Open-SRUMTable $Session $DatabaseId $TableName 
    Write-Host $PtrTable
    if ( $PtrTable.StatusID -ne 1 ){
        Write-Warning "Unable to access ${TableName}"
        return $false,"${TableName} not available"        
    }
    
    Try{
      $theData = @()
      $AppsSRUM = @()
      $SvcAPPS = @()
      $MSAppSRUM = @()
      $uidSRUM = @()
      Write-Progress -id 1 -Activity "Fetching the rows from table ${TableName}" -Status "This may take awhile so hold on..."
      # OK Let's get all the rows from the DbIdMap and then we can process them into separate objects
      $theData = Get-SRUMTableDataRows $Session $PtrTable.TablePtr
      if ( $theData.Count -eq 0) {
        #We didn't read the table no records found
        Write-Warning "No records in ${TableName}"
        return $false,"No records in ${TableName}"      
      }
      $j=1
      $totalProc = $theData.Count
      #We have data now let's split it apart
      $theData | foreach-object {
        $tIdType = [Int]$_.IdType
        $tIdIndex = $_.IdIndex
        $tIdBlob = $_.IdBlob
        Write-Progress -id 1 -Activity "Processing the rows and building the " -Status ("Processin {0:N0} of {1:N0}" -f $j, $totalProc) -PercentComplete ([Int](($j/$totalProc) * 100)) -CurrentOperation ("Index ID: {0} Index Type: {1}" -f $tIdIndex, $tIdType)
        switch($tIdType) {
            0 { #this is an application path reference
                $Row = New-Object PSObject
                #The index value is the reference used in other tables
                $Row | Add-Member -type NoteProperty -name Index -Value $tIdIndex
                $Row | Add-Member -type NoteProperty -name Application -Value $tIdBlob
                $AppsSRUM += $Row
             }
            1 { #this is the windows service reference
                $Row = New-Object PSObject
                #The index value is the reference used in other tables
                $Row | Add-Member -type NoteProperty -name Index -Value $tIdIndex
                $Row | Add-Member -type NoteProperty -name ServiceName -Value $tIdBlob
                $SvcAPPS += $Row
             }             
            2 { #this is the MSApp or Subservice reference 
                $Row = New-Object PSObject
                #The index value is the reference used in other tables
                $Row | Add-Member -type NoteProperty -name Index -Value $tIdIndex
                $Row | Add-Member -type NoteProperty -name MSAppName -Value $tIdBlob
                $MSAppSRUM += $Row
             }        
            3 { #this is the UID reference 
                $Row = New-Object PSObject
                #The index value is the reference used in other tables
                $Row | Add-Member -type NoteProperty -name Index -Value $tIdIndex
                #This is going to need further processing
                $Row | Add-Member -type NoteProperty -name GUID -Value $tIdBlob
                $uidSRUM += $Row
             }
           default { #ok Something is wrong, this shouldn't happen
                Write-Warning ("Found an index type of {0} dropping index {1}" -f $tIdType, $tIdIndex)
            }     
        }
        $j++
      }
      
    }
    Catch{
      # Something went wrong so return a big no way
      Write-Warning "Unable to process the reference database"
      return $false,"Something Failed processing the data"
    }

    return $true, $AppsSRUM, $SvcAPPS, $MSAppSRUM, $uidSRUM
  }

  End{
  }
}
