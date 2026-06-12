Class extends Entity

// Purpose: Certification type helpers — duration = assignment validity in days; retrainingFrequencies = reminder milestones only (Karla 2.f).
// Ident values: quarterly (90d), halfYear (180d), annually (365d). One time clears validity duration and frequencies.
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
	
	
// Purpose: When oneTime is set, clear retraining frequencies and validity duration (no expiry window).
// modified by 4D/PS [2026-june-02]
Function applyOneTimeRule($oneTime : Boolean)
	
	This:C1470.oneTime:=$oneTime
	If ($oneTime)
		If (This:C1470.moreData=Null:C1517)
			This:C1470.moreData:=New object:C1471
		End if 
		This:C1470.moreData.retrainingFrequencies:=New collection:C1472
		This:C1470.duration:=0
	End if 
	
	
// Purpose: Validity length in days for new staff assignments (Certification.duration — not re-training frequencies).
// Returns: Integer — 0 when oneTime; otherwise duration, shortest retraining frequency, or 365-day legacy default
// modified by 4D/PS [2026-june-08]
Function expiredInDaysForNewAssignment()->$days : Integer
	
	var $ident : Text
	var $candidate : Integer
	var $map : Object
	
	$days:=0
	If (This:C1470.oneTime)
		return 
	End if 
	
	If (This:C1470.duration>0)
		$days:=This:C1470.duration
		return 
	End if 
	
	// Purpose: Legacy records may have duration 0 while frequencies were previously used to fill validity.
	// modified by 4D/PS [2026-june-02]
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
	
	// Purpose: Catalog import often leaves duration at 0; align with legacy staff training default (365 days).
	// modified by 4D/PS [2026-june-08]
	If ($days=0)
		$days:=365
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
	
	
// Purpose: Human-readable summary of selected re-training reminder periods (for panel display).
// Returns: Text — e.g. "Reminders at: 90, 180, 365 days" or empty when one time / none
// modified by 4D/PS [2026-june-02]
Function retrainFrequencySummaryLabel()->$label : Text
	
	var $parts : Collection
	var $ident : Text
	var $map : Object
	
	$parts:=New collection:C1472()
	If (This:C1470.oneTime)
		$label:="One time — no re-training reminders"
		return $label
	End if 
	
	$map:=New object:C1471(\
		"quarterly"; "90"; \
		"halfYear"; "180"; \
		"annually"; "365")
	
	For each ($ident; This:C1470.getRetrainingFrequencies())
		If ($map[$ident]#Null:C1517)
			$parts.push($map[$ident])
		End if 
	End for each 
	
	If ($parts.length=0)
		$label:="No re-training frequency selected"
	Else 
		$label:="Reminders at: "+$parts.join(", ")+" days (from certification date)"
	End if 
	
	
// Purpose: Days used when assigning this cert to staff (from Certification.duration).
// Returns: Integer — same as expiredInDaysForNewAssignment; 0 when one time
// modified by 4D/PS [2026-june-02]
Function assignmentValidityDays()->$days : Integer
	
	$days:=This:C1470.expiredInDaysForNewAssignment()
	