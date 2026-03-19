//%attributes = {}


$buyOrders:=ds:C1482.BuyingOrder.all()

$buyOrdersItems:=ds:C1482.BuyingOrderLine.all()


/*

$time:=Replace string(String(Time(Timestamp); System time short); ";"; "")
var $1; $data : Text  // Ex: "12345"
var $pattern; $char; $color : Text
var $i; $j; $width; $posX : Integer
var $dict : Collection:=New collection()
var $vpict : Picture

$data:="12345"  //$1
$dict:=New collection(\
"nnnWWnWnn"; \
"WnnWnnnnW"; \
"nnWWnnnnW"; \
"WnWWnnnnn"; \
"nnnWWnnnW"; \
"WnnWWnnnn"; \
"nnWWWnnnn"; \
"nnnWnnWnW"; \
"WnnWnnWnn"; \
"nnWWnnWnn"; \
"nWnWnnnnn"\
)


$fullData:=$data  //"*"+$data+"*"  // Ajout des Start/Stop
//$svg:="<svg xmlns='http://www.w3.org/2000/svg' width='100%' height='100%'>"
$svg:=DOM Create XML Ref("svg"; "http://www.w3.org/2000/svg")
DOM SET XML ATTRIBUTE($svg; "width"; "100%"; "height"; "100%")
$posX:=0

For ($i; 1; Length($fullData))
$char:=$fullData[[$i]]
$pattern:=$dict[Num($char)]

If ($pattern#Null)
For ($j; 1; 9)
// Déterminer la largeur : Large=3 unités, Étroit=1 unité
$width:=Choose($pattern[[$j]]="W"; 3; 1)

// Alternance : J impair = Noir, J pair = Blanc (on ne dessine que le noir)
If ($j%2#0)
//$svg+="<rect x='"+String($posX)+"' y='0' width='"+String($width)+"' height='50' fill='black' />"
$ref:=DOM Create XML element($svg; "rect"; "x"; String($posX); "y"; 0; "width"; String($width); "height"; "50"; "fill"; "black")
End if 

$posX:=$posX+$width
End for 
$posX:=$posX+1  // Espace inter-caractère (blanc étroit obligatoire)
End if 
End for 

//Utilisation du résultat : 
SVG EXPORT TO PICTURE($svg; $vpict; Copy XML data source)
*/

//var vpict : Picture
//$svg:=DOM Create XML Ref("svg"; "http://www.w3.org/2000/svg")
//$ref:=DOM Create XML element($svg; "text"; "font-size"; 26; "fill"; "red")
//DOM SET XML ATTRIBUTE($ref; "y"; "1em")
//DOM SET XML ELEMENT VALUE($ref; "Hello World")
//SVG EXPORT TO PICTURE($svg; $vpict; Copy XML data source)
//DOM CLOSE XML($svg)

//WRITE PICTURE FILE(""; $vpict)

//TRANSFORM PICTURE($vpict; Scale; 1; 0.99)
//$doc:=WP New()
//$range:=WP Text range($doc; wk end text; wk end text)
//WP Insert picture($range; $vpict; wk append)

//SET PRINT PREVIEW(True)

//WP PRINT($doc)

//ZINT PLUGIN TESTING

//$Zint_Params:=New object

//OB SET($Zint_Params; ZINT_FORMAT; ZINT_Format_SVG)
//OB SET($zint_params; ZINT_WHITE_SPACE; 2)


//OB SET($Zint_Params; ZINT_NO_TEXT; False)
//OB SET($zint_params; ZINT_HEIGHT; 40)
//OB SET($zint_params; ZINT_SCALE; 0.5)
//OB SET($Zint_Params; ZINT_TYPE; BARCODE_CODE39)
//OB SET($Zint_Params; ZINT_PRIMARY; "Lot: "+ds.Lot.all()[0].lotNumber)

//$bar:=ZINT(ds.Lot.all()[0].moreData.barcodeData; $Zint_Params)

//$barcode:=$bar.image
//TRANSFORM PICTURE($barcode; Scale; 1; 0.99)
//$doc:=WP New()
//$range:=WP Text range($doc; wk end text; wk end text)
//WP Insert picture($range; $barcode; wk append)

//SET PRINT PREVIEW(True)

//WP PRINT($doc)


//$po:=ds.PurchaseOrder.query("oldPoNumber =:1"; "4513841818")

//$jobs:=ds.Job.query("jobNumber =:1"; 1664)

//$poLines:=ds.CAOTypeDetail.all()
//$invoiceNum:=725
//$invoices:=ds.Invoice.all().extract("invoice").orderBy(ck ascending)
//$invoice:=ds.Invoice.query("purchaseOrder.customer.name = :1"; "ALDETEC")
////SET TEXT TO PASTEBOARD($invoices.join("\n"))



