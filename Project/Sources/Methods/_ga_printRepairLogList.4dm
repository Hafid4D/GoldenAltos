//%attributes = {}


/*
Method Name : _ga_printRepairLogList
Author : Medard /4D PS
Date : 03-June-2025
Purpose : Print ReportLog View List
*/

If (Form:C1466.sfw.lb_items.length>0)
	
	var $identEntry : Text:=Form:C1466.sfw.view.ident
	var $context : Object
	var $divisions : Collection
	
	$context:=New object:C1471()
	
	$file:=Folder:C1567(fk resources folder:K87:11).file("4DWriteProPrintTemplates/repairLogsListPrint.4wp")
	$template:=WP Import document:C1318($file.platformPath)
	$divisions:=New collection:C1472()
	For each ($item; Form:C1466.sfw.lb_items)
		If (Not:C34(Undefined:C82($item.equipment)))
			$divisions.push(ds:C1482.Division.query("divisionID =:1"; $item.equipment.divisionID).first().name)
		End if 
	End for each 
	
	$context.length:=Form:C1466.sfw.lb_items.length
	$context.division:=$divisions.distinct().join(","; ck ignore null or empty:K85:5)
	$context.user:=Current machine:C483
	
	$startDate:=Storage:C1525.cache.startDate
	$endDate:=Storage:C1525.cache.endDate
	
	If (Form:C1466.sfw.searchbox="")
		
		$equipment:="all"
	Else 
		$equipment:=Form:C1466.sfw.searchbox
	End if 
	
	$context.equipment:=$equipment
	SET PRINT OPTION:C733(Orientation option:K47:2; 1)
	
	Case of 
		: ($identEntry="main") & (Count parameters:C259=0)
			
			$context.subject:="Repairs Logs"
			
		: ($identEntry="currentProblems") & (Count parameters:C259=0)
			
			$context.subject:="Open problems"
			
		: ($identEntry="problemsByInterval") & (Count parameters:C259=0)
			
			$context.subject:="Problems from "+String:C10($startDate)+" to "+String:C10($endDate)
			
		: ($identEntry="repairsByInterval") & (Count parameters:C259=0)
			
			$context.subject:="Repairs between "+String:C10($startDate)+" to "+String:C10($endDate)
			
		Else 
			If (Count parameters:C259=1)
				$context.subject:="Down incident report"
			End if 
			
			
	End case 
	
	
	WP SET DATA CONTEXT:C1786($template; $context)
	
	PRINT SETTINGS:C106(2)
	WP PRINT:C1343($template)
	
Else 
	cs:C1710.sfw_dialog.me.info(ds:C1482.sfw_readXliff("Info"; "No items in the list to print"))
	
End if 