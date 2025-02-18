Class extends DataClass


local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.activity:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.activity=Null:C1517)
		$activityColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.activity:=$activityColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$activity : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.activity=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.activity.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$activity:=Storage:C1525.cache.activity[$indices[0]]
	Else 
		$activity:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "Activity")
	End if 
	
	
Function _loadAsCollection()->$activityColl : Collection
	
	$activityColl:=This:C1470.all().toCollection("UUID, name").orderBy("name")
	
	