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
var $logs : cs:C1710.RepairLogSelection
var $OK : Boolean
var $data : Collection:=[]
var $headers : Collection:=[]
var $header; $separator_col; $separator_line : Text

$separator_col:=";"
$separator_line:=Char:C90(Carriage return:K15:38)

SUSPEND TRANSACTION:C1385
$eSetting:=This:C1470._getSettingVersionReferenceRecords($identEntry)

If ($identView="main")
	$identView:="allProblems"
End if 
$file:=Folder:C1567(fk resources folder:K87:11).file("exportedData/"+$identEntry+"/"+$identView+".csv")

If (Not:C34($file.exists))
	
	$file.create()
End if 

$export:=New object:C1471
$export.records:=New collection:C1472

$dataclass:=Form:C1466.sfw.entry.dataclass
If ($identView="allProblems")
	$logs:=ds:C1482[$dataclass].all()
Else 
	$logs:=ds:C1482[$dataclass][$identView]()
End if 
For each ($entity; $logs)
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

$log_es:=$export.records

If ($log_es.length>0)
	OB GET PROPERTY NAMES:C1232($log_es[0]; $headerNames; $arrTypes)
	ARRAY TO COLLECTION:C1563($headers; $headerNames)
	
	$headers:=$headers.remove($headers.indexOf("equipment"))
	
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
	
	For each ($log_e; $log_es)
		$line:=""
		For each ($headerName; $headers)
			
			If ($line="")
				
				$line:=Replace string:C233(String:C10($log_e[$headerName]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42))
				
			Else 
				$line:=$line+$separator_col+Replace string:C233(String:C10($log_e[$headerName]); Char:C90(Carriage return:K15:38); Char:C90(Space:K15:42))
				
				
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
	
	cs:C1710.sfw_dialog.me.alert(ds:C1482.sfw_readXliff("No items in the list to print"))
	
End if 


