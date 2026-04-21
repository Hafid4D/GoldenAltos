//%attributes = {}
// Row background color for the _popup_binLocation listbox.
// Each row item has a "kind" attribute controlling the fill color.

Case of 
	: (This:C1470.kind="blue")
		$0:="#D6E6FF"
	: (This:C1470.kind="green")
		$0:="#D6F5D6"
	: (This:C1470.kind="yellow")
		$0:="#FFF4CC"
	: (This:C1470.kind="separator")
		$0:="#E8E8E8"
	Else 
		$0:="transparent"
End case 
