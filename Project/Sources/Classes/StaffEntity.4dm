Class extends Entity

Function hasCertification($uuid_certification : Text)->$certified : Boolean
	$certified:=(ds:C1482.CertificationAssignment.query("UUID_Staff = :1 AND UUID_Certification = :2"; This:C1470.UUID; $uuid_certification).length>0)
	
Function createCertification($uuid_certification : Text)->$certified : Boolean
	$certificationAssignment:=ds:C1482.CertificationAssignment.new()
	
	$certificationAssignment.UUID_Staff:=This:C1470.UUID
	$certificationAssignment.UUID_Certification:=$uuid_certification
	
	$res:=$certificationAssignment.save()
	
	$certified:=$res.success
	
Function deleteCertification($uuid_certification : Text)->$certified : Boolean
	$certificationAssignment_es:=ds:C1482.CertificationAssignment.query("UUID_Staff = :1 AND UUID_Certification = :2"; This:C1470.UUID; $uuid_certification)
	
	If ($certificationAssignment_es.length>0)
		$res:=$certificationAssignment_es[0].drop()
		
		$certified:=Not:C34($res.success)
	End if 
	