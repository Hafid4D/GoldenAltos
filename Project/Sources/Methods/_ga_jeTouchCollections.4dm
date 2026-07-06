//%attributes = {}

// Purpose: Force listbox refresh after journal line collection mutations.
// created by 4D/PS [2026-june-29]

If (Form:C1466.journalEntryLines#Null:C1517)
	Form:C1466.journalEntryLines:=Form:C1466.journalEntryLines.copy()
End if
