//%attributes = {}
var $eAssumption : cs:C1710.AssumptionEntity
var $eQuote : cs:C1710.QuoteEntity
var $eQuoteLine : cs:C1710.QuoteLineEntity

$assumptions_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/quote_assumptions.json")
If ($customer_Log.exists)
	TRUNCATE TABLE:C1051([QuoteLine:129])
	TRUNCATE TABLE:C1051([Quote:128])
	TRUNCATE TABLE:C1051([Assumption:2])
	
	$assumptions:=JSON Parse:C1218($assumptions_file.getText())
	For each ($assumption; $assumptions)
		
		$eAssumption:=ds:C1482.Assumption.query("value == :1"; )
		$eAssumption:=ds:C1482.Assumption.new()
		
	End for each 
	
	ALERT:C41("Import done.")
End if 