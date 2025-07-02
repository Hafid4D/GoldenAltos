//%attributes = {}


/*
Method Name : _ga_exportSpecToExcel
Author : Medard /4D PS
Date : 01-July-2025
Purpose : This method export the items on Spec Control View List to an .xls document
*/


var $eSetting : cs:C1710.sfw_SettingEntity
var $identEntry : Text:=Form:C1466.sfw.entry.ident
var $identView : Text:=Form:C1466.sfw.view.ident
var $entity : 4D:C1709.Entity
var $info : Object
var $wpBlob : 4D:C1709.Blob
var $wpEncodedBlob : Text
var $specifications : cs:C1710.SpecificationSelection
var $OK : Boolean
var $headers : Collection
var $listOfHeaders : Collection
var $header; $separator_col; $separator_line : Text


$listOfHeaders:=New collection:C1472("spec"; "revision"; "extension"; "title"; "revisionDate"; \
"reviewDate"; "remark"; "categoryID"; "controllingDeptID")
$headers:=New collection:C1472()
$separator_col:=Char:C90(Tab:K15:37)
$separator_line:=Char:C90(Carriage return:K15:38)

If ($identView="main")
	$identView:="Continuous Improvement Programs"
End if 

$file:=Create document:C266(""; "xls")

$export:=New object:C1471
$export.records:=New collection:C1472

$dataclass:=Form:C1466.sfw.entry.dataclass
If ($identView="Continuous Improvement Programs")
	$specifications:=ds:C1482[$dataclass].all()
Else 
	$specifications:=ds:C1482[$dataclass][$identView]()
End if 
For each ($entity; $specifications)
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

$specification_es:=$export.records

If ($specification_es.length>0)
	OB GET PROPERTY NAMES:C1232($specification_es[0]; $headerNames; $arrTypes)
	ARRAY TO COLLECTION:C1563($headers; $headerNames)
	$headers:=$headers.filter(Formula:C1597($listOfHeaders.indexOf($1.value)#-1))
	
	$OK:=True:C214
Else 
	$OK:=False:C215
End if 
For ($i; 0; $headers.length-1)
	
	Case of 
		: ($headers[$i]="spec")
			$headerName:="Spec#"
		: ($headers[$i]="revisionDate")
			$headerName:="Spec Revision date"
		: ($headers[$i]="reviewDate")
			$headerName:="Last  Review date"
		: ($headers[$i]="remark")
			$headerName:="remarks"
		: ($headers[$i]="categoryID")
			$headerName:="Document Type"
		: ($headers[$i]="controllingDeptID")
			$headerName:="Controlling Dept"
		Else 
			$headerName:=$headers[$i]
	End case 
	
	SEND PACKET:C103($file; _capitalize_text($headerName)+$separator_col)
	
End for 

SEND PACKET:C103($file; $separator_line)

If ($OK)
	
	For each ($specification_e; $specification_es)
		
		For each ($headerName; $headers)
			
			Case of 
				: ($headerName="UUID")
				: ($headerName="categoryID")
					$category:=ds:C1482.SpecCategory.query("categoryID=:1"; $specification_e["categoryID"]).first()
					SEND PACKET:C103($file; Replace string:C233(Replace string:C233(String:C10($category.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))+$separator_col)
					
				: ($headerName="controllingDeptID")
					$departement:=ds:C1482.SpecControllingDept.query("departmentID=:1"; $specification_e["controllingDeptID"]).first()
					SEND PACKET:C103($file; Replace string:C233(Replace string:C233(String:C10($departement.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))+$separator_col)
					
					
				Else 
					SEND PACKET:C103($file; Replace string:C233(Replace string:C233(String:C10($specification_e[$headerName]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42); *); Char:C90(Line feed:K15:40); Char:C90(Space:K15:42))+$separator_col)
					
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


