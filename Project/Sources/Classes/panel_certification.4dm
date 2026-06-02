
singleton Class constructor
	//It's a singleton class
	
Function formMethod()
	//This function manages the main logic for updating and refreshing the form
	Form:C1466.sfw.panelFormMethod()
	If (Form:C1466.sfw.updateOfPanelNeeded())
		// Purpose: Keep frequency checkboxes in sync when switching certification records.
		// modified by 4D/PS [2026-june-02]
		This:C1470.syncFrequencyFormFromEntity()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())
		Case of 
			: (FORM Get current page:C276(*)=2)
				This:C1470.syncFrequencyFormFromEntity()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if 
	
	
// Purpose: Mirror entity retrainingFrequencies / oneTime onto form booleans for page 2 checkboxes.
// modified by 4D/PS [2026-june-02]
Function syncFrequencyFormFromEntity()
	
	var $freqs : Collection
	
	If (Form:C1466.current_item=Null:C1517)
		return 
	End if 
	$freqs:=Form:C1466.current_item.getRetrainingFrequencies()
	Form:C1466.freqQuarterly:=($freqs.indexOf("quarterly")#-1)
	Form:C1466.freqHalfYear:=($freqs.indexOf("halfYear")#-1)
	Form:C1466.freqAnnually:=($freqs.indexOf("annually")#-1)
	
	
Function redrawAndSetVisible()
	
	OBJECT SET ENABLED:C1123(*; "entryField_duration"; False:C215)
	OBJECT SET ENABLED:C1123(*; "cb_freqQuarterly"; Form:C1466.sfw.checkIsInModification() && Not:C34(Form:C1466.current_item.oneTime))
	OBJECT SET ENABLED:C1123(*; "cb_freqHalfYear"; $inModification && Not:C34(Form:C1466.current_item.oneTime))
	OBJECT SET ENABLED:C1123(*; "cb_freqAnnually"; $inModification && Not:C34(Form:C1466.current_item.oneTime))
	OBJECT SET ENABLED:C1123(*; "entryField_oneTime"; $inModification)
	
	
// Purpose: Toggle one retraining frequency on the certification type (Karla 2.f — multiple allowed).
// Parameters: $ident : Text — quarterly | halfYear | annually
// modified by 4D/PS [2026-june-02]
Function cb_retrainFrequency($ident : Text)
	
	If (Not:C34(Form:C1466.sfw.checkIsInModification())) || (Form:C1466.current_item=Null:C1517)
		return 
	End if 
	
	Case of 
		: ($ident="quarterly")
			Form:C1466.current_item.setRetrainingFrequency("quarterly"; Form:C1466.freqQuarterly)
		: ($ident="halfYear")
			Form:C1466.current_item.setRetrainingFrequency("halfYear"; Form:C1466.freqHalfYear)
		: ($ident="annually")
			Form:C1466.current_item.setRetrainingFrequency("annually"; Form:C1466.freqAnnually)
	End case 
	
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
	
// Purpose: One time clears frequencies; selecting a frequency clears one time (Karla 2.f).
// modified by 4D/PS [2026-june-02]
Function cb_oneTime()
	
	If (Not:C34(Form:C1466.sfw.checkIsInModification())) || (Form:C1466.current_item=Null:C1517)
		return 
	End if 
	
	Form:C1466.current_item.applyOneTimeRule(Form:C1466.current_item.oneTime)
	This:C1470.syncFrequencyFormFromEntity()
	This:C1470.redrawAndSetVisible()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
