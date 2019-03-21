# ps-srum-hunting - a PowerShell Threat Hunting Dcript Repository

PowerShell Script to facilitate the processing of SRUM data for on-the-fly forensics and to initiate simple investigation or use as a potential threat hunting tool.

*NOTE-1*: This Repository is currently under development and is being shared to get as much input as possible on feature sets and directions.

*NOTE-2*: This is currently raw material and requires a lot ot TLC which will come


## Repository Task List
The following activities still need processing and completion.
- [ ] Fix get table rows to process information in SruDbIdMapTable, need a separate function
- [ ] Build script to merge SruDBID references into other table data extracts
- [ ] Pull registry information
- [ ] Build a module for SRUM
- [ ] ???

## References, inspirations and useful connections
Following is a list of references and inspirations as well as other projects that have helped guide the work for this project.

Title|Author|Link
-----|------|----
SRUM forensics|Yogesh Khatri|https://www.sans.org/summit-archives/file/summit-archive-1492184583.pdf
srum-dump|Mark Baggett|https://github.com/MarkBaggett/srum-dump
Extensible Storage Engine (ESE) Database File (EDB) format|Joachim Metz|https://github.com/libyal/libesedb
System Resource Usage Monitor (SRUM) database|Joachim Metz|https://github.com/libyal/esedb-kb/blob/master/documentation/System%20Resource%20Usage%20Monitor%20(SRUM).asciidoc
Extensible Storate Engine (ESE) Cmdlets|BAMCIS Networks|https://github.com/bamcisnetworks/ESENT
