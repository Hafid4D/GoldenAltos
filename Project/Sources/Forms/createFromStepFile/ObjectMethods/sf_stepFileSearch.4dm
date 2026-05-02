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
			
			If ((Form:C1466.stepFile.stepsDefinition#Null:C1517) & (Form:C1466.stepFile.stepsDefinition.items#Null:C1517) & (Form:C1466.stepFile.stepsDefinition.items.length>0))
				
				For each ($item; Form:C1466.stepFile.stepsDefinition.items)
					
					If (cs:C1710.sfw_string.me.isAnEmptyUUID($item.UUID_Step)=False:C215)
						$step_entity:=ds:C1482.Step.query("UUID = :1"; $item.UUID_Step).first()
					Else 
						$step_entity:=Null:C1517
					End if 
					
					$obj:=New object:C1471()
					$obj.order:=$item.order
					If ($step_entity#Null:C1517)
						$obj.description:=$step_entity.description
					Else 
						$obj.description:=String:C10($item.description)
					End if 
					
					$stepsCollection.push($obj)
					
				End for each 
				
			Else 
				
				If ((Form:C1466.stepFile.moreData#Null:C1517) & (Form:C1466.stepFile.moreData.selectedSteps#Null:C1517))
					For each ($step; Form:C1466.stepFile.moreData.selectedSteps)
						
						$step_entity:=ds:C1482.Step.query("UUID = :1"; $step.UUID).first()
						
						If ($step_entity#Null:C1517)
							
							$obj:=New object:C1471()
							$obj.order:=$step.order
							$obj.description:=$step_entity.description
							
							$stepsCollection.push($obj)
							
						End if 
						
					End for each 
				End if 
				
			End if 
			
			Form:C1466.steps:=$stepsCollection
			
		End if 
		
	: (FORM Event:C1606.code=-3000)
		OBJECT SET VISIBLE:C603(*; "sf_stepFileSearch"; False:C215)
		OBJECT SET SUBFORM:C1138(*; "sf_stepFileSearch"; "")
End case 
