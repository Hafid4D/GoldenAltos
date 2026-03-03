//%attributes = {}

$time:=Replace string:C233(String:C10(Time:C179(Timestamp:C1445); System time short:K7:9); ";"; "")
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



