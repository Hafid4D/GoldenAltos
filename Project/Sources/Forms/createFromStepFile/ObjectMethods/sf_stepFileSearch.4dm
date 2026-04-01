Case of 
	: (FORM Event:C1606.code=-2000)
		//TRACE
		OBJECT SET VISIBLE:C603(*; "sf_stepFileSearch"; False:C215)
		
		If (Form:C1466.sf_stepFileSearch.selectedItem#Null:C1517)
			C_COLLECTION:C1488($stepsCollection)
			$stepsCollection:=New collection:C1472()
			Form:C1466.searchStepFile:=Form:C1466.sf_stepFileSearch.selectedItem.name
			
			Form:C1466.stepFile:=ds:C1482.StepFile.new()
			Form:C1466.stepFile:=Form:C1466.sf_stepFileSearch.selectedItem
			
			For each ($step; Form:C1466.stepFile.moreData.selectedSteps)
				
				$step_entity:=ds:C1482.Step.query("UUID = :1"; $step.UUID).first()
				
				If ($step_entity#Null:C1517)
					
					$obj:=New object:C1471()
					$obj.order:=$step.order
					$obj.description:=$step_entity.description
					
					$stepsCollection.push($obj)
					
				End if 
				
			End for each 
			
			Form:C1466.steps:=$stepsCollection
			
		End if 
		
	: (FORM Event:C1606.code=-3000)
		OBJECT SET VISIBLE:C603(*; "sf_stepFileSearch"; False:C215)
		OBJECT SET SUBFORM:C1138(*; "sf_stepFileSearch"; "")
End case 
