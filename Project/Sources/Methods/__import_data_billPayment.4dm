//%attributes = {"executedOnServer":true}

// Purpose: Import bill payment lines from legacy PartialPays export JSON into typed catalog fields.
// Parameters: reads DataJson/partialPays_export.json from the data folder.
// Returns: nothing (truncates and reloads BillPayment).
// modified by 4D/PS [2026-june-29]

var $records : Collection
var $file : 4D:C1709.File
var $ePayment : cs:C1710.BillPaymentEntity
var $seq : Integer

TRUNCATE TABLE:C1051([BillPayment:152])

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/partialPays_export.json")
If ($file.exists)
	$records:=JSON Parse:C1218($file.getText())
	$seq:=0
	For each ($record; $records)
		$seq:=$seq+1
		$ePayment:=ds:C1482.BillPayment.new()
		$ePayment.paymentNumber:=$seq
		$ePayment.paymentDateStmp:=_ga_legacyDateToStmp($record.P_date)
		If (OB Is defined:C1231($record; "Amt"))
			$ePayment.amount:=Num:C11($record.Amt)
		End if
		If (OB Is defined:C1231($record; "Chknum"))
			$ePayment.checkNumber:=Num:C11($record.Chknum)
		End if
		If (OB Is defined:C1231($record; "inv_num"))
			$ePayment.invoiceNumber:=Num:C11($record.inv_num)
		End if
		$ePayment.invoiceDateStmp:=_ga_legacyDateToStmp($record.inv_date)
		If (OB Is defined:C1231($record; "DebitMemo"))
			$ePayment.debitMemoNumber:=Num:C11($record.DebitMemo)
		End if
		If (OB Is defined:C1231($record; "BuyItemSeqNum"))
			$ePayment.buyItemSeqNumber:=Num:C11($record.BuyItemSeqNum)
		End if
		$ePayment.save()
	End for each
End if
