//%attributes = {}

//TRACE


$file:=Folder:C1567(fk data folder:K87:12).file("People_generated_1400.json")
$names:=JSON Parse:C1218($file.getText())

$i:=0
$es:=ds:C1482.Contact.all()
For each ($e; $es)
	$e.firstName:=$names[$i].first_name
	$e.lastName:=$names[$i].last_name
	$e.save()
	$i+=1
End for each 

$text:="   \r  "

$text:=cs:C1710.Util.me.trim($text; [" "; "\r"])

ALERT:C41("ok")


