//%attributes = {}

// Purpose: Open the Make Deposit dialog for undeposited PAY lines (list action).
// Returns: nothing.
// created by 4D/PS [2026-june-22]

var $form : Object
var $winRef : Integer
var $result : Object

$form:=New object:C1471(\
	"paymentLines"; New collection:C1472(); \
	"bankAccountUUID"; ""; \
	"bankAccountName"; ""; \
	"depositDate"; Current date:C33(*); \
	"memo"; "Bank deposit"; \
	"totalSelected"; 0)

$winRef:=Open form window:C675("_ga_makeDeposit"; Plain form window:K39:6; Horizontally centered:K39:3; Vertically centered:K39:4)
SET WINDOW TITLE:C213("Make Deposit"; $winRef)
DIALOG:C40("_ga_makeDeposit"; $form)
CLOSE WINDOW:C154($winRef)

If (OK=1)
	$result:=$form.dialogResult
	If ($result#Null:C1517)
		cs:C1710.sfw_dialog.me.alert("Deposit of "+String:C10($result.totalDeposited; "###,###,##0.00")+" recorded.")
	End if
End if
