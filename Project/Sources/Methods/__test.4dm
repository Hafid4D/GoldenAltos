//%attributes = {}


var $audit_e : cs:C1710.AuditEntity
var $audit_es : cs:C1710.AuditEntity
$audit_es:=ds:C1482.Audit.all()
For each ($audit_e; $audit_es)
	$file:=Temporary folder:C486+Folder separator:K24:12+$audit_e.attachedDocuments.documents.sourcePath
	
	BLOB TO DOCUMENT:C526($file; $audit_e.attachedDocuments.documents.blob)
	
End for each 


//$file:=Folder(fk data folder).file("2300_Names.json")
//$names:=JSON Parse($file.getText())

//$i:=0
//$es:=ds.Contact.all()
//For each ($e; $es)
//$e.firstName:=$names[$i].firstName
//$e.lastName:=$names[$i].lastName
//$e.save()
//$i+=1
//End for each 

//$text:="   \r  "

//$text:=cs.Util.me.trim($text; [" "; "\r"])






