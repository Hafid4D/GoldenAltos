//%attributes = {}

var $projectFolder : 4D:C1709.Folder
var $importsFolder : 4D:C1709.Folder
var $file : 4D:C1709.File
var $records : Collection
var $record : Object
var $customer : cs:C1710.CustomerEntity
var $result : Object
var $name : Text
var $code : Text
var $created : Integer
var $updated : Integer

TRUNCATE TABLE:C1051([Customer:114])

$projectFolder:=Folder:C1567(fk database folder:K87:14)
$importsFolder:=$projectFolder.folder("project/imports")
$file:=$importsFolder.file("customers_export.json")

If (Not:C34($file.exists))
	ALERT:C41("Import file not found: "+$file.platformPath)
Else 
	$records:=JSON Parse:C1218($file.getText())
	
	$created:=0
	$updated:=0
	
	For each ($record; $records)
		$name:=String:C10($record.Customer)
		$code:=String:C10($record.Cust_Code)
		
		$customer:=Null:C1517
		
		// First try by customer code, then fallback to name.
		If ($code#"")
			$customer:=ds:C1482.Customer.query("code = :1"; $code).first()
		End if 
		
		If ($customer=Null:C1517)
			If ($name#"")
				$customer:=ds:C1482.Customer.query("name = :1"; $name).first()
			End if 
		End if 
		
		If ($customer=Null:C1517)
			$customer:=ds:C1482.Customer.new()
			$created:=$created+1
		Else 
			$updated:=$updated+1
		End if 
		
		$customer.name:=$name
		$customer.code:=$code
		
		$result:=$customer.save()
		If (Not:C34($result.success))
			TRACE:C157
		End if 
	End for each 
	
	ALERT:C41("Import termine - created: "+String:C10($created)+" | updated: "+String:C10($updated))
End if 
