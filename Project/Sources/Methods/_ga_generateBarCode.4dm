//%attributes = {}

/*
_ga_generateBarCode : 

*/

var $base64Full; $base64Data : Text
var $imageBlob : Blob
var $finalImage : Picture
var $text : Text:=""
var $offScreanParams:=New object:C1471
var $urlParams:=New object:C1471()
$urlParams:=$1

$type:="CODE39"

$template:=Folder:C1567(fk resources folder:K87:11).file("barCode_encoder.html")

If ($template.exists) & ($urlParams.data#"")
	
	$templatePath:=Convert path system to POSIX:C1106($template.platformPath)
	
	$offScreanParams.url:="file://"+$templatePath+"?type="+$type+"&value="+$urlParams.data+"&text="+String:C10($urlParams.text)
	
	$offScreanParams.onEvent:=Formula:C1597(_ga_qrBarCodeUtil("GenerateBarCode"))
	
	$base64Full:=WA Run offscreen area:C1727($offScreanParams)
	
	$base64Data:=Substring:C12($base64Full; Position:C15(","; $base64Full)+1)
	
	BASE64 DECODE:C896($base64Data; $imageBlob)
	
	BLOB TO PICTURE:C682($imageBlob; $finalImage)
	
	$0:=$finalImage
	
End if 




