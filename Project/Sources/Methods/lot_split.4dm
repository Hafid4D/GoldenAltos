//%attributes = {}
If (Form:C1466.sfw.checkIsInModification())
	If (Undefined:C82(Form:C1466.current_item.lotParent))
		
		$newLot:=ds:C1482.Lot.new()
		
		$dataclassObject:=ds:C1482.Lot
		
		$id:=Form:C1466.current_item.subLots.length+1
		
		$newLotNumber:=Form:C1466.current_item.lotNumber+"-"+String:C10($id)
		
		$lot_es:=ds:C1482.Lot.query("lotNumber = :1"; $newLotNumber)
		
		While ($lot_es.length>0)
			$id:=$id+1
			
			$newLotNumber:=(Form:C1466.current_item.lotNumber)+"-"+String:C10($id)
			
			$lot_es:=ds:C1482.Lot.query("lotNumber = :1"; $newLotNumber)
		End while 
		
		For each ($attributeName; $dataclassObject)
			$attribute:=$dataclassObject[$attributeName]
			
			If ($attribute.kind="storage")
				Case of 
					: ($attributeName="UUID") & ($attribute.type="string")
						$newLot[$attributeName]:=Generate UUID:C1066
					: ($attributeName="UUID_LotParent") & ($attribute.type="string")
						$newLot.UUID_LotParent:=Form:C1466.current_item.UUID
					: ($attributeName="lotNumber")
						$newLot.lotNumber:=$newLotNumber
					Else 
						$newLot[$attributeName]:=Form:C1466.current_item[$attributeName]
				End case 
			End if 
		End for each 
		
		$res:=$newLot.save()
		
		If ($res.success)
			//cs.panel_lot.me._activate_save_cancel_button()
			Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
		End if 
		
	Else 
		//Sub Lot
		ALERT:C41("sub lot")
	End if 
End if 