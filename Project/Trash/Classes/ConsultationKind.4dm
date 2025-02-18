Class extends DataClass


local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.consultationKind:=Null:C1517
		End use 
	End if 
	
local Function cacheLoad()
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.consultationKind=Null:C1517)
		$consultationKindColl:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.consultationKind:=$consultationKindColl.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
local Function cacheGet($uuid : Text)->$ck : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.activity=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.consultationKind.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$ck:=Storage:C1525.cache.consultationKind[$indices[0]]
	Else 
		$ck:=New object:C1471
	End if 
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "ConsultationKind")
	End if 
	
	
Function _loadAsCollection()->$consultationKindColl : Collection
	
	$consultationKindColl:=This:C1470.all().toCollection("UUID, name").orderBy("name")
	
	
	
	
Function getCountsByYear($year : Integer)->$series : Collection
	
	var $esConsultationKind : cs:C1710.ConsultationKindSelection
	var $eConsultationKind : cs:C1710.ConsultationKindEntity
	
	$series:=New collection:C1472
	$from:=cs:C1710.sfw_stmp.me.build(Add to date:C393(!00-00-00!; $year; 1; 1); ?00:00:00?)
	$to:=cs:C1710.sfw_stmp.me.build(Add to date:C393(!00-00-00!; $year+1; 1; 1); ?00:00:00?)
	
	$esConsultationKind:=This:C1470.all()
	For each ($eConsultationKind; $esConsultationKind)
		$serie:=$eConsultationKind.toObject("UUID, name")
		
		$esAppointements:=$eConsultationKind.appointments.query("startStmp >= :1 & startStmp < :2"; $from; $to)
		$serie.count:=$esAppointements.length
		
		$series.push($serie)
	End for each 
	
	$series:=$series.orderBy("count desc")
	