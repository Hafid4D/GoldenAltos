Case of 
	: (FORM Event:C1606.code=-2000)
		//TRACE
		OBJECT SET VISIBLE:C603(*; "sf_stepFileSearch"; False:C215)
		
		If (Form:C1466.sf_stepFileSearch.selectedItem#Null:C1517)
			Form:C1466.searchStepFile:=Form:C1466.sf_stepFileSearch.selectedItem.name
			
			Form:C1466.stepFile:=ds:C1482.StepFile.new()
			Form:C1466.stepFile:=Form:C1466.sf_stepFileSearch.selectedItem
		End if 
		
	: (FORM Event:C1606.code=-3000)
		OBJECT SET VISIBLE:C603(*; "sf_stepFileSearch"; False:C215)
		OBJECT SET SUBFORM:C1138(*; "sf_stepFileSearch"; "")
End case 