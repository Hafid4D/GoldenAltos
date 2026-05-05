//%attributes = {}

var $projectFolder : 4D:C1709.Folder
var $importsFolder : 4D:C1709.Folder
var $file : 4D:C1709.File
var $records : Collection
var $record : Object
var $stepDataClass : 4D:C1709.DataClass
var $stepTemplateDataClass : 4D:C1709.DataClass
var $stepAreaDataClass : 4D:C1709.DataClass
var $processDataClass : 4D:C1709.DataClass
var $stepPropertyDataClass : 4D:C1709.DataClass
var $stepEntity : 4D:C1709.Entity
var $templateEntity : 4D:C1709.Entity
var $areaEntity : 4D:C1709.Entity
var $processEntity : 4D:C1709.Entity
var $stepPropertyMaster : 4D:C1709.Entity
var $result : Object
var $created : Integer
var $failed : Integer
var $templateNumber : Integer
var $processName : Text
var $areaName : Text
var $propertyMask : Integer
var $propertyBit : Text
var $propertyBitMask : Integer
var $stepSpecDataClass : 4D:C1709.DataClass
var $specificationEntity : 4D:C1709.Entity
var $controlSpecKey : Text

$stepDataClass:=ds:C1482["Step"]
$stepTemplateDataClass:=ds:C1482["StepTemplate"]
$stepAreaDataClass:=ds:C1482["StepArea"]
$processDataClass:=ds:C1482["StepProcess"]
$stepPropertyDataClass:=ds:C1482["StepProperty"]
$stepSpecDataClass:=ds:C1482["StepSpec"]

If (($stepDataClass=Null:C1517) | ($stepTemplateDataClass=Null:C1517) | ($stepAreaDataClass=Null:C1517) | ($processDataClass=Null:C1517) | ($stepPropertyDataClass=Null:C1517) | ($stepSpecDataClass=Null:C1517))
	ALERT:C41("Missing DataClass: Step, StepTemplate, StepArea, StepProcess, StepProperty or StepSpec.")
Else 
	$stepSpecDataClass.all().drop()
	$stepDataClass.all().drop()
	
	$projectFolder:=Folder:C1567(fk database folder:K87:14)
	$importsFolder:=$projectFolder.folder("project/imports")
	$file:=$importsFolder.file("steps_export.json")
	
	If (Not:C34($file.exists))
		ALERT:C41("Import file not found: "+$file.platformPath)
	Else 
		$records:=JSON Parse:C1218($file.getText())
		
		$created:=0
		$failed:=0
		
		For each ($record; $records)
			$stepEntity:=$stepDataClass.new()
			
			$templateNumber:=Num:C11($record.Template)
			$templateEntity:=$stepTemplateDataClass.query("templateNumber = :1"; $templateNumber).first()
			If ($templateEntity#Null:C1517)
				$stepEntity.UUID_StepTemplate:=$templateEntity.UUID
			Else 
				$stepEntity.UUID_StepTemplate:=16*"00"
			End if 
			
			$areaName:=$record.Area
			$areaEntity:=$stepAreaDataClass.query("name = :1"; $areaName).first()
			If ($areaEntity#Null:C1517)
				$stepEntity.UUID_StepArea:=$areaEntity.UUID
			Else 
				$stepEntity.UUID_StepArea:=16*"00"
			End if 
			
			$stepEntity.description:=$record.Description
			$stepEntity.alert:=$record.Step_Alert
			$controlSpecKey:=String:C10($record.ControlSpec)
			$specificationEntity:=Null:C1517
			If ($controlSpecKey#"")
				$specificationEntity:=ds:C1482.Specification.query("spec = :1"; $controlSpecKey).first()
			End if 
			$stepEntity.UUID_Specification:=16*"00"
			If ($specificationEntity#Null:C1517)
				$stepEntity.UUID_Specification:=$specificationEntity.UUID
				$stepEntity.specification:=$specificationEntity
			End if 
			$stepEntity.areas:=$areaName
			$stepEntity.moreData:=New object:C1471()
			If (($controlSpecKey#"") & ($specificationEntity=Null:C1517))
				$stepEntity.moreData.controlSpecText:=$controlSpecKey
			End if 
			
			$processName:=$record.Process
			$stepEntity.moreData.Process:=$processName
			$processEntity:=$processDataClass.query("name = :1"; $processName).first()
			If ($processEntity#Null:C1517)
				$stepEntity.UUID_StepProcess:=$processEntity.UUID
				$stepEntity.moreData.processName:=$processEntity.name
			Else 
				$stepEntity.UUID_StepProcess:=16*"00"
				$stepEntity.moreData.processName:=""
			End if 
			
			$propertyMask:=Num:C11($record.StepProperty)
			$stepEntity.stepProperties:=New object:C1471("items"; New collection:C1472())
			For each ($stepPropertyMaster; $stepPropertyDataClass.all().orderBy("levelID"))
				$propertyBit:=String:C10($stepPropertyMaster.moreData.bit)
				$propertyBitMask:=Num:C11($propertyBit)
				Case of 
					: ($propertyBit="0x0001")
						$propertyBitMask:=0x0001
					: ($propertyBit="0x0002")
						$propertyBitMask:=0x0002
					: ($propertyBit="0x0004")
						$propertyBitMask:=0x0004
					: ($propertyBit="0x0008")
						$propertyBitMask:=0x0008
					: ($propertyBit="0x0010")
						$propertyBitMask:=0x0010
					: ($propertyBit="0x0020")
						$propertyBitMask:=0x0020
					: ($propertyBit="0x0040")
						$propertyBitMask:=0x0040
					: ($propertyBit="0x0080")
						$propertyBitMask:=0x0080
					: ($propertyBit="0x0100")
						$propertyBitMask:=0x0100
					: ($propertyBit="0x0200")
						$propertyBitMask:=0x0200
					: ($propertyBit="0x0400")
						$propertyBitMask:=0x0400
					: ($propertyBit="0x0800")
						$propertyBitMask:=0x0800
					: ($propertyBit="0x1000")
						$propertyBitMask:=0x1000
					: ($propertyBit="0x2000")
						$propertyBitMask:=0x2000
					: ($propertyBit="0x4000")
						$propertyBitMask:=0x4000
					: ($propertyBit="0x8000")
						$propertyBitMask:=0x8000
					: ($propertyBit="0x00010000")
						$propertyBitMask:=0x00010000
					: ($propertyBit="0x00020000")
						$propertyBitMask:=0x00020000
					: ($propertyBit="0x00040000")
						$propertyBitMask:=0x00040000
					: ($propertyBit="0x00080000")
						$propertyBitMask:=0x00080000
					: ($propertyBit="0x00100000")
						$propertyBitMask:=0x00100000
				End case 
				
				$stepEntity.stepProperties.items.push(New object:C1471(\
					"id"; $stepPropertyMaster.UUID; \
					"name"; $stepPropertyMaster.name; \
					"description"; $stepPropertyMaster.description; \
					"bit"; $propertyBit; \
					"enable"; (($propertyMask & $propertyBitMask)=$propertyBitMask)\
					))
			End for each 
			
			$result:=$stepEntity.save()
			If ($result.success)
				$created:=$created+1
			Else 
				$failed:=$failed+1
			End if 
		End for each 
		
		ALERT:C41("Import termine - steps: "+String:C10($created)+" | failed: "+String:C10($failed))
	End if 
End if 
