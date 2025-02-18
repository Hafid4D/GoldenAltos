
Class extends DataClass


local Function cacheClear()
	This:C1470._waitSemaphore()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.medicalHouse:=Null:C1517
		End use 
	End if 
	This:C1470._removeSemaphore()
	
local Function cacheLoad($skipSemaphoreTesting : Boolean)
	$waitSempahore:=(Not:C34(Bool:C1537($skipSemaphoreTesting)))
	If ($waitSempahore)
		This:C1470._waitSemaphore()
	End if 
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.medicalHouse=Null:C1517)
		$medicalHouseColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.medicalHouse:=$medicalHouseColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	If ($waitSempahore)
		This:C1470._removeSemaphore()
	End if 
	
local Function cacheGet($uuid : Text)->$mh : Object
	This:C1470._waitSemaphore()
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad(True:C214)
	Else 
		If (Storage:C1525.cache.medicalHouse=Null:C1517)
			This:C1470.cacheLoad(True:C214)
		End if 
	End if 
	$indices:=Storage:C1525.cache.medicalHouse.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$mh:=Storage:C1525.cache.medicalHouse[$indices[0]]
	Else 
		$mh:=New object:C1471
	End if 
	This:C1470._removeSemaphore()
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "MedicalHouse")
	End if 
	
	
Function _loadAsCollection()->$medicalHouseColl : Collection
	
	$medicalHouseColl:=This:C1470.all().toCollection("UUID, name").orderBy("name")
	
Function _waitSemaphore()
	While (Semaphore:C143("$cache_MedicalHouse"; 500))
		IDLE:C311
	End while 
	
Function _removeSemaphore()
	CLEAR SEMAPHORE:C144("$cache_MedicalHouse")
	