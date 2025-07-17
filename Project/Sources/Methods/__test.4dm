//%attributes = {}


//$es:=ds.Interaction.all()
//[Lead]


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

//$text:="   \r  "

//$text:=cs.Util.me.trim($text; [" "; "\r"])






