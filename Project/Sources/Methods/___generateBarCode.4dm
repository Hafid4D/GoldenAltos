//%attributes = {}

var $base64Full; $base64Data : Text
var $imageBlob : Blob
var $finalImage : Picture

var $params:=New object:C1471

$type:="CODE128"
$data:="109876543210"
$params.url:="file:///C:/Users/HP/Desktop/GoldenAltos/Resources/barCode_encoder.html?type="+$type+"&value="+$data

// Add a callback method called on event
$params.onEvent:=Formula:C1597(___qrCodeUtil("GenerateBarCode"))

$base64Full:=WA Run offscreen area:C1727($params)

//Save QR image to file
$base64Data:=Substring:C12($base64Full; Position:C15(","; $base64Full)+1)

BASE64 DECODE:C896($base64Data; $imageBlob)

BLOB TO PICTURE:C682($imageBlob; $finalImage)

WRITE PICTURE FILE:C680("C:\\Users\\HP\\Desktop\\GoldenAltos\\resources\\QRCodes\\BarCode_2.png"; $finalImage)

