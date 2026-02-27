

Case of 
		
	: (Form event code:C388=On Clicked:K2:4)
		var $parameters : Object:=New object:C1471()
		$data:=Form:C1466.barcodeData  //[Form.pup_fields.currentValue]
		
		Form:C1466.barCode:=_ga_generateBarCode($data)
		
End case 