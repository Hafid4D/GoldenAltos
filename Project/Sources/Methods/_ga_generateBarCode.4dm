//%attributes = {}

var $base64Full; $base64Data : Text
var $imageBlob : Blob
var $finalImage : Picture
var $text : Text:=""
var $params:=New object:C1471
$data:=$1
var $0 : Picture

$data:="hassansribet"  // For testing
If (Length:C16($data)=32)  //(Form.pup_fields.currentValue="UUID")
	$text:=ds:C1482.sfw_User.get($data).fullName
	$data:=_ga_UUID32To22($data)
	$type:="CODE128"
Else 
	$type:="CODE128"
End if 

//$data:="AB"  //ds[$table].query("fullName = :1"; "Hassan Sribet").first()[$field]  //.login  .
//If 

//End if 
//If ($field="UUID")
//$data:=_ga_UUID32To22($data)
//$data:=Replace string($data; "="; "")
//End if 

If (Type:C295($data)=Is text:K8:3) || (Type:C295($data)=Is longint:K8:6) || (Type:C295($data)=Is integer:K8:5) || (Type:C295($data)=Is integer 64 bits:K8:25) || (Type:C295($data)=Is real:K8:4)
	
	$params.url:="file:///C:/Users/HP/Desktop/GoldenAltos/Resources/barCode_encoder.html?type="+$type+"&value="+$data+"&text="+$text
	
	$params.onEvent:=Formula:C1597(_ga_qrBarCodeUtil("GenerateBarCode"))
	
	$base64Full:=WA Run offscreen area:C1727($params)
	
	$base64Data:=Substring:C12($base64Full; Position:C15(","; $base64Full)+1)
	
	BASE64 DECODE:C896($base64Data; $imageBlob)
	
	BLOB TO PICTURE:C682($imageBlob; $finalImage)
	
End if 

$0:=$finalImage

WRITE PICTURE FILE:C680("C:\\Users\\HP\\Desktop\\GoldenAltos\\Resources\\QRCodes\\"+$text+"Barcode.png"; $finalImage)

//$data:=Uppercase(___UUID22TO32($data))



