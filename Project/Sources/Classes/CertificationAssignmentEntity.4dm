Class extends Entity


local Function get certificationDate()->$date : Date
	$date:=This:C1470.certificationStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.certificationStmp; True:C214)
	
local Function set certificationDate($date : Date)
	This:C1470.certificationStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
	
// Purpose: Calendar lapse date (certification date + expiredIn days). Field expiredIn stores a duration in days, not an stmp.
// Returns: Date — empty date when no stamp, no finite duration, or invalid base date.
// modified by 4D/PS [2026-may-12]
local Function get expiringDate()->$date : Date
	
	var $certDt : Date
	
	$date:=!00-00-00!
	If (This:C1470.certificationStmp=0)
		return 
	End if 
	$certDt:=This:C1470.certificationDate
	If ($certDt=!00-00-00!)
		return 
	End if 
	If (This:C1470.expiredIn<=0)
		return 
	End if 
	$date:=Add to date:C393($certDt; 0; 0; This:C1470.expiredIn)
	
	
// Purpose: Persist lapse date by adjusting expiredIn (days after certificationDate). Empty date clears finite validity (expiredIn:=0).
// Parameters: $date — calendar lapse date (!00-00-00! = no expiry window from duration).
// modified by 4D/PS [2026-may-12]
local Function set expiringDate($date : Date)
	
	var $certDt : Date
	var $delta : Integer
	
	If ($date=!00-00-00!)
		This:C1470.expiredIn:=0
		return 
	End if 
	If (This:C1470.certificationStmp=0)
		return 
	End if 
	$certDt:=This:C1470.certificationDate
	If ($certDt=!00-00-00!)
		return 
	End if 
	$delta:=$date-$certDt
	If ($delta<=0)
		This:C1470.expiredIn:=0
	Else 
		This:C1470.expiredIn:=$delta
	End if 
	
	
// Purpose: True when the assignment counts as valid — perpetual when expiredIn<=0, otherwise today is on or before expiringDate.
// modified by 4D/PS [2026-may-12]
local Function get validityActive()->$active : Boolean
	
	If (This:C1470.certificationStmp=0)
		$active:=False:C215
		return 
	End if 
	If (This:C1470.expiredIn<=0)
		$active:=True:C214
		return 
	End if 
	$active:=(This:C1470.expiringDate>=Current date:C33())
	
	
// Purpose: Align stored duration with a desired validity flag — True clears finite expiry (expiredIn:=0); False sets expiredIn so lapse is on or before yesterday when certification predates yesterday (otherwise expiredIn:=1; lapse may still be on/after today if certificationDate is very recent).
// Parameters: $active : Boolean — target validity regarding calendar lapse vs today.
// modified by 4D/PS [2026-may-12]
local Function set validityActive($active : Boolean)
	
	var $certDt : Date
	var $yesterday : Date
	var $delta : Integer
	
	If ($active)
		This:C1470.expiredIn:=0
		return 
	End if 
	If (This:C1470.certificationStmp=0)
		return 
	End if 
	$certDt:=This:C1470.certificationDate
	If ($certDt=!00-00-00!)
		return 
	End if 
	$yesterday:=Add to date:C393(Current date:C33(); 0; 0; -1)
	$delta:=$yesterday-$certDt
	If ($delta>0)
		This:C1470.expiredIn:=$delta
	Else 
		This:C1470.expiredIn:=1
	End if 
	
