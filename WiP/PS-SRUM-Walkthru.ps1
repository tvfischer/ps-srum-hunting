$EsentDllPath = "$env:SYSTEMROOT\Microsoft.NET\assembly\GAC_MSIL\microsoft.isam.esent.interop\v4.0_10.0.0.0__31bf3856ad364e35\Microsoft.Isam.Esent.Interop.dll"
$Path="C:\Windows\System32\sru\SRUDB.dat"

## Access the database file
[System.Int32]$FileType = -1
[System.Int32]$PageSize = -1
Add-Type -Path $EsentDllPath
[Microsoft.Isam.Esent.Interop.Api]::JetGetDatabaseFileInfo($Path, [ref]$PageSize, [Microsoft.Isam.Esent.Interop.JET_DbInfo]::PageSize)
[Microsoft.Isam.Esent.Interop.Api]::JetGetDatabaseFileInfo($Path, [ref]$FileType, [Microsoft.Isam.Esent.Interop.JET_DbInfo]::FileType)
[Microsoft.Isam.Esent.Interop.JET_filetype]$DBType = [Microsoft.Isam.Esent.Interop.JET_filetype]($FileType)
$DBType
$PageSize
$FileType
## Open a JET session
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
$Connect

#Check the session information
Write-Output -InputObject ([PSCustomObject]@{Instance=$Instance;Session=$Session;DatabaseId=$DatabaseId;Path=$Path})

# Dumptable names
Write-Output -InputObject ([Microsoft.Isam.Esent.Interop.Api]::GetTableNames($Session, $DatabaseId))

<#
{DD6636C4-8929-4683-974E-22C046A43763} Network Connectivity data
{D10CA2FE-6FCF-4F6D-848E-B2E99266FA89} Application Resource usage data 
{973F5D5C-1D90-4944-BE8E-24B94231A174} Network usage data 
{D10CA2FE-6FCF-4F6D-848E-B2E99266FA86} Windows Push Notification data 
{FEE4E14F-02A9-4550-B5CE-5FA2DA202E37} Energy usage data 
{FEE4E14F-02A9-4550-B5CE-5FA2DA202E37}LT Energy usage data

Windows10
{5C8CF1C7-7257-4F13-B223-970EF5939312}
{973F5D5C-1D90-4944-BE8E-24B94231A174} 
{D10CA2FE-6FCF-4F6D-848E-B2E99266FA86}
{D10CA2FE-6FCF-4F6D-848E-B2E99266FA89}
{DA73FB89-2BEA-4DDC-86B8-6E048C6DA477}
{DD6636C4-8929-4683-974E-22C046A43763}
{FEE4E14F-02A9-4550-B5CE-5FA2DA202E37}
{FEE4E14F-02A9-4550-B5CE-5FA2DA202E37}LT

#>

## OK LETS LOOK AT THE COLUMNS
$TableName="{5C8CF1C7-7257-4F13-B223-970EF5939312}"
[Microsoft.Isam.Esent.Interop.Table]$Table = New-Object -TypeName Microsoft.Isam.Esent.Interop.Table($Session, $DatabaseId, $TableName, [Microsoft.Isam.Esent.Interop.OpenTableGrbit]::None)
Write-Output -InputObject ([Microsoft.Isam.Esent.Interop.ColumnInfo[]][Microsoft.Isam.Esent.Interop.Api]::GetTableColumns($Session, $Table.JetTableid)) | ft

$TableNameNETUSE="{973F5D5C-1D90-4944-BE8E-24B94231A174}"   
[Microsoft.Isam.Esent.Interop.Table]$TableNETU = New-Object -TypeName Microsoft.Isam.Esent.Interop.Table($Session, $DatabaseId, $TableNameNETUSE, [Microsoft.Isam.Esent.Interop.OpenTableGrbit]::None)
Write-Output -InputObject ([Microsoft.Isam.Esent.Interop.ColumnInfo[]][Microsoft.Isam.Esent.Interop.Api]::GetTableColumns($Session, $TableNETU.JetTableid)) | ft
    
$TableNameAPPRESUSE="{D10CA2FE-6FCF-4F6D-848E-B2E99266FA89}"
[Microsoft.Isam.Esent.Interop.Table]$TableAPPU = New-Object -TypeName Microsoft.Isam.Esent.Interop.Table($Session, $DatabaseId, $TableNameAPPRESUSE, [Microsoft.Isam.Esent.Interop.OpenTableGrbit]::None)
Write-Output -InputObject ([Microsoft.Isam.Esent.Interop.ColumnInfo[]][Microsoft.Isam.Esent.Interop.Api]::GetTableColumns($Session, $TableAPPU.JetTableid)) | ft
    
    
## LET DUMP SOME TABLES    

$NewTable = @{Name=$TableAPPU.Name;Id=$TableAPPU.JetTableid;Rows=@()}

[Microsoft.Isam.Esent.Interop.ColumnInfo[]]$Columns = [Microsoft.Isam.Esent.Interop.Api]::GetTableColumns($Session, $TableAPPU.JetTableid)

if ([Microsoft.Isam.Esent.Interop.Api]::TryMoveFirst($Session, $TableAPPU.JetTableid)) 
{
	do 
	{
	    $Row = @{}

		foreach ($Column in $Columns) 
		{ 
			switch ($Column.Coltyp) 
			{
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::Bit) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsBoolean($Session, $TableAPPU.JetTableid, $Column.Columnid)
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::DateTime) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsDateTime($Session, $TableAPPU.JetTableid, $Column.Columnid)
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::IEEEDouble) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsDouble($Session, $TableAPPU.JetTableid, $Column.Columnid)
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::IEEESingle) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsFloat($Session, $TableAPPU.JetTableid, $Column.Columnid)
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::Long) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsInt32($Session, $TableAPPU.JetTableid, $Column.Columnid)
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::Binary) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsString($Session, $TableAPPU.JetTableid, $Column.Columnid, [System.Text.Encoding]::UTF8)
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::LongBinary) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsString($Session, $TableAPPU.JetTableid, $Column.Columnid, [System.Text.Encoding]::UTF8)
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::LongText) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsString($Session, $TableAPPU.JetTableid, $Column.Columnid, [System.Text.Encoding]::UTF8)
                            
					#Replace null characters which are 0x0000 unicode                                                     
					if (![System.String]::IsNullOrEmpty($Buffer)) {
						$Buffer = $Buffer.Replace("`0", "")
					}
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::Text) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsString($Session, $TableAPPU.JetTableid, $Column.Columnid, [System.Text.Encoding]::UTF8)
                                
					#Replace null characters which are 0x0000 unicode                                                     
					if (![System.String]::IsNullOrEmpty($Buffer)) {
						$Buffer = $Buffer.Replace("`0", "")
					}
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::Currency) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsString($Session, $TableAPPU.JetTableid, $Column.Columnid, [System.Text.Encoding]::UTF8)
                              
					#Replace null characters which are 0x0000 unicode                                                     
					if (![System.String]::IsNullOrEmpty($Buffer)) {
						$Buffer = $Buffer.Replace("`0", "")
					}
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::Short) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsInt16($Session, $TableAPPU.JetTableid, $Column.Columnid)
					break
				}
				([Microsoft.Isam.Esent.Interop.JET_coltyp]::UnsignedByte) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsByte($Session, $TableAPPU.JetTableid, $Column.Columnid)
					break
				}
				(14) {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsInt32($Session, $TableAPPU.JetTableid, $Column.Columnid)
					break
				}
				(15) {
				    try {
					$Buffer = [Microsoft.Isam.Esent.Interop.Api]::RetrieveColumnAsInt64($Session, $TableAPPU.JetTableid, $Column.Columnid)
				} catch { $Buffer = "Error"}
					if ( $Buffer -Ne "Error" ) {		
					try {
						$DateTime = [System.DateTime]::FromBinary($Buffer)
						$DateTime = $DateTime.AddYears(1600)
                               
						if ($DateTime -gt (Get-Date -Year 1970 -Month 1 -Day 1) -and $DateTime -lt ([System.DateTime]::UtcNow.Add($FutureTimeLimit))) {
							$Buffer = $DateTime
						}
					}
					catch {}
				}

							
					break							
				}
				default {
					Write-Warning -Message "Did not match column type to $_"
					$Buffer = [System.String]::Empty
					break
				}
			}

			 $Row | Add-Member -type NoteProperty -name $Column.Name -Value $Buffer
                           
		}

		$NewTable.Rows += $Row
		
		
	} while ([Microsoft.Isam.Esent.Interop.Api]::TryMoveNext($Session, $TableAPPU.JetTableid))               
}

Write-Output -InputObject ([PSCustomObject]$NewTable)

    
    

Write-Verbose -Message "Shutting down database $Path due to normal close operation."
[Microsoft.Isam.Esent.Interop.Api]::JetCloseDatabase($Session, $DatabaseId, [Microsoft.Isam.Esent.Interop.CloseDatabaseGrbit]::None)
[Microsoft.Isam.Esent.Interop.Api]::JetDetachDatabase($Session, $Path)
[Microsoft.Isam.Esent.Interop.Api]::JetEndSession($Session, [Microsoft.Isam.Esent.Interop.EndSessionGrbit]::None)
[Microsoft.Isam.Esent.Interop.Api]::JetTerm($Instance)
Write-Verbose -Message "Completed shut down successfully."