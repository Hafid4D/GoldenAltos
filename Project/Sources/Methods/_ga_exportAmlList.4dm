//%attributes = {}


/*
Method Name : _ga_exportAmlList
Author : Medard /4D PS
Date : 08-August-2025
Purpose : This method export the items on Spec Control View List to an .xls document
*/


var $eSetting : cs:C1710.sfw_SettingEntity
var $identEntry : Text:=Form:C1466.sfw.entry.ident
var $entity : 4D:C1709.Entity
var $info : Object
var $wpBlob : 4D:C1709.Blob
var $wpEncodedBlob : Text
var $aml_es : cs:C1710.AMLSelection
var $aml_e : cs:C1710.AMLEntity
var $OK : Boolean
var $listOfHeaders : Collection
var $header; $separator_col; $separator_line : Text
var $headers : Collection:=New collection:C1472()
//var $aml_es : Collection:=New collection()

$headers:=New collection:C1472("Division"; "Internal Part"; "Vendor Part"; "Description"; "Comments"; "Critical?")

$separator_col:=Char:C90(Tab:K15:37)
$separator_line:=Char:C90(Carriage return:K15:38)


$file:=Create document:C266(""; "xls")

If (OK=1)
	$export:=New object:C1471
	$export.records:=New collection:C1472
	
	$dataclass:=Form:C1466.sfw.entry.dataclass
	
	$aml_es:=Form:C1466.sfw.lb_items
	
	If ($aml_es.length>0)
		
		$OK:=True:C214
	Else 
		$OK:=False:C215
	End if 
	For ($i; 0; $headers.length-1)
		
		SEND PACKET:C103($file; _capitalize_text($headers[$i])+$separator_col)
		
	End for 
	
	SEND PACKET:C103($file; $separator_line)
	
	If ($OK)
		
		For each ($aml_e; $aml_es)
			
			For each ($headerName; $headers)
				
				Case of 
						
					: ($headerName="Division")
						$data:=Replace string:C233(Replace string:C233(String:C10($aml_e.division.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))
						SEND PACKET:C103($file; $data+$separator_col)
						
					: ($headerName="Internal Part")
						$data:=Replace string:C233(Replace string:C233(String:C10($aml_e.partData.internalPartNum); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))
						SEND PACKET:C103($file; $data+$separator_col)
						
						
					: ($headerName="Vendor Part")
						$data:=Replace string:C233(Replace string:C233(String:C10($aml_e["vendorPartnum"]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))
						SEND PACKET:C103($file; $data+$separator_col)
						
						
					: ($headerName="Description")
						$data:=Replace string:C233(Replace string:C233(String:C10($aml_e["description"]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))
						SEND PACKET:C103($file; $data+$separator_col)
						
						
					: ($headerName="Comments")
						$data:=Replace string:C233(Replace string:C233(String:C10($aml_e["comment"]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))
						SEND PACKET:C103($file; $data+$separator_col)
						
						
					: ($headerName="Critical?")
						$data:=String:C10($supplier_e["critical"]=True:C214 ? "Yes" : "No")
						SEND PACKET:C103($file; $data+$separator_col)
						
					Else 
						
						//SEND PACKET($file; Replace string(Replace string(String($aml_e[$headerName]); Char(Carriage return); Char(Space); *); Char(Line feed); Char(Space))+$separator_col)
						
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
