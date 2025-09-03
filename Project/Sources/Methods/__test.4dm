//%attributes = {}

$a:="    "
$a:=Split string:C1554($a; ";"; sk ignore empty strings:K86:1+sk trim spaces:K86:2).join(";")
If ($a="")
	//ALERT("ok")
End if 


//$es:=ds.Customer.all()
//$dis:=ds.Customer.all().distinct("name")

//var $audit_e : cs.AuditEntity
//var $audit_es : cs.AuditEntity
//$audit_es:=ds.Audit.all()
//For each ($audit_e; $audit_es)
//$file:=Temporary folder+Folder separator+$audit_e.attachedDocuments.documents.sourcePath

//BLOB TO DOCUMENT($file; $audit_e.attachedDocuments.documents.blob)

//End for each 


$file:=Folder:C1567(fk data folder:K87:12).file("2300_Names.json")
$names:=JSON Parse:C1218($file.getText())

$i:=0
$es:=ds:C1482.Contact.all()
For each ($e; $es)
	$e.firstName:=$names[$i].firstName
	$e.lastName:=$names[$i].lastName
	$e.save()
	$i+=1
End for each 

$text:="   \r  "

$text:=cs:C1710.Util.me.trim($text; [" "; "\r"])






