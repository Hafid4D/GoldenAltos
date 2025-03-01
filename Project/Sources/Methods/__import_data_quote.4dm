//%attributes = {}
var $eAssumption : cs:C1710.AssumptionEntity
var $eQuote : cs:C1710.QuoteEntity
var $eQuoteLine : cs:C1710.QuoteLineEntity
var $eContact : cs:C1710.ContactEntity
var $eCostumer : cs:C1710.CustomerEntity

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
			
			
			$eCostumer:=ds:C1482.Customer.query("name == :1"; $quote.Company).first()
			If ($eCostumer=Null:C1517)
				$eCostumer:=ds:C1482.Customer.new()
				$eCostumer.name:=$quote.Company
				$reslt:=$eCostumer.save()
			End if 
			
			$eContact:=ds:C1482.Contact.query("code == :1"; $quote.ContactCode).first()
			If ($eContact=Null:C1517)
				$eContact:=ds:C1482.Contact.new()
				$eContact.UUID_Customer:=$eCostumer.UUID
				$eContact.firstName:=$quote.Fname
				$eContact.lastName:=$quote.Lname
				$eContact.code:=$quote.ContactCode
				
				$eContact.contactDetails:=New object:C1471()
				$eContact.contactDetails.addresses:=New collection:C1472()
				$address:=New object:C1471()
				$address.type:="main"
				$address.detail:=New object:C1471()
				$address.detail.country:="US"
				$address.detail.street_1:=$quote.add1
				If (String:C10($quote.add2)#"")
					$address.detail.street_2:=$quote.add2
				End if 
				$address.detail.postcode:=$quote.zip
				$address.detail.iso_code_2:="US"
				$address.detail.city:=$quote.add3
				$address.detail.state:=$quote.ST
				$eContact.contactDetails.addresses.push($address)
				
				$eContact.contactDetails.communications:=New collection:C1472()
				$comm:=New object:C1471()
				$comm.phone:=$quote.tel_num
				$comm.fax:=$quote.fax_num
				$comm.email:=$quote.CopyToEmailAddr
				$eContact.contactDetails.communications.push($comm)
				
				$eContact.save()
			End if 
			
			
			$eQuote.UUID_Contact:=$eContact.UUID
			$eQuote.code:=$quote.QuoteNumber
			$eQuote.currentStatusID:=1
			$eQuote.subject:=$quote.Subject
			$eQuote.reference:=$quote.Reference
			$eQuote.assumptions:=New object:C1471("UUIDs"; New collection:C1472())
			
			$wpFile:=Folder:C1567(fk data folder:K87:12).file("DataJson/wpQuotes/"+$quote.QuoteNumber+".4wp")
			If ($wpFile.exists)
				$eQuote.optionalPreliminaryTxt_wr:=WP Import document:C1318($wpFile.platformPath)
			End if 
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
	
	
	
End if 