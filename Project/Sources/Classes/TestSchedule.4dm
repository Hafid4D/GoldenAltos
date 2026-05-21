Class constructor
	
// Purpose: Daily scheduler entry point — notify qs and qm when staff certifications expire within 30 days.
// Parameters: $uuid_certification : Text — unused (scheduler callback signature); kept for compatibility.
// Returns: Boolean — True when the run completed.
// modified by 4D/PS [2026-may-21]
Function CheckCertificationRetraining($uuid_certification : Text)->$success : Boolean
	
	ds:C1482.Staff.checkRetraining(30)
	$success:=True:C214
