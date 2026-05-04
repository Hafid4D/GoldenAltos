// Purpose: On each printed LotStep detail, fills Storage.travelerPrintCtx.bakeP2MirrorRow (single-row collection for page-2 listbox) mirroring page 1 fields, then delegates to _ga_TravelerFormMethodNew. Call _ga_TravelerPrintBegin once after PRINT SETTINGS before printing lot steps.
// modified by 4D/PS [2026-april-28]

var $ctx : Object
var $tools0 : Text
var $supv : Text
var $si; $so : Text

If (Form event code:C388=On Printing Detail:K2:18)
	
	$ctx:=_ga_TravelerPrintGetCtx
	$tools0:=""
	If ([LotStep:5]tools:17#Null:C1517)
		If ([LotStep:5]tools:17.items#Null:C1517)
			If ([LotStep:5]tools:17.items.length>0)
				$tools0:=String:C10([LotStep:5]tools:17.items[0])
			End if 
		End if 
	End if 
	
	$supv:=""
	If ([LotStep:5]moreData:42#Null:C1517)
		$supv:=String:C10([LotStep:5]moreData:42.supervisor)
	End if 
	
	$si:=String:C10(sdatein)
	$so:=String:C10(sdateout)
	
	Use ($ctx)
		$ctx.bakeP2MirrorRow:=New collection:C1472(New object:C1471(\
			"m_order"; [LotStep:5]order:3; \
			"m_description"; [LotStep:5]description:4; \
			"m_qtyIn"; [LotStep:5]qtyIn:6; \
			"m_dateOn"; $si; \
			"m_rejects"; [LotStep:5]rejects:15; \
			"m_qtyOut"; [LotStep:5]qtyOut:7; \
			"m_dateOff"; $so; \
			"m_operator"; String:C10([LotStep:5]outOperator:29); \
			"m_supervisor"; $supv; \
			"m_comment"; String:C10([LotStep:5]comment1:21); \
			"m_tool1"; $tools0))
	End use 
	
End if 

_ga_TravelerFormMethodNew(Current method name:C684)

Case of 
	: (Form event code:C388=On Load:K2:1)
		//FORM GOTO PAGE(2)
		Form:C1466.lb_lotSteps:=ds:C1482.LotStep.all()
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 

