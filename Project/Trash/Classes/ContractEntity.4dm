Class extends Entity


Function get customerNameInWizard()->$name : Text
	$name:=This:C1470.customer.nameInWizard
	
Function get nameInWizard()->$name : Text
	$name:="🖋️ "+This:C1470.name
	
	
	//mark:-
	
Function get contractTypeName()->$name : Text
	$name:=This:C1470.contractType.name
	
	//mark:-
	
	
local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	
	$nameInWindowTitle:=This:C1470.name
	
	
local Function get dateSigning()->$date : Date
	$date:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpSigning; True:C214)
	
	
local Function set dateSigning($date : Date)
	If ($date#!00-00-00!)
		This:C1470.stmpSigning:=cs:C1710.sfw_stmp.me.build($date)
	Else 
		This:C1470.stmpSigning:=0
	End if 
	
	
local Function get budgetWithCurrency()->$budget : Text
	$budget:=String:C10(This:C1470.budget; "###,##0.00 ;###,##0.00-")
	If (This:C1470.currency#Null:C1517)
		$budget+=" "+This:C1470.currency.symbol
	End if 
	
Function get meta()->$meta : Object
	$meta:=New object:C1471
	$meta.cell:=New object:C1471
	$meta.cell.contractType:=New object:C1471
	$meta.cell.contractType.fill:=This:C1470.contractType.color
	$lum:=cs:C1710.sfw_htmlColor.me.getLuminence(This:C1470.contractType.color)
	If ($lum>=0.5)
		$meta.cell.contractType.stroke:="black"
	Else 
		$meta.cell.contractType.stroke:="white"
	End if 
	