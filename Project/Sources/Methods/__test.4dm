//%attributes = {}

$staff:=ds:C1482.Staff.query("user.userInscriptions.userProfile.ident = :1 | memberships.team.name =:2"; "pm"; "Facilities")

$users:=$staff.extract("user").extract("UUID")




//$a:="    "
//$a:=Split string($a; ";"; sk ignore empty strings+sk trim spaces).join(";")
//If ($a="")
////ALERT("ok")
//End if 

//var $audit_e : cs.AuditEntity
//var $audit_es : cs.AuditEntity
//$audit_es:=ds.Audit.all()
//For each ($audit_e; $audit_es)
//$file:=Temporary folder+Folder separator+$audit_e.attachedDocuments.documents.sourcePath

//BLOB TO DOCUMENT($file; $audit_e.attachedDocuments.documents.blob)

//End for each 


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






