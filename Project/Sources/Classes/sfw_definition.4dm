shared singleton Class constructor
	
	This:C1470.definitionClassName:=Storage:C1525.definitionClass.name
	
	
	
	
shared Function get visions->$visions : Collection
	If (This:C1470.storedVision=Null:C1517) || (Not:C34(Is compiled mode:C492))
		$visions:=cs:C1710[This:C1470.definitionClassName].new().visions
		This:C1470.storedVisions:=$visions.copy(ck shared:K85:29; This:C1470)
	Else 
		$visions:=This:C1470.storedVisions
	End if 
	
shared Function get entries->$entries : Collection
	
	If (This:C1470.storedEntries=Null:C1517) || (Not:C34(Is compiled mode:C492))
		$entries:=cs:C1710[This:C1470.definitionClassName].new().entries
		This:C1470.storedEntries:=$entries.copy(ck shared:K85:29; This:C1470)
	Else 
		$entries:=This:C1470.storedEntries
	End if 
	
shared Function get globalParameters->$globalParameters : Object
	
	If (This:C1470.storedGlobalParameters=Null:C1517) || (Not:C34(Is compiled mode:C492))
		$globalParameters:=cs:C1710[This:C1470.definitionClassName].new().globalParameters
		This:C1470.storedGlobalParameters:=OB Copy:C1225($globalParameters; ck shared:K85:29; This:C1470)
	Else 
		$globalParameters:=This:C1470.storedGlobalParameters
	End if 
	
shared Function getEntryByIdent($entryIdent : Text)->$entry : cs:C1710.sfw_definitionEntry
	If (This:C1470.storedEntries=Null:C1517)
		$entry:=This:C1470.entries.query("ident = :1"; $entryIdent).first()
	Else 
		$entry:=This:C1470.storedEntries.query("ident = :1"; $entryIdent).first()
	End if 
	
shared Function getVisionByIdent($visionIdent : Text)->$vision : cs:C1710.sfw_definitionVision
	
	If (This:C1470.storedVisions=Null:C1517)
		$vision:=This:C1470.visions.query("ident = :1"; $visionIdent).first()
	Else 
		$vision:=This:C1470.storedVisions.query("ident = :1"; $visionIdent).first()
	End if 