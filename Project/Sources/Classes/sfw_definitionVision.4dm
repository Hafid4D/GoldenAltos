property ident : Text
property label : Text
property xliff : Text
property toolbar : Object


Class constructor($ident : Text; $label : Text)
	This:C1470.ident:=$ident
	This:C1470.label:=$label
	
	This:C1470.xliff:=""
	This:C1470.toolbar:={color: "#E0E0E0"}
	This:C1470.displayOrder:=0
	This:C1470.allowedProfiles:=New collection:C1472
	
Function setToolbarBackgroundColor($color : Text)
	This:C1470.toolbar.color:=$color
	
	
Function setFocusRingColor($color : Text)
	This:C1470.toolbar.focusRing:=$color
	
	
Function setXliffLabel($xliff : Text)
	This:C1470.xliff:=$xliff
	
	
Function setDisplayOrder($order : Integer)
	This:C1470.displayOrder:=$order
	
	
Function setAllowedProfiles( ...  : Text)
	var $p : Integer
	For ($p; 1; Count parameters:C259)
		This:C1470.allowedProfiles.push(${$p})
	End for 
	
	
Function setIcon($relativeResssourcesPath : Text)
	
	This:C1470.icon:=$relativeResssourcesPath