//%attributes = {}

/*
Method Name : _ga_exportRepairLogList
Author : Medard /4D PS
Date : 03-June-2025
Purpose : This method export the items on repair Log  View List to an .xls document
*/

var $eSetting : cs:C1710.sfw_SettingEntity
var $identEntry : Text:=Form:C1466.sfw.entry.ident
var $entity : 4D:C1709.Entity
var $info : Object
var $wpBlob : 4D:C1709.Blob
var $wpEncodedBlob : Text
var $logs : cs:C1710.RepairLogSelection
var $OK; $allFields; $continue : Boolean
var $headers; $relevantFields : Collection
var $header; $separator_col; $separator_line : Text

$continue:=True:C214
$allFields:=False:C215

MOUSE POSITION:C468($vlMouseX; $vlMouseY; $vlButton)

$vtItems:="Export relevant fields; (-; Export all fields"
$vlUserChoice:=Pop up menu:C542($vtItems)
Case of 
	: ($vlUserChoice=1)
		$allFields:=False:C215
		
	: ($vlUserChoice=3)
		$allFields:=True:C214
		
	Else 
		$continue:=False:C215
		
End case 


If ($continue)
	$headers:=New collection:C1472()
	$relevantFields:=New collection:C1472("systemID"; "reportID"; "problem"; "fix"; "downHrs")
	$separator_col:=Char:C90(Tab:K15:37)
	$separator_line:=Char:C90(Carriage return:K15:38)
	
	SUSPEND TRANSACTION:C1385
	
	
	$file:=Create document:C266(""; "xls")
	
	If (OK=1)
		$export:=New object:C1471
		$export.records:=New collection:C1472
		
		$dataclass:=Form:C1466.sfw.entry.dataclass
		
		$logs:=Form:C1466.sfw.lb_items
		
		For each ($entity; $logs)
			//$oEntity:=New object
			//For each ($attribute; ds[$dataclass])
			//If (ds[$dataclass][$attribute].fieldType=Is object) && ($entity[$attribute]#Null) && (String($entity[$attribute].title)="4D Write Pro New Document")
			//WP EXPORT VARIABLE($entity[$attribute]; $wpBlob; wk 4wp)
			//BASE64 ENCODE($wpBlob; $wpEncodedBlob)
			//$oEntity[$attribute]:=$wpEncodedBlob
			//Else 
			//$oEntity[$attribute]:=$entity[$attribute]
			//End if 
			
			//End for each 
			$export.records.push($entity)  //($oEntity)
			
		End for each 
		
		$log_es:=$export.records
		
		If ($log_es.length>0)
			OB GET PROPERTY NAMES:C1232($log_es[0]; $headerNames; $arrTypes)
			ARRAY TO COLLECTION:C1563($headers; $headerNames)
			
			
			$headers.push("fixedBy")
			$headers.push("reportedBy")
			$headers.push("systemID")
			$headers:=$headers.remove($headers.indexOf("@Stmp"))
			$headers:=$headers.remove($headers.indexOf("equipment"))
			//$headers:=$headers.remove($headers.indexOf("operators"))
			//$headers:=$headers.remove($headers.indexOf("UUID"))
			$headers:=$headers.filter(Formula:C1597($1.value#"stmp@"))
			$headers:=$headers.filter(Formula:C1597($1.value#"UUID@"))
			
			If (Not:C34($allFields))
				$headers:=$relevantFields
			End if 
			$OK:=True:C214
		Else 
			$OK:=False:C215
		End if 
		For ($i; 0; $headers.length-1)
			
			SEND PACKET:C103($file; $headers[$i]+$separator_col)
			
		End for 
		
		SEND PACKET:C103($file; $separator_line)
		
		If ($OK)
			
			For each ($log_e; $log_es)
				$line:=""
				For each ($headerName; $headers)
					
					Case of 
							
						: ($headerName="systemID")
							$systemID:=$log_e.equipment#Null:C1517 ? $log_e.equipment.assignedID : ""
							//SEND PACKET($file; Replace string(String($systemID); Char(Carriage return); Char(Space))+$separator_col)
							SEND PACKET:C103($file; Replace string:C233(Replace string:C233(String:C10($systemID); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))+$separator_col)
							
						: ($headerName="fixedBy")
							$value:=$log_e.equipment#Null:C1517 ? $log_e.operators.fixedBy : ""
							//SEND PACKET($file; Replace string(String($value); Char(Carriage return); Char(Space))+$separator_col)
							SEND PACKET:C103($file; Replace string:C233(Replace string:C233(String:C10($value); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))+$separator_col)
							
						: ($headerName="reportedBy")
							$value:=$log_e.equipment#Null:C1517 ? $log_e.operators.reportedBy : ""
							//SEND PACKET($file; Replace string(String($value); Char(Carriage return); Char(Space))+$separator_col)
							SEND PACKET:C103($file; Replace string:C233(Replace string:C233(String:C10($value); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))+$separator_col)
							
						: ($headerName="operators")
							
						Else 
							
							//SEND PACKET($file; Replace string(String($log_e[$headerName]); Char(Carriage return); Char(Space))+$separator_col)
							SEND PACKET:C103($file; Replace string:C233(Replace string:C233(String:C10($log_e[$headerName]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))+$separator_col)
							
					End case 
					
				End for each 
				
				SEND PACKET:C103($file; $separator_line)
				
			End for each 
			
			CLOSE DOCUMENT:C267($file)
			
			RESUME TRANSACTION:C1386
			
			cs:C1710.sfw_dialog.me.info(ds:C1482.sfw_readXliff("export.done"; "The export is done"))
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
			
			LAUNCH EXTERNAL PROCESS:C811("cmd.exe /C  start \"\" \""+document+"\"")
			
		Else 
			
			cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to print"))
			
		End if 
		
	End if 
	
End if 