Class extends Entity

// Purpose: Retraining frequency helpers on Certification (Karla 2.f — stored in moreData.retrainingFrequencies).
// Ident values: quarterly (90d), halfYear (180d), annually (365d). One time uses the oneTime field (no expiry).
// created by 4D/PS [2026-june-02]

Function getRetrainingFrequencies()->$frequencies : Collection
	
	If (This:C1470.moreData=Null:C1517)
		This:C1470.moreData:=New object:C1471
	End if 
	If (This:C1470.moreData.retrainingFrequencies=Null:C1517)
		This:C1470.moreData.retrainingFrequencies:=New collection:C1472
	End if 
	$frequencies:=This:C1470.moreData.retrainingFrequencies.copy()
	
	
// Purpose: Enable or disable one retraining frequency ident on this certification type.
// Parameters:
// $ident : Text — quarterly | halfYear | annually
// $enabled : Boolean — when True, adds the ident; when False, removes it
// modified by 4D/PS [2026-june-02]
Function setRetrainingFrequency($ident : Text; $enabled : Boolean)
	
	var $idx : Integer
	
	This:C1470.getRetrainingFrequencies()
	If ($enabled)
		If (This:C1470.moreData.retrainingFrequencies.indexOf($ident)=-1)
			This:C1470.moreData.retrainingFrequencies.push($ident)
		End if 
		If (This:C1470.oneTime)
			This:C1470.oneTime:=False:C215
		End if 
	Else 
		$idx:=This:C1470.moreData.retrainingFrequencies.indexOf($ident)
		If ($idx#-1)
			This:C1470.moreData.retrainingFrequencies.remove($idx)
		End if 
	End if 
	This:C1470.syncDurationFromFrequencies()
	
	
// Purpose: When oneTime is set, clear retraining frequencies and duration (new-hire orientation rule).
// modified by 4D/PS [2026-june-02]
Function applyOneTimeRule($oneTime : Boolean)
	
	This:C1470.oneTime:=$oneTime
	If ($oneTime)
		If (This:C1470.moreData=Null:C1517)
			This:C1470.moreData:=New object:C1471
		End if 
		This:C1470.moreData.retrainingFrequencies:=New collection:C1472
		This:C1470.duration:=0
	Else 
		This:C1470.syncDurationFromFrequencies()
	End if 
	
	
// Purpose: Keep legacy duration field aligned with the shortest selected retraining period (days).
// modified by 4D/PS [2026-june-02]
Function syncDurationFromFrequencies()
	
	If (This:C1470.oneTime)
		This:C1470.duration:=0
	Else 
		This:C1470.duration:=This:C1470.expiredInDaysForNewAssignment()
	End if 
	
	
// Purpose: Day count for new CertificationAssignment records (shortest active frequency, or legacy duration).
// Returns: Integer — 0 when oneTime or no finite period
// modified by 4D/PS [2026-june-02]
Function expiredInDaysForNewAssignment()->$days : Integer
	
	var $ident : Text
	var $candidate : Integer
	var $map : Object
	
	$days:=0
	If (This:C1470.oneTime)
		return 
	End if 
	
	$map:=New object:C1471(\
		"quarterly"; 90; \
		"halfYear"; 180; \
		"annually"; 365)
	
	For each ($ident; This:C1470.getRetrainingFrequencies())
		$candidate:=$map[$ident]
		If ($candidate#Null:C1517)
			If ($days=0) || ($candidate<$days)
				$days:=$candidate
			End if 
		End if 
	End for each 
	
	If ($days=0) && (This:C1470.duration>0)
		$days:=This:C1470.duration
	End if 
	
	
// Purpose: Day offsets from certification date for each retraining reminder (Karla 2.f — multiple frequencies).
// Returns: Collection of Integer — e.g. [90, 365]; empty when oneTime; falls back to duration when no frequencies set.
// modified by 4D/PS [2026-june-02]
Function retrainMilestoneDayOffsets()->$offsets : Collection
	
	var $ident : Text
	var $map : Object
	var $candidate : Integer
	
	$offsets:=New collection:C1472()
	If (This:C1470.oneTime)
		return $offsets
	End if 
	
	$map:=New object:C1471(\
		"quarterly"; 90; \
		"halfYear"; 180; \
		"annually"; 365)
	
	For each ($ident; This:C1470.getRetrainingFrequencies())
		$candidate:=$map[$ident]
		If ($candidate#Null:C1517) && ($offsets.indexOf($candidate)=-1)
			$offsets.push($candidate)
		End if 
	End for each 
	
	If ($offsets.length=0) && (This:C1470.duration>0)
		$offsets.push(This:C1470.duration)
	End if 
	