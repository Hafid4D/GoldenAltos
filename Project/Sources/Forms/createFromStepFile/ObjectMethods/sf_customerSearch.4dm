Case of 
	: (FORM Event:C1606.code=-2000)
		//TRACE
		OBJECT SET VISIBLE:C603(*; "sf_customerSearch"; False:C215)
		
		If (Form:C1466.sf_customerSearch.selectedItem#Null:C1517)
			Form:C1466.searchCustomer:=Form:C1466.sf_customerSearch.selectedItem.name
			
			//Form.lotStep.tools:=New object("items"; New collection())
			//Form.lotStep.skills:=New object("items"; New collection())
			//Form.lotStep.requitedCertifications:=New object("items"; New collection())
			
			//$stepTemplateTools:=ds.StepTemplateTool.query("UUID_StepTemplate = :1"; Form.sf_customerSearch.selectedItem.UUID)
			
			//For each ($tool; $stepTemplateTools)
			//Form.lotStep.tools.items.push(New object(\
				"UUID"; $tool.toolType.UUID; \
				"order"; $tool.order; \
				"name"; $tool.toolType.name; \
				"date"; $tool.toolType.date; \
				"tool"; New object("UUID"; ""; "name"; ""; "date"; "")\
				))
			//End for each 
			
			//$stepTemplateSkills:=ds.StepTemplateCertification.query("UUID_StepTemplate = :1"; Form.sf_customerSearch.selectedItem.UUID)
			
			//For each ($skill; $stepTemplateSkills)
			//Form.lotStep.skills.items.push(New object(\
				"UUID"; $skill.certification.UUID; \
				"name"; $skill.certification.name; \
				"ref"; $skill.certification.ref\
				))
			//End for each 
			
			//For each ($st_certification; Form.sf_customerSearch.selectedItem.stepTemplateCertifications)
			//Form.lotStep.requitedCertifications.items.push(New object(\
				"UUID_Certification"; $st_certification.certification.UUID; \
				"name"; $st_certification.certification.name\
				))
			//End for each 
			
			//Form.lotStep.commentFormat1:=Form.sf_customerSearch.selectedItem.comment1
			//Form.lotStep.commentFormat2:=Form.sf_customerSearch.selectedItem.comment2
			//Form.lotStep.dataTables:=Form.sf_customerSearch.selectedItem.dataTables
			//Form.lotStep.parametricMeasurements:=Form.sf_customerSearch.selectedItem.parametricMeasurements
			//Form.lotStep.bins:=Form.sf_customerSearch.selectedItem.bins
		End if 
		
	: (FORM Event:C1606.code=-3000)
		OBJECT SET VISIBLE:C603(*; "sf_customerSearch"; False:C215)
		OBJECT SET SUBFORM:C1138(*; "sf_customerSearch"; "")
End case 