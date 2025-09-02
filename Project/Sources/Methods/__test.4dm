//%attributes = {}

$a:="    "
$a:=Split string:C1554($a; ";"; sk ignore empty strings:K86:1+sk trim spaces:K86:2).join(";")
If ($a="")
	ALERT:C41("ok")
End if 



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






