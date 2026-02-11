//%attributes = {}

var $base64Full; $base64Data : Text
var $imageBlob : Blob
var $finalImage : Picture
var $text : Text:=""
var $params:=New object:C1471
$data:=$1
var $0 : Picture
$type:="CODE39"

//$data:="0000000005"  // For testing
//If (Length($data)=32)  //(Form.pup_fields.currentValue="UUID")
//$text:=ds.sfw_User.get($data).fullName
//$data:=_ga_UUID32To22($data)
//$type:="CODE128"
//Else 
//$type:="CODE39"
//End if 


$template:=Folder:C1567(fk resources folder:K87:11).file("barCode_encoder.html")
If ($template.exists)
	$templatePath:=Convert path system to POSIX:C1106($template.platformPath)
	
	//If (Type($data)=Is text) || (Type($data)=Is longint) || (Type($data)=Is integer) || (Type($data)=Is integer 64 bits) || (Type($data)=Is real)
	
	$params.url:="file://"+$templatePath+"?type="+$type+"&value="+$data+"&text="+$text
	
	$params.onEvent:=Formula:C1597(_ga_qrBarCodeUtil("GenerateBarCode"))
	
	$base64Full:=WA Run offscreen area:C1727($params)
	
	$base64Data:=Substring:C12($base64Full; Position:C15(","; $base64Full)+1)
	
	BASE64 DECODE:C896($base64Data; $imageBlob)
	
	BLOB TO PICTURE:C682($imageBlob; $finalImage)
	
	//End if 
	
	$0:=$finalImage
	
	//WRITE PICTURE FILE("C:\\Users\\HP\\Desktop\\GoldenAltos\\Resources\\QRCodes\\"+$text+"Barcode.png"; $finalImage)  //For testing purpose
	
End if 
//$data:=Uppercase(___UUID22TO32($data))



