//%attributes = {}

// Imports project/imports/steps_files_export.json into StepFile (name, customer link, moreData meta,
// stepsDefinition.items built from record.arrays).

var $projectFolder : 4D:C1709.Folder
var $importsFolder : 4D:C1709.Folder
var $file : 4D:C1709.File
var $records : Collection
var $record : Object
var $arrays : Object
var $customer : 4D:C1709.Entity
var $stepFile : 4D:C1709.Entity
var $items : Collection
var $row : Object
var $i : Integer
var $max : Integer
var $res : Object
var $created : Integer
var $updated : Integer
var $failed : Integer
var $v : Variant
var $abortCustomer : Boolean
var $specificationEntity : 4D:C1709.Entity

$projectFolder:=Folder:C1567(fk database folder:K87:14)
$importsFolder:=$projectFolder.folder("project/imports")
$file:=$importsFolder.file("steps_files_export.json")

If (Not:C34($file.exists))
	ALERT:C41("Import file not found: "+$file.platformPath)
Else 
	$records:=JSON Parse:C1218($file.getText())
	
	$created:=0
	$updated:=0
	$failed:=0
	
	For each ($record; $records)
		
		If ((String:C10($record.Name)="") | (String:C10($record.Customer)=""))
			$failed:=$failed+1
		Else 
			
			$customer:=ds:C1482.Customer.query("name = :1"; String:C10($record.Customer)).first()
			$abortCustomer:=False:C215
			If ($customer=Null:C1517)
				$customer:=ds:C1482.Customer.new()
				$customer.name:=String:C10($record.Customer)
				$res:=$customer.save()
				If (Not:C34($res.success))
					$failed:=$failed+1
					$abortCustomer:=True:C214
				End if 
			End if 
			
			If (Not:C34($abortCustomer))
			
			$stepFile:=ds:C1482.StepFile.query("name = :1"; String:C10($record.Name)).first()
			If ($stepFile=Null:C1517)
				$stepFile:=ds:C1482.StepFile.new()
				$created:=$created+1
			Else 
				$updated:=$updated+1
			End if 
			
			$stepFile.name:=String:C10($record.Name)
			$stepFile.UUID_Customer:=$customer.UUID
			$stepFile.status:=True:C214
			
			If (Undefined:C82($record.Date_made)=False:C215)
				$stepFile.creationDate:=$record.Date_made
			End if 
			
			$stepFile.moreData:=Choose:C955($stepFile.moreData=Null:C1517; New object:C1471(); $stepFile.moreData)
			$stepFile.moreData.Made_by:=String:C10($record.Made_by)
			$stepFile.moreData.Date_mod:=String:C10($record.Date_mod)
			$stepFile.moreData.Mod_by:=String:C10($record.Mod_by)
			$stepFile.moreData.Mod_history:=String:C10($record.Mod_history)
			
			$arrays:=Choose:C955(Value type:C1509($record.arrays)=Is object:K8:27; $record.arrays; New object:C1471())
			
			$max:=0
			If ($arrays.a_tsdesc#Null:C1517)
				If ($arrays.a_tsdesc.length>$max)
					$max:=$arrays.a_tsdesc.length
				End if 
			End if 
			If ($arrays.a_tsnum#Null:C1517)
				If ($arrays.a_tsnum.length>$max)
					$max:=$arrays.a_tsnum.length
				End if 
			End if 
			If ($arrays.a_ttime#Null:C1517)
				If ($arrays.a_ttime.length>$max)
					$max:=$arrays.a_ttime.length
				End if 
			End if 
			If ($arrays.a_tstype#Null:C1517)
				If ($arrays.a_tstype.length>$max)
					$max:=$arrays.a_tstype.length
				End if 
			End if 
			If ($arrays.a_tsalert#Null:C1517)
				If ($arrays.a_tsalert.length>$max)
					$max:=$arrays.a_tsalert.length
				End if 
			End if 
			If ($arrays.a_Area#Null:C1517)
				If ($arrays.a_Area.length>$max)
					$max:=$arrays.a_Area.length
				End if 
			End if 
			If ($arrays.a_tsyield#Null:C1517)
				If ($arrays.a_tsyield.length>$max)
					$max:=$arrays.a_tsyield.length
				End if 
			End if 
			If ($arrays.a_tempC#Null:C1517)
				If ($arrays.a_tempC.length>$max)
					$max:=$arrays.a_tempC.length
				End if 
			End if 
			If ($arrays.a_template_repeat#Null:C1517)
				If ($arrays.a_template_repeat.length>$max)
					$max:=$arrays.a_template_repeat.length
				End if 
			End if 
			If ($arrays.a_planhrs#Null:C1517)
				If ($arrays.a_planhrs.length>$max)
					$max:=$arrays.a_planhrs.length
				End if 
			End if 
			If ($arrays.A_BomForStep#Null:C1517)
				If ($arrays.A_BomForStep.length>$max)
					$max:=$arrays.A_BomForStep.length
				End if 
			End if 
			If ($arrays.A_StepProperty#Null:C1517)
				If ($arrays.A_StepProperty.length>$max)
					$max:=$arrays.A_StepProperty.length
				End if 
			End if 
			If ($arrays.A_StepPropertyinText#Null:C1517)
				If ($arrays.A_StepPropertyinText.length>$max)
					$max:=$arrays.A_StepPropertyinText.length
				End if 
			End if 
			If ($arrays.A_TS_SPEC#Null:C1517)
				If ($arrays.A_TS_SPEC.length>$max)
					$max:=$arrays.A_TS_SPEC.length
				End if 
			End if 
			
			$items:=New collection:C1472()
			
			// JSON arrays parse to 0-based collections: row $i (1..max) → element [$i-1].
			For ($i; 1; $max)
				
				$row:=New object:C1471
				
				$v:=Null:C1517
				If ($arrays.a_tsnum#Null:C1517)
					If ($i<=$arrays.a_tsnum.length)
						$v:=$arrays.a_tsnum[$i-1]
					End if 
				End if 
				$row.order:=Num:C11($v)
				If ($row.order=0)
					$row.order:=$i
				End if 
				
				$v:=Null:C1517
				If ($arrays.a_tsdesc#Null:C1517)
					If ($i<=$arrays.a_tsdesc.length)
						$v:=$arrays.a_tsdesc[$i-1]
					End if 
				End if 
				$row.description:=String:C10($v)
				
				$v:=Null:C1517
				If ($arrays.a_ttime#Null:C1517)
					If ($i<=$arrays.a_ttime.length)
						$v:=$arrays.a_ttime[$i-1]
					End if 
				End if 
				$row.time:=Num:C11($v)
				
				$v:=Null:C1517
				If ($arrays.a_tstype#Null:C1517)
					If ($i<=$arrays.a_tstype.length)
						$v:=$arrays.a_tstype[$i-1]
					End if 
				End if 
				$stepTemplateNumber:=Num:C11($v)
				$row.UUID_Step:=16*"00"
				
				$v:=Null:C1517
				If ($arrays.a_tsalert#Null:C1517)
					If ($i<=$arrays.a_tsalert.length)
						$v:=$arrays.a_tsalert[$i-1]
					End if 
				End if 
				$row.alert:=String:C10($v)
				
				$v:=Null:C1517
				If ($arrays.a_Area#Null:C1517)
					If ($i<=$arrays.a_Area.length)
						$v:=$arrays.a_Area[$i-1]
					End if 
				End if 
				$row.area:=String:C10($v)
				
				$v:=Null:C1517
				If ($arrays.a_tsyield#Null:C1517)
					If ($i<=$arrays.a_tsyield.length)
						$v:=$arrays.a_tsyield[$i-1]
					End if 
				End if 
				$row.yield:=Num:C11($v)
				
				$v:=Null:C1517
				If ($arrays.a_tempC#Null:C1517)
					If ($i<=$arrays.a_tempC.length)
						$v:=$arrays.a_tempC[$i-1]
					End if 
				End if 
				$row.temp_c:=Num:C11($v)
				
				$v:=Null:C1517
				If ($arrays.a_template_repeat#Null:C1517)
					If ($i<=$arrays.a_template_repeat.length)
						$v:=$arrays.a_template_repeat[$i-1]
					End if 
				End if 
				$row.template_repeat:=Num:C11($v)
				
				$v:=Null:C1517
				If ($arrays.a_planhrs#Null:C1517)
					If ($i<=$arrays.a_planhrs.length)
						$v:=$arrays.a_planhrs[$i-1]
					End if 
				End if 
				$row.planned_hours:=Num:C11($v)
				
				$v:=Null:C1517
				If ($arrays.A_BomForStep#Null:C1517)
					If ($i<=$arrays.A_BomForStep.length)
						$v:=$arrays.A_BomForStep[$i-1]
					End if 
				End if 
				$row.bom_for_step:=String:C10($v)
				
				$v:=Null:C1517
				If ($arrays.A_StepProperty#Null:C1517)
					If ($i<=$arrays.A_StepProperty.length)
						$v:=$arrays.A_StepProperty[$i-1]
					End if 
				End if 
				$row.step_property:=Num:C11($v)
				
				$v:=Null:C1517
				If ($arrays.A_StepPropertyinText#Null:C1517)
					If ($i<=$arrays.A_StepPropertyinText.length)
						$v:=$arrays.A_StepPropertyinText[$i-1]
					End if 
				End if 
				$row.step_property_in_text:=String:C10($v)
				
				$v:=Null:C1517
				If ($arrays.A_TS_SPEC#Null:C1517)
					If ($i<=$arrays.A_TS_SPEC.length)
						$v:=$arrays.A_TS_SPEC[$i-1]
					End if 
				End if 
				$row.specification:=String:C10($v)
				$row.UUID_Specification:=16*"00"
				If ($row.specification#"")
					$specificationEntity:=ds:C1482.Specification.query("spec = :1"; $row.specification).first()
					If ($specificationEntity#Null:C1517)
						$row.UUID_Specification:=$specificationEntity.UUID
					End if 
				End if 
				
				If ($stepTemplateNumber#0)
					$stepTemplateEs:=ds:C1482.StepTemplate.query("templateNumber = :1"; $stepTemplateNumber)
					If ($stepTemplateEs.length>0)
						$row.step_property_rules:=cs:C1710.panel_stepFile.me.newStepPropertyRulesObjectFromTemplate($stepTemplateEs[0])
					Else 
						$row.step_property_rules:=New object:C1471("items"; New collection:C1472())
					End if 
				Else 
					$row.step_property_rules:=New object:C1471("items"; New collection:C1472())
				End if 
				
				// Create one Step record per imported row, then keep its UUID on the definition row.
				$stepEntity:=ds:C1482.Step.new()
				$stepEntity.description:=$row.description
				$stepEntity.alert:=$row.alert
				$stepEntity.areas:=$row.area
				$stepEntity.UUID_StepTemplate:=16*"00"
				If ($stepTemplateNumber#0)
					$stepTemplateEs:=ds:C1482.StepTemplate.query("templateNumber = :1"; $stepTemplateNumber)
					If ($stepTemplateEs.length>0)
						$stepEntity.UUID_StepTemplate:=$stepTemplateEs[0].UUID
					End if 
				End if 
				$stepEntity.UUID_StepArea:=16*"00"
				If ($row.area#"")
					$stepAreaEs:=ds:C1482.StepArea.query("name = :1"; $row.area)
					If ($stepAreaEs.length>0)
						$stepEntity.UUID_StepArea:=$stepAreaEs[0].UUID
					End if 
				End if 
				$stepEntity.UUID_StepProcess:=16*"00"
				$stepEntity.UUID_Specification:=$row.UUID_Specification
				$stepEntity.stepProperties:=New object:C1471("items"; New collection:C1472())
				$stepEntity.moreData:=New object:C1471()
				
				$stepRes:=$stepEntity.save()
				If ($stepRes.success)
					$row.UUID_Step:=$stepEntity.UUID
				End if 
				
				$items.push($row)
				
			End for 
			
			$stepFile.stepsDefinition:=New object:C1471("items"; $items)
			
			$res:=$stepFile.save()
			If (Not:C34($res.success))
				$failed:=$failed+1
			End if 
			
			End if 
			
		End if 
		
	End for each 
	
	ALERT:C41("Import steps files — created: "+String:C10($created)+" | updated: "+String:C10($updated)+" | failed: "+String:C10($failed))
End if 
