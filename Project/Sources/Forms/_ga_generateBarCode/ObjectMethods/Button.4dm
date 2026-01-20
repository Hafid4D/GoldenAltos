

Case of 
		
	: (Form event code:C388=On Clicked:K2:4)
		$data:=Form:C1466.currentItem[Form:C1466.pup_fields.currentValue]
		If (Form:C1466.pup_fields.currentValue="UUID")
			$data:=_ga_UUID32To22($data)
			//$data:=Replace string($data; "="; "")
		End if 
		Form:C1466.barCode:=_ga_generateBarCode($data)
		
End case 