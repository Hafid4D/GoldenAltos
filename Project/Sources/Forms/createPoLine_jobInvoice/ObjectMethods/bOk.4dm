Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		var $poLine : cs:C1710.PurchaseOrderLineEntity
		For each ($poLine; Form:C1466.selectedPoLines)
			$poLine.UUID_Job:=Form:C1466.job.UUID
			
			$res:=$poLine.save()
			
			If (Not:C34($res.success))
				TRACE:C157
			End if 
		End for each 
		
		ACCEPT:C269
End case 