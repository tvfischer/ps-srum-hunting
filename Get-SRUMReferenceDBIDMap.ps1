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
  This function retrieves the ID Map values and puts them into a table for mapping IDs with-in the other tables to values or constants
  Uses the SruDbIdMapTable and maps the id to a blob of data that is typed either as a string or as GUID
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>


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

