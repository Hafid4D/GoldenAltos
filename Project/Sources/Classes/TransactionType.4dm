// Purpose: Reference data for SalesTransaction type (Invoice, Credit Note, Payment, Deposit).
// created by 4D/PS [2026-june-08]
Class extends DataClass

// Purpose: cacheLoad/cacheClear must be local so ds.TransactionType.cacheLoad() runs the class implementation.
// modified by 4D/PS [2026-june-08]
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.transactionType:=Null:C1517
		End use
	End if

local Function cacheLoad()
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use
	End if
	If (Storage:C1525.cache.transactionType=Null:C1517)
		$coll:=This:C1470.all().toCollection("UUID, name, code, levelID, color").orderBy("levelID")
		Use (Storage:C1525.cache)
			Storage:C1525.cache.transactionType:=$coll.copy(ck shared:K85:29; Storage:C1525.cache)
		End use
	End if
