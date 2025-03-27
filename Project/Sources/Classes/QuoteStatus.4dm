Class extends DataClass


local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.quoteStatus=Null:C1517)
		$quoteStatusColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.quoteStatus:=$quoteStatusColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
Function _loadAsCollection()->$quoteStatusColl : Collection
	$quoteStatusColl:=This:C1470.all().toCollection("UUID, statusID, code, name, color").orderBy("statusID")