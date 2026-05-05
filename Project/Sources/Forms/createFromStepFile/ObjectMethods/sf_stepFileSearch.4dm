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
					$obj:=New object:C1471()
					$obj.order:=$item.order
					$obj.description:=String:C10($item.description)
					
					If (cs:C1710.sfw_string.me.isAnEmptyUUID($item.UUID_Step)=False:C215)
						$step_es:=ds:C1482.Step.query("UUID = :1"; $item.UUID_Step)
						If ($step_es.length>0)
							$obj.description:=$step_es[0].description
						End if 
					End if 
					
					$stepsCollection.push($obj)
					
				End for each 
				
			Else 
				
				If ((Form:C1466.stepFile.moreData#Null:C1517) & (Form:C1466.stepFile.moreData.selectedSteps#Null:C1517))
					For each ($step; Form:C1466.stepFile.moreData.selectedSteps)
						
						$step_es:=ds:C1482.Step.query("UUID = :1"; $step.UUID)
						
						If ($step_es.length>0)
							
							$obj:=New object:C1471()
							$obj.order:=$step.order
							$obj.description:=$step_es[0].description
							
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
