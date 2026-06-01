Class extends Entity


local Function get approvalDate()->$approvalDate : Date
	If (This:C1470.stmpApproval=0)
		$approvalDate:=!00-00-00!
	Else 
		$approvalDate:=cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpApproval; True:C214)
	End if 
local Function set approvalDate($approvalDate : Date)
	If ($approvalDate=!00-00-00!)
		This:C1470.stmpApproval:=0
	Else 
		This:C1470.stmpApproval:=cs:C1710.sfw_stmp.me.build($approvalDate)
	End if 
	
	
// Purpose: ORDA save hook — normalize object fields on every persist (UI, import, duplicate, etc.).
// Returns: Object — { success : Boolean }
// modified by 4D/PS [2026-june-01]
Function validateSave($event : Object) -> $result : Object
	This:C1470._normalizeObjectFields()
	$result:=New object:C1471("success"; True)
	
local Function afterCreation()
	This:C1470._normalizeObjectFields()
	If (Form:C1466.currentStep#Null:C1517)
		Form:C1466.currentStep._normalizeObjectFields()
	End if 
	
local Function itemLoad()
	This:C1470._normalizeObjectFields()
	If (Form:C1466.currentStep#Null:C1517)
		Form:C1466.currentStep._normalizeObjectFields()
	End if 

// Purpose: Guarantee canonical object-field shape on This (and UI step when present).
// Ensures .items collections, parametricMeasurements in/out, and properties keys exist
// so panels can bind listboxes without null checks. Safe for legacy import partial JSON.
// modified by 4D/PS [2026-june-01]
Function _normalizeObjectFields()
	This:C1470._ensureItemsObject("tools")
	This:C1470._ensureItemsObject("bins")
	This:C1470._ensureItemsObject("stepInterruptions")
	This:C1470._ensureItemsObject("dataTables")
	This:C1470._ensureItemsObject("skills")
	This:C1470._ensureItemsObject("requitedCertifications")
	This:C1470._normalizeParametricMeasurements()
	This:C1470._normalizeProperties()
	
local Function _ensureItemsObject($attributeName : Text)
	var $field : Object
	$field:=This:C1470[$attributeName]
	If ($field=Null:C1517)
		This:C1470[$attributeName]:=New object:C1471("items"; New collection:C1472())
	Else 
		If ($field.items=Null:C1517)
			$field.items:=New collection:C1472()
		End if 
	End if 
	
local Function _normalizeParametricMeasurements()
	var $pm : Object
	var $zeroPars : Object
	$zeroPars:=New object:C1471("par1"; 0; "par2"; 0; "par3"; 0)
	$pm:=This:C1470.parametricMeasurements
	If ($pm=Null:C1517)
		This:C1470.parametricMeasurements:=New object:C1471(\
			"items"; New collection:C1472(); \
			"in"; OB Copy:C1225($zeroPars); \
			"out"; OB Copy:C1225($zeroPars)\
			)
	Else 
		If ($pm.items=Null:C1517)
			$pm.items:=New collection:C1472()
		End if 
		If ($pm.in=Null:C1517)
			$pm.in:=OB Copy:C1225($zeroPars)
		End if 
		If ($pm.out=Null:C1517)
			$pm.out:=OB Copy:C1225($zeroPars)
		End if 
	End if 
	
local Function _normalizeProperties()
	var $props : Object
	var $defaults : Object
	$defaults:=New object:C1471(\
		"pgm"; ""; \
		"pgmSwitch"; ""; \
		"hardware1"; ""; \
		"hardware2"; ""; \
		"probeCard"; ""; \
		"count1"; 0; \
		"count2"; 0; \
		"count3"; 0\
		)
	If (This:C1470.properties=Null:C1517)
		This:C1470.properties:=OB Copy:C1225($defaults)
	Else 
		$props:=This:C1470.properties
		If ($props.pgm=Null:C1517)
			$props.pgm:=""
		End if 
		If ($props.pgmSwitch=Null:C1517)
			$props.pgmSwitch:=""
		End if 
		If ($props.hardware1=Null:C1517)
			$props.hardware1:=""
		End if 
		If ($props.hardware2=Null:C1517)
			$props.hardware2:=""
		End if 
		If ($props.probeCard=Null:C1517)
			$props.probeCard:=""
		End if 
		If ($props.count1=Null:C1517)
			$props.count1:=0
		End if 
		If ($props.count2=Null:C1517)
			$props.count2:=0
		End if 
		If ($props.count3=Null:C1517)
			$props.count3:=0
		End if 
	End if 
