//%attributes = {}

// Purpose: SFW create callback — persist manual adjusting journal from panel Form state.
// Parameters:
// $newEntity : Pointer — receives the saved JournalEntryEntity
// $itemCopy : Object — copy of Form.current_item at save time
// Returns: nothing (alerts on failure)
// created by 4D/PS [2026-june-29]

#DECLARE($newEntity : Pointer; $itemCopy : Object)

var $result : Object
var $lines : Collection
var $memo : Text
var $check : Object

$check:=_ga_jeValidateForm()
If (Not:C34($check.valid))
	If ($check.error#"")
		cs:C1710.sfw_dialog.me.alert($check.error)
	End if
	return 
End if

If (Form:C1466.journalEntryLines=Null:C1517)
	$lines:=New collection:C1472()
Else
	$lines:=Form:C1466.journalEntryLines
End if

$memo:=Form:C1466.current_item.memo
If ($memo=Null:C1517)
	$memo:=""
End if

$result:=_ga_saveJournalEntry(\
	Form:C1466.current_item.UUID; \
	Form:C1466.current_item.entryNumber; \
	Form:C1466.current_item.journalDate; \
	$memo; \
	$lines)

If ($result.success)
	If ($newEntity#Null:C1517)
		$newEntity->:=ds:C1482.JournalEntry.get($result.entryUUID)
	End if
Else
	If ($result.error="")
		$result.error:="Could not save journal entry."
	End if
	cs:C1710.sfw_dialog.me.alert($result.error)
End if
