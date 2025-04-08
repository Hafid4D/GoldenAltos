//%attributes = {}
var $eAssumption : cs:C1710.AssumptionEntity
var $eQuote : cs:C1710.QuoteEntity
var $eQuoteLine : cs:C1710.QuoteLineEntity
var $eContact : cs:C1710.ContactEntity
var $eCostumer : cs:C1710.CustomerEntity
var $eTermConditon : cs:C1710.TermConditionEntity
var $eQuoteStatus : cs:C1710.QuoteStatusEntity
var $eEmployee : cs:C1710.EmployeeEntity

$assumptions_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/quote_assumptions.json")
If ($assumptions_file.exists)
	TRUNCATE TABLE:C1051([QuoteLine:129])
	TRUNCATE TABLE:C1051([Quote:128])
	TRUNCATE TABLE:C1051([Assumption:2])
	TRUNCATE TABLE:C1051([QuoteStatus:5])
	
	If (True:C214)  //fill QuoteStatus table
		$eQuoteStatus:=ds:C1482.QuoteStatus.new()
		$eQuoteStatus.name:="Active"
		$eQuoteStatus.code:="A"
		$eQuoteStatus.statusID:=1
		$eQuoteStatus.save()
		
		$eQuoteStatus:=ds:C1482.QuoteStatus.new()
		$eQuoteStatus.name:="Close"
		$eQuoteStatus.code:="C"
		$eQuoteStatus.statusID:=2
		$eQuoteStatus.save()
		
		$eQuoteStatus:=ds:C1482.QuoteStatus.new()
		$eQuoteStatus.name:="Closed successfully"
		$eQuoteStatus.code:="CS"
		$eQuoteStatus.statusID:=3
		$eQuoteStatus.save()
		
		$eQuoteStatus:=ds:C1482.QuoteStatus.new()
		$eQuoteStatus.name:="Received Order"
		$eQuoteStatus.code:="RO"
		$eQuoteStatus.statusID:=4
		$eQuoteStatus.save()
		
		$eQuoteStatus:=ds:C1482.QuoteStatus.new()
		$eQuoteStatus.name:="Lost Order"
		$eQuoteStatus.code:="LO"
		$eQuoteStatus.statusID:=5
		$eQuoteStatus.save()
		
		$eQuoteStatus:=ds:C1482.QuoteStatus.new()
		$eQuoteStatus.name:="Require Follow-Up"
		$eQuoteStatus.code:="RFU"
		$eQuoteStatus.statusID:=6
		$eQuoteStatus.save()
		
		$eQuoteStatus:=ds:C1482.QuoteStatus.new()
		$eQuoteStatus.name:="Under Customer Review"
		$eQuoteStatus.code:="UCR"
		$eQuoteStatus.statusID:=7
		$eQuoteStatus.save()
	End if 
	
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
				$comm.mobile:=$quote.tel_num
				$comm.fax:=$quote.fax_num
				$comm.email:=$quote.email_addr
				$eContact.contactDetails.communications.push($comm)
				
				$eContact.save()
			End if 
			
			
			$eQuote.UUID_Contact:=$eContact.UUID
			$eQuote.code:=$quote.QuoteNumber
			
			If ($quote.Status#"")
				$eQuoteStatus:=ds:C1482.QuoteStatus.query("name == :1"; $quote.Status).first()
				If ($eQuoteStatus=Null:C1517)
					TRACE:C157
				End if 
				$eQuote.currentStatusID:=$eQuoteStatus.statusID
			Else 
				$eQuote.currentStatusID:=0
			End if 
			$eQuote.subject:=cs:C1710.Util.me.trim($quote.Subject; [" "; "\r"])
			$eQuote.reference:=cs:C1710.Util.me.trim($quote.Reference; [" "; "\r"])
			$eQuote.assumptions:=New object:C1471("UUIDs"; New collection:C1472())
			$eQuote.termsConditions:=New object:C1471("UUIDs"; New collection:C1472())
			
			$motifs:=Split string:C1554($quote.PreparedBy; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
			$eEmployee:=ds:C1482.Employee.query("lastName == :1"; $motifs[1]).first()
			If ($eEmployee=Null:C1517)
				$eEmployee:=ds:C1482.Employee.new()
				$eEmployee.firstName:=$motifs[0]
				$eEmployee.lastName:=$motifs[1]
				$eEmployee.contactDetails:=New object:C1471()
				$eEmployee.contactDetails.communications:=New collection:C1472()
			End if 
			
			If ($eEmployee.contactDetails.communications.length=0) && ($quote.PreparerEmailAndTel#"")
				$motifsPreparer:=Split string:C1554($quote.PreparerEmailAndTel; "\r"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
				If (Position:C15("@"; $motifsPreparer[0])>0)
					$email:=$motifsPreparer[0]
					$telTmp:=$motifsPreparer[1]
				Else 
					$email:=$motifsPreparer[1]
					$telTmp:=$motifsPreparer[0]
				End if 
				$tel:=Replace string:C233($telTmp; "Tel: "; "")
				If (Position:C15("ext"; $tel)>0)
					$motifs:=Split string:C1554($tel; "ext"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
					$tel:=$motifs[0]
					$ext:=$motifs[1]
				End if 
				If (Position:C15("x"; $tel)>0)
					$motifs:=Split string:C1554($tel; "x"; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
					$tel:=$motifs[0]
					$ext:=$motifs[1]
				End if 
				
				$comm:=New object:C1471()
				$comm.email:=$email
				$comm.mobile:=$tel
				$comm.ext:=$ext
				$eEmployee.contactDetails.communications.push($comm)
				
				$rss:=$eEmployee.save()
				If ($rss.success=False:C215)
					TRACE:C157
				End if 
			End if 
			
			$eQuote.UUID_Employee:=$eEmployee.UUID
			$wpFile:=Folder:C1567(fk data folder:K87:12).file("DataJson/wpQuotes/"+$quote.QuoteNumber+".4wp")
			If ($wpFile.exists)
				$eQuote.optionalPreliminaryTxt_wr:=WP Import document:C1318($wpFile.platformPath)
			End if 
			$eQuote.stmpCreation:=cs:C1710.sfw_stmp.me.build(Date:C102($quote.Qdate))
			$eQuote.revision:=$quote.Revision
			$eQuote.division:=$quote.Division
			$eQuote.voided:=$quote.void
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
	
	$terms_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/termsConditions.json")
	If ($terms_file.exists)
		$quoteTerms:=JSON Parse:C1218($terms_file.getText())
		For each ($quoteTerm; $quoteTerms)
			
			For each ($term; $quoteTerm.items)
				$eTermConditon:=ds:C1482.TermCondition.query("code == :1 and value == :2"; $term.code; $term.value).first()
				If ($eTermConditon=Null:C1517)
					$eTermConditon:=ds:C1482.TermCondition.new()
					$eTermConditon.code:=$term.code
					$eTermConditon.value:=$term.value
					$eTermConditon.save()
				End if 
				
				$eQuote:=ds:C1482.Quote.query("code == :1"; $quoteTerm.quoteNumber).first()
				If ($eQuote#Null:C1517)
					$eQuote.termsConditions.UUIDs.push($eTermConditon.UUID)
					$result:=$eQuote.save()
					If ($result.success=False:C215)
						TRACE:C157
					End if 
				Else 
					TRACE:C157
				End if 
			End for each 
		End for each 
	End if 
	
	
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