//%attributes = {}
/*
_ga_exportEquipmentList()


*/

var $eSetting : cs:C1710.sfw_SettingEntity
var $identEntry : Text:=Form:C1466.sfw.entry.ident
var $identView : Text:=Form:C1466.sfw.view.ident
var $entity : 4D:C1709.Entity
var $file : 4D:C1709.File
var $info : Object
var $wpBlob : 4D:C1709.Blob
var $wpEncodedBlob : Text
var $equipments : cs:C1710.EquipmentSelection

SUSPEND TRANSACTION:C1385
$eSetting:=This:C1470._getSettingVersionReferenceRecords($identEntry)


If ($identView="main")
	$identView:="AllEquipments"
End if 
$file:=Folder:C1567(fk resources folder:K87:11).file("exportedData/"+$identEntry+"/"+$identView+".json")

If ($file.exists)
	$previousExport:=JSON Parse:C1218($file.getText())
	$previousVersion:=$previousExport.version
	$currentVersion:=$eSetting.data.value
	Case of 
		: ($previousVersion<=$currentVersion)
			$eSetting.data.value+=1
			$eSetting.stmpLastModif:=cs:C1710.sfw_stmp.me.now()
			$info:=$eSetting.save()
		: ($previousVersion>$currentVersion)
			$eSetting.data.value:=$previousVersion+1
			$eSetting.stmpLastModif:=cs:C1710.sfw_stmp.me.now()
			$info:=$eSetting.save()
	End case 
Else 
	$eSetting.data.value+=1
	$info:=$eSetting.save()
	
End if 

$export:=New object:C1471
$export.ident:=$eSetting.ident
$export.version:=$eSetting.data.value
$export.stmp:=$eSetting.stmpLastModif
$export.date:=Current date:C33
$export.records:=New collection:C1472

$dataclass:=Form:C1466.sfw.entry.dataclass
If ($identView="AllEquipments")
	$equipments:=ds:C1482[$dataclass].all()
Else 
	$equipments:=ds:C1482[$dataclass][$identView]()
End if 
For each ($entity; $equipments)  //ds[$dataclass].all())
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

If (Form:C1466.sfw.entry.linkedReferenceRecordsDataclasses#Null:C1517)
	For each ($link; Form:C1466.sfw.entry.linkedReferenceRecordsDataclasses)
		$entitiesSelection:=ds:C1482[Form:C1466.sfw.entry.dataclass].all()
		$segments:=Split string:C1554($link; ".")
		For each ($segment; $segments)
			$entitiesSelection:=$entitiesSelection[$segment]
		End for each 
		$dataclass:=$entitiesSelection.getDataClass().getInfo().name
		$export[$dataclass]:=New collection:C1472
		For each ($entity; $entitiesSelection)
			//$export[$dataclass].push($entity.toObject())
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
			$export[$dataclass].push($oEntity)
			
		End for each 
	End for each 
End if 

$json:=JSON Stringify:C1217($export; *)
$file.setText($json)
RESUME TRANSACTION:C1386
cs:C1710.sfw_dialog.me.info(ds:C1482.sfw_readXliff("export.done"; "The export is done"))  //XLIFF OK
SHOW ON DISK:C922($file.platformPath)

