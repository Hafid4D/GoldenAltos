Class constructor
	
// Purpose: Daily scheduler — notify each staff member's linked user when certifications need re-training within 30 days.
// Parameters: $uuid_certification : Text — unused (scheduler callback signature); kept for compatibility.
// Returns: Boolean — True when the run completed.
// modified by 4D/PS [2026-june-12]
Function CheckCertificationRetraining($uuid_certification : Text)->$success : Boolean
	
	ds:C1482.Staff.checkRetraining(30)
	$success:=True:C214
