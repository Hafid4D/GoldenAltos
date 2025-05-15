Class extends Entity

local Function afterCreation()
	This:C1470._initTools()
	This:C1470._initParametricMeasurements()
	This:C1470._initStepInterruptions()
	This:C1470._initDataTables()
	This:C1470._initBins()
	This:C1470._initSkills()
	This:C1470._initRequiredCertifications()
	
local Function itemLoad()
	This:C1470._initTools()
	This:C1470._initParametricMeasurements()
	This:C1470._initStepInterruptions()
	This:C1470._initDataTables()
	This:C1470._initBins()
	This:C1470._initSkills()
	This:C1470._initRequiredCertifications()
	
local Function _initTools
	If (Form:C1466.currentStep.tools=Null:C1517)
		Form:C1466.currentStep.tools:=New object:C1471("items"; New collection:C1472())
	End if 
	
local Function _initParametricMeasurements
	If (Form:C1466.currentStep.parametricMeasurements=Null:C1517)
		Form:C1466.currentStep.parametricMeasurements:=New object:C1471("items"; New collection:C1472())
	End if 
	
local Function _initStepInterruptions
	If (Form:C1466.currentStep.stepInterruptions=Null:C1517)
		Form:C1466.currentStep.stepInterruptions:=New object:C1471("items"; New collection:C1472())
	End if 
	
local Function _initDataTables
	If (Form:C1466.currentStep.dataTables=Null:C1517)
		Form:C1466.currentStep.dataTables:=New object:C1471("items"; New collection:C1472())
	End if 
	
local Function _initBins
	If (Form:C1466.currentStep.bins=Null:C1517)
		Form:C1466.currentStep.bins:=New object:C1471("items"; New collection:C1472())
	End if 
	
local Function _initSkills
	If (Form:C1466.currentStep.skills=Null:C1517)
		Form:C1466.currentStep.skills:=New object:C1471("items"; New collection:C1472())
	End if 
	
local Function _initRequiredCertifications
	If (Form:C1466.currentStep.requitedCertifications=Null:C1517)
		Form:C1466.currentStep.requitedCertifications:=New object:C1471("items"; New collection:C1472())
	End if 
	