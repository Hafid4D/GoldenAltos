Class extends DataClass

local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.ImprovementCategories=Null:C1517)
		$ImprovementCategories:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.ImprovementCategories:=$ImprovementCategories.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
Function _loadAsCollection()->$ImprovementCategories : Collection
	$ImprovementCategories:=This:C1470.all().toCollection("UUID, categoryID,name").orderBy("categoryID")
	