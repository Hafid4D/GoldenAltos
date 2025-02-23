//%attributes = {}
var $eAssumption : cs:C1710.AssumptionEntity
var $eQuote : cs:C1710.QuoteEntity
var $eQuoteLine : cs:C1710.QuoteLineEntity
var $eCustomer : cs:C1710.CustomerEntity

$assumptions_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/quote_assumptions.json")
If ($assumptions_file.exists)
	TRUNCATE TABLE:C1051([QuoteLine:129])
	TRUNCATE TABLE:C1051([Quote:128])
	TRUNCATE TABLE:C1051([Assumption:2])
	
	$quote_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/quotes.json")
	If ($quote_file.exists)
		$quotes:=JSON Parse:C1218($quote_file.getText())
		For each ($quote; $quotes)
			$eQuote:=ds:C1482.Quote.new()
			$eCustomer:=ds:C1482.Customer.query("name == :1"; $quote.Company).first()
			If ($eCustomer=Null:C1517)
				$eCustomer:=ds:C1482.Customer.new()
				$eCustomer.name:=$quote.Company
				$eCustomer.save()
			End if 
			$eQuote.UUID_Customer:=$eCustomer.UUID
			$eQuote.code:=$quote.QuoteNumber
			$eQuote.currentStatusID:=1
			$eQuote.subject:=$quote.Subject
			$eQuote.reference:=$quote.Reference
			$eQuote.assumptions:=New object:C1471("UUIDs"; New collection:C1472())
			$eQuote.optionalPreliminaryTxt_wr:=$quote.wr_areaWP_
			$eQuote.save()
		End for each 
	End if 
	
	
	$assumptions:=JSON Parse:C1218($assumptions_file.getText())
	For each ($assumption; $assumptions)
		$eAssumption:=ds:C1482.Assumption.query("value == :1"; $assumption.Line).first()
		If ($eAssumption=Null:C1517)
			$eAssumption:=ds:C1482.Assumption.new()
			$eAssumption.value:=$assumption.Line
			$eAssumption.code:=$assumption.AssmptNum
			$result:=$eAssumption.save()
			If ($result.success)
				$eQuote:=ds:C1482.Quote.query("code == :1"; $assumption.QuoteNum).first()
				If ($eQuote#Null:C1517)
					$eQuote.assumptions.UUIDs.push($eAssumption.UUID)
					$res:=$eQuote.save()
					If ($res.success=False:C215)
						TRACE:C157
					End if 
				Else 
					TRACE:C157
				End if 
			End if 
		End if 
	End for each 
	
	
	$quoteLine_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/quote_lines.json")
	If ($quoteLine_file.exists)
		$quoteLines:=JSON Parse:C1218($quoteLine_file.getText())
		For each ($quoteLine; $quoteLines)
			$eQuoteLine:=ds:C1482.QuoteLine.new()
			$eQuoteLine.quantity:=$quoteLine.qty
			$eQuoteLine.unitPrice:=$quoteLine.unit_price
			$eQuoteLine.description:=$quoteLine.Description
			$eQuote:=ds:C1482.Quote.query("code == :1"; $quoteLine.QuoteNum).first()
			If ($eQuote=Null:C1517)
				TRACE:C157
			End if 
			$eQuoteLine.UUID_Quote:=$eQuote.UUID
			$eQuoteLine.save()
		End for each 
	End if 
	
	
	ALERT:C41("Import done.")
End if 