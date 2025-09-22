Class extends Entity


local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.jobNumber)
	
	
Function get quoteCode()->$code : Text
	
	$po:=This:C1470.purchaseOrderLines.first().purchaseOrder