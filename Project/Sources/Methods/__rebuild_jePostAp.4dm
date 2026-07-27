//%attributes = {"executedOnServer":true}

// Purpose: Rebuild vendor-side GL entries (bills, checks, supplier credits, expenses).
// Parameters: none — processes imported AP sub-ledger rows.
// Returns: nothing (shows summary alert for admin/designer).
// modified by 4D/PS [2026-june-29]

var $eLine : cs:C1710.BuyingOrderLineEntity
var $eCheck : cs:C1710.CheckEntity
var $lines : cs:C1710.BuyingOrderLineSelection
var $res : Object
var $billOk : Integer
var $billErr : Integer
var $payOk : Integer
var $payErr : Integer
var $creditOk : Integer
var $creditErr : Integer
var $msg : Text
var $errText : Text
var $eCredit : cs:C1710.SupplierCreditEntity
var $eExpense : cs:C1710.ExpenseTransactionEntity
var $expenseOk : Integer
var $expenseErr : Integer

$billOk:=0
$billErr:=0
$payOk:=0
$payErr:=0
$creditOk:=0
$creditErr:=0
$expenseOk:=0
$expenseErr:=0
$errText:=""

If (ds:C1482.CAO.getDefaultAP()=Null:C1517)
	ALERT:C41("DefaultA/P is not configured. Run __import_data_chartOfAccount first.")
Else 
	
	For each ($eLine; ds:C1482.BuyingOrderLine.all())
		$res:=_ga_jePostBill($eLine)
		If ($res.success)
			$billOk:=$billOk+1
		Else 
			$billErr:=$billErr+1
			If ($errText="")
				$errText:=String:C10($res.error)
			End if
		End if
	End for each
	
	For each ($eCheck; ds:C1482.Check.all())
		// Purpose: Refresh bank GL mapping on checks before payment posting (e.g. Bank imported after Check).
		// modified by 4D/PS [2026-june-29]
		If (_ga_enrichCheckBank($eCheck).updated)
			$eCheck.save()
		End if
		$lines:=ds:C1482.BuyingOrderLine.query("checkNumber = :1"; $eCheck.checkNumber)
		For each ($eLine; $lines)
			$res:=_ga_jePostApPayment($eLine; $eCheck)
			If ($res.success)
				$payOk:=$payOk+1
			Else 
				$payErr:=$payErr+1
				If ($errText="")
					$errText:=String:C10($res.error)
				End if
			End if
		End for each
	End for each
	
	For each ($eCredit; ds:C1482.SupplierCredit.all())
		$res:=_ga_jePostSupplierCredit($eCredit)
		If ($res.success)
			$creditOk:=$creditOk+1
		Else 
			$creditErr:=$creditErr+1
			If ($errText="")
				$errText:=String:C10($res.error)
			End if
		End if
	End for each
	
	For each ($eExpense; ds:C1482.ExpenseTransaction.all())
		$res:=_ga_jePostExpense($eExpense)
		If ($res.success)
			$expenseOk:=$expenseOk+1
		Else 
			$expenseErr:=$expenseErr+1
			If ($errText="")
				$errText:=String:C10($res.error)
			End if
		End if
	End for each
	
	$msg:="AP GL rebuild complete."+Char:C90(13)
	$msg:=$msg+"Bills posted: "+String:C10($billOk)+", errors: "+String:C10($billErr)+Char:C90(13)
	$msg:=$msg+"Check payments posted: "+String:C10($payOk)+", errors: "+String:C10($payErr)+Char:C90(13)
	$msg:=$msg+"Supplier credits posted: "+String:C10($creditOk)+", errors: "+String:C10($creditErr)+Char:C90(13)
	$msg:=$msg+"Expenses posted: "+String:C10($expenseOk)+", errors: "+String:C10($expenseErr)
	If ($errText#"")
		$msg:=$msg+Char:C90(13)+"First error: "+$errText
	End if
	ALERT:C41($msg)
	
End if
