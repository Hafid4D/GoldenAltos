// Purpose: Calendar picker for journal date on the journal entry panel (same pattern as panel_deposit).
// modified by 4D/PS [2026-june-26]
Case of 
	: (Form event:C1606.code=On Clicked:K2:4)
		If (cs:C1710.panel_journalEntry.me._canEdit())
			Form:C1466.panelJournalWorkDate:=Form:C1466.current_item.journalDate
			If (Form:C1466.panelJournalWorkDate=Null:C1517) || (Form:C1466.panelJournalWorkDate=!00-00-00!)
				Form:C1466.panelJournalWorkDate:=Current date:C33(*)
			End if
			cs:C1710.Util.me.btnDatePicker(Form:C1466; "panelJournalWorkDate")
			Form:C1466.current_item.journalDate:=Form:C1466.panelJournalWorkDate
			cs:C1710.panel_journalEntry.me._activate_save_cancel_button()
		End if
End case 
