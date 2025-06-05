//%attributes = {}

/*
Method Name : _ga_exportEquipmentList
Author : Medard /4D PS
Date : 03-June-2025
Purpose : This method export the items on Equipment View List to an .csv document
*/


If (True:C214)
	
	var $eSetting : cs:C1710.sfw_SettingEntity
	var $identEntry : Text:=Form:C1466.sfw.entry.ident
	var $identView : Text:=Form:C1466.sfw.view.ident
	var $entity : 4D:C1709.Entity
	var $file : 4D:C1709.File
	var $info : Object
	var $wpBlob : 4D:C1709.Blob
	var $wpEncodedBlob : Text
	var $equipments : cs:C1710.EquipmentSelection
	var $OK : Boolean
	var $data : Collection:=[]
	var $headers : Collection:=[]
	var $header; $separator_col; $separator_line : Text
	
	$separator_col:=";"
	$separator_line:=Char:C90(Carriage return:K15:38)
	
	SUSPEND TRANSACTION:C1385
	$eSetting:=This:C1470._getSettingVersionReferenceRecords($identEntry)
	
	If ($identView="main")
		$identView:="allEquipments"
	End if 
	$file:=Folder:C1567(fk resources folder:K87:11).file("exportedData/"+$identEntry+"/"+$identView+".csv")
	
	If (Not:C34($file.exists))
		
		$file.create()
	End if 
	
	$export:=New object:C1471
	$export.records:=New collection:C1472
	
	$dataclass:=Form:C1466.sfw.entry.dataclass
	If ($identView="allEquipments")
		$equipments:=ds:C1482[$dataclass].all()
	Else 
		$equipments:=ds:C1482[$dataclass][$identView]()
	End if 
	For each ($entity; $equipments)
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
	
	$equipment_es:=$export.records
	
	If ($equipment_es.length>0)
		OB GET PROPERTY NAMES:C1232($equipment_es[0]; $headerNames; $arrTypes)
		ARRAY TO COLLECTION:C1563($headers; $headerNames)
		$headers:=$headers.remove($headers.indexOf("type"))
		$headers:=$headers.remove($headers.indexOf("repairLogs"))
		$headers[$headers.indexOf("locationID")]:="location"
		$headers[$headers.indexOf("UUID_ToolType")]:="type"
		$headers[$headers.indexOf("divisionID")]:="division"
		$OK:=True:C214
	Else 
		$OK:=False:C215
	End if 
	For ($i; 0; $headers.length-1)
		
		If ($i=0)
			$header:=$headers[$i]
		Else 
			$header:=$header+$separator_col+$headers[$i]
		End if 
		
	End for 
	
	$data.push($header)
	
	If ($OK)
		
		For each ($equipment_e; $equipment_es)
			$line:=""
			For each ($headerName; $headers)
				
				If ($line="")
					
					$line:=Replace string:C233(String:C10($equipment_e[$headerName]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42))
					
				Else 
					
					Case of 
							
						: ($headerName="location")
							$location:=ds:C1482.EquipmentLocation.query("locationID=:1"; $equipment_e["locationID"]).first()
							$line:=$line+$separator_col+Replace string:C233(String:C10($location.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42))
						: ($headerName="type")
							$type:=ds:C1482.ToolType.query("UUID=:1"; $equipment_e["UUID_ToolType"]).first()
							$line:=$line+$separator_col+Replace string:C233(String:C10($type.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42))
						: ($headerName="division")
							$division:=ds:C1482.Division.query("divisionID=:1"; $equipment_e["divisionID"]).first()
							$line:=$line+$separator_col+Replace string:C233(String:C10($division.name); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42))
						Else 
							$line:=$line+$separator_col+Replace string:C233(String:C10($equipment_e[$headerName]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42))
							
					End case 
				End if 
			End for each 
			
			$data.push($line)
			
		End for each 
		
		$csv:=$data.join($separator_line)
		
		$file.setText($csv)
		RESUME TRANSACTION:C1386
		cs:C1710.sfw_dialog.me.info(ds:C1482.sfw_readXliff("export.done"; "The export is done"))  //XLIFF OK
		SHOW ON DISK:C922($file.platformPath)
		
	Else 
		
		
	End if 
	
Else 
/*
	
var $eSetting : cs.sfw_SettingEntity
var $identEntry : Text:=Form.sfw.entry.ident
var $identView : Text:=Form.sfw.view.ident
var $entity : 4D.Entity
var $file : 4D.File
var $info : Object
var $wpBlob : 4D.Blob
var $wpEncodedBlob : Text
var $equipments : cs.EquipmentSelection
	
SUSPEND TRANSACTION
$eSetting:=This._getSettingVersionReferenceRecords($identEntry)
	
If ($identView="main")
$identView:="AllEquipments"
End if 
$file:=Folder(fk resources folder).file("exportedData/"+$identEntry+"/"+$identView+".json")
	
If ($file.exists)
$previousExport:=JSON Parse($file.getText())
$previousVersion:=$previousExport.version
$currentVersion:=$eSetting.data.value
Case of 
: ($previousVersion<=$currentVersion)
$eSetting.data.value+=1
$eSetting.stmpLastModif:=cs.sfw_stmp.me.now()
$info:=$eSetting.save()
: ($previousVersion>$currentVersion)
$eSetting.data.value:=$previousVersion+1
$eSetting.stmpLastModif:=cs.sfw_stmp.me.now()
$info:=$eSetting.save()
End case 
Else 
$eSetting.data.value+=1
$info:=$eSetting.save()
	
End if 
	
$export:=New object
$export.ident:=$eSetting.ident
$export.version:=$eSetting.data.value
$export.stmp:=$eSetting.stmpLastModif
$export.date:=Current date
$export.records:=New collection
	
$dataclass:=Form.sfw.entry.dataclass
If ($identView="AllEquipments")
$equipments:=ds[$dataclass].all()
Else 
$equipments:=ds[$dataclass][$identView]()
End if 
For each ($entity; $equipments)  //ds[$dataclass].all())
$oEntity:=New object
For each ($attribute; ds[$dataclass])
If (ds[$dataclass][$attribute].fieldType=Is object) && ($entity[$attribute]#Null) && (String($entity[$attribute].title)="4D Write Pro New Document")
WP EXPORT VARIABLE($entity[$attribute]; $wpBlob; wk 4wp)
BASE64 ENCODE($wpBlob; $wpEncodedBlob)
$oEntity[$attribute]:=$wpEncodedBlob
Else 
$oEntity[$attribute]:=$entity[$attribute]
End if 
	
End for each 
$export.records.push($oEntity)
	
End for each 
	
If (Form.sfw.entry.linkedReferenceRecordsDataclasses#Null)
For each ($link; Form.sfw.entry.linkedReferenceRecordsDataclasses)
$entitiesSelection:=ds[Form.sfw.entry.dataclass].all()
$segments:=Split string($link; ".")
For each ($segment; $segments)
$entitiesSelection:=$entitiesSelection[$segment]
End for each 
$dataclass:=$entitiesSelection.getDataClass().getInfo().name
$export[$dataclass]:=New collection
For each ($entity; $entitiesSelection)
//$export[$dataclass].push($entity.toObject())
$oEntity:=New object
For each ($attribute; ds[$dataclass])
If (ds[$dataclass][$attribute].fieldType=Is object) && ($entity[$attribute]#Null) && (String($entity[$attribute].title)="4D Write Pro New Document")
WP EXPORT VARIABLE($entity[$attribute]; $wpBlob; wk 4wp)
BASE64 ENCODE($wpBlob; $wpEncodedBlob)
$oEntity[$attribute]:=$wpEncodedBlob
Else 
$oEntity[$attribute]:=$entity[$attribute]
End if 
	
End for each 
$export[$dataclass].push($oEntity)
	
End for each 
End for each 
End if 
	
$json:=JSON Stringify($export; *)
$file.setText($json)
RESUME TRANSACTION
cs.sfw_dialog.me.info(ds.sfw_readXliff("export.done"; "The export is done"))  //XLIFF OK
SHOW ON DISK($file.platformPath)
*/
	
End if 
