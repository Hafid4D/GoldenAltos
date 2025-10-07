//%attributes = {}

/*
Method Name : _ga_exportEquipmentList
Author : Medard /4D PS
Date : 23-June-2025
Purpose : This method export the items on CIP View List to an .xls document
*/


var $eSetting : cs:C1710.sfw_SettingEntity
var $identEntry : Text:=Form:C1466.sfw.entry.ident
var $entity : 4D:C1709.Entity
var $info : Object
var $wpBlob : 4D:C1709.Blob
var $wpEncodedBlob : Text
var $cips : cs:C1710.ContinuousImprovementSelection
var $OK : Boolean
var $headers : Collection
var $header; $separator_col; $separator_line : Text


$headers:=New collection:C1472()
$separator_col:=Char:C90(Tab:K15:37)
$separator_line:=Char:C90(Carriage return:K15:38)


$file:=Create document:C266(""; "xls")

If (OK=1)
	$export:=New object:C1471
	$export.records:=New collection:C1472
	
	$dataclass:=Form:C1466.sfw.entry.dataclass
	
	$cips:=Form:C1466.sfw.lb_items
	
	For each ($entity; $cips)
		$oEntity:=New object:C1471
		For each ($attribute; ds:C1482[$dataclass])
			If (ds:C1482[$dataclass][$attribute].fieldType=Is object:K8:27) && ($entity[$attribute]#Null:C1517) && (String:C10($entity[$attribute].title)="4D Write Pro New Document")
				WP EXPORT VARIABLE:C1319($entity[$attribute]; $wpBlob; wk 4wp:K81:4)
				BASE64 ENCODE:C895($wpBlob; $wpEncodedBlob)
				$oEntity[$attribute]:=$wpEncodedBlob
			Else 
				$oEntity[$attribute]:=$entity[$attribute]
			End if 
			
		End for each 
		$export.records.push($oEntity)
		
	End for each 
	
	$cip_es:=$export.records
	
	If ($cip_es.length>0)
		OB GET PROPERTY NAMES:C1232($cip_es[0]; $headerNames; $arrTypes)
		ARRAY TO COLLECTION:C1563($headers; $headerNames)
		
		$headers.remove($headers.indexOf("UUID"))
		$headers.remove($headers.indexOf("moreData"))
		$headers:=$headers.filter(Formula:C1597($1.value#"stmp@"))
		$headers:=$headers.filter(Formula:C1597($1.value#"UUID_@"))
		
		$OK:=True:C214
	Else 
		$OK:=False:C215
	End if 
	For ($i; 0; $headers.length-1)
		
		SEND PACKET:C103($file; _capitalize_text($headers[$i])+$separator_col)
		
	End for 
	
	SEND PACKET:C103($file; $separator_line)
	
	If ($OK)
		
		For each ($cip_e; $cip_es)
			
			For each ($headerName; $headers)
				
				Case of 
					: ($headerName="UUID")
						
					: ($headerName="priority")
						
						SEND PACKET:C103($file; Replace string:C233(Replace string:C233(Replace string:C233(String:C10($cip_e.priority.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42)); Char:C90(Tab:K15:37); Char:C90(Space:K15:42))+$separator_col)
						
					: ($headerName="origin")
						
						SEND PACKET:C103($file; Replace string:C233(Replace string:C233(Replace string:C233(String:C10($cip_e.origin.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42)); Char:C90(Tab:K15:37); Char:C90(Space:K15:42))+$separator_col)
						
					: ($headerName="humanFactor")
						
						SEND PACKET:C103($file; Replace string:C233(Replace string:C233(Replace string:C233(String:C10($cip_e.humanFactor.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42)); Char:C90(Tab:K15:37); Char:C90(Space:K15:42))+$separator_col)
						
					: ($headerName="disposition")
						If ($cip_e.moreData.disposition#"")
							SEND PACKET:C103($file; Replace string:C233(Replace string:C233(Replace string:C233(String:C10($cip_e.moreData.disposition); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42)); Char:C90(Tab:K15:37); Char:C90(Space:K15:42))+$separator_col)
							
						Else 
							
							SEND PACKET:C103($file; Replace string:C233(Replace string:C233(Replace string:C233(String:C10($cip_e.disposition.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42)); Char:C90(Tab:K15:37); Char:C90(Space:K15:42))+$separator_col)
						End if 
						
					: ($headerName="category")
						
						SEND PACKET:C103($file; Replace string:C233(Replace string:C233(Replace string:C233(String:C10($cip_e.category.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42)); Char:C90(Tab:K15:37); Char:C90(Space:K15:42))+$separator_col)
						
					: ($headerName="yesNoQuestion")
						
						SEND PACKET:C103($file; Replace string:C233(Replace string:C233(Replace string:C233(String:C10($cip_e.yesNoQuestion.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42)); Char:C90(Tab:K15:37); Char:C90(Space:K15:42))+$separator_col)
						
						
					Else 
						SEND PACKET:C103($file; Replace string:C233(Replace string:C233(Replace string:C233(String:C10($cip_e[$headerName]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42)); Char:C90(Tab:K15:37); Char:C90(Space:K15:42))+$separator_col)
						
						
				End case 
				
			End for each 
			
			SEND PACKET:C103($file; $separator_line)
			
		End for each 
		
		CLOSE DOCUMENT:C267($file)
		
		cs:C1710.sfw_dialog.me.info(ds:C1482.sfw_readXliff("export.done"; "The export is done"))
		
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
		SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
		
		LAUNCH EXTERNAL PROCESS:C811("cmd.exe /C  start \"\" \""+document+"\"")
		
	Else 
		
		cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to print"))
		
	End if 
	
End if 
