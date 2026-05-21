Class extends Entity

Function hasCertification($uuid_certification : Text)->$certified : Boolean
	
	var $assignment_es : cs:C1710.CertificationAssignmentSelection
	var $assignment_e : cs:C1710.CertificationAssignmentEntity
	
	// Purpose: CertificationAssignment.expiredIn is a day-count validity period; validity uses certificationDate + expiredIn, not a stored expiry stmp.
	// modified by 4D/PS [2026-may-12]
	$certified:=False:C215
	$assignment_es:=ds:C1482.CertificationAssignment.query("UUID_Staff = :1 AND UUID_Certification = :2"; This:C1470.UUID; $uuid_certification).orderBy("certificationDate desc")
	
	For each ($assignment_e; $assignment_es)
		If ($assignment_e.validityActive)
			$certified:=True:C214
			return 
		End if 
	End for each 
	
Function createCertification($uuid_certification : Text; $duration : Integer)->$certified : Boolean
	$certificationAssignment:=ds:C1482.CertificationAssignment.new()
	
	$certificationAssignment.UUID_Staff:=This:C1470.UUID
	$certificationAssignment.UUID_Certification:=$uuid_certification
	
	$certificationAssignment.certificationDate:=cs:C1710.sfw_stmp.me.now()
	//$certificationAssignment.certificationDate:=cs.sfw_stmp.me.build(!2024-06-01!)  // Test Only
	
	// Purpose: Persist validity length as a day count (same semantics as legacy import); expiry date is derived when querying or displaying.
	// modified by 4D/PS [2026-may-12]
	If ($duration>0)
		$certificationAssignment.expiredIn:=$duration
	Else 
		$certificationAssignment.expiredIn:=0
	End if 
	
	// Purpose: New assignment starts with retrainNotified False so qs/qm are notified when it enters the expiry window.
	// modified by 4D/PS [2026-may-21]
	$certificationAssignment.moreData:=New object:C1471("retrainNotified"; False:C215)
	
	$res:=$certificationAssignment.save()
	
	$certified:=$res.success
	
Function deleteCertification($uuid_certification : Text)->$certified : Boolean
	$certificationAssignment_es:=ds:C1482.CertificationAssignment.query("UUID_Staff = :1 AND UUID_Certification = :2"; This:C1470.UUID; $uuid_certification)
	
	If ($certificationAssignment_es.length>0)
		$res:=$certificationAssignment_es[0].drop()
		
		$certified:=Not:C34($res.success)
	End if 
	
Function getCertificationDate($uuid_certification : Text)->$certifiedAt : Date
	$assignment_es:=ds:C1482.CertificationAssignment\
		.query("UUID_Staff = :1 AND UUID_Certification = :2"; This:C1470.UUID; $uuid_certification)\
		.orderBy("certificationDate desc")
	
	If ($assignment_es.length>0)
		$certifiedAt:=$assignment_es[0].certificationDate  //cs.sfw_stmp.me.getDate($assignment_es[0].certificationDate)
	End if 
	
// Purpose: Renamed from getExpiredDate — returns the calendar expiry date (expiringDate) for the
// staff member's most recent assignment of the given certification. Parameter is Certification UUID.
// Parameters: $uuid_certification : Text — UUID of the Certification dataclass record
// Returns: Date — expiringDate of the latest assignment, or !00-00-00! when none exists
// modified by 4D/PS [2026-may-21]
Function getCertiExpiredDate($uuid_certification : Text)->$expiringDate : Date
	$assignment_es:=ds:C1482.CertificationAssignment\
		.query("UUID_Staff = :1 AND UUID_Certification = :2"; This:C1470.UUID; $uuid_certification)\
		.orderBy("certificationDate desc")
	
	If ($assignment_es.length>0)
		// Purpose: Return calendar lapse date from certification date + duration days (expiredIn).
		// modified by 4D/PS [2026-may-12]
		$expiringDate:=$assignment_es[0].expiringDate
	End if 
	
Function getCertiExpiredIn($days : Integer)->$assignment_es : cs:C1710.CertificationAssignmentSelection
	
	var $today : Date
	var $limit : Date
	var $expiry : Date
	var $a : cs:C1710.CertificationAssignmentEntity
	
	// Purpose: Assignments whose calendar expiry falls between today and today+$days (expiredIn is duration in days).
	// modified by 4D/PS [2026-may-12]
	$today:=Current date:C33()
	$limit:=Add to date:C393($today; 0; 0; $days)
	
	$assignment_es:=ds:C1482.CertificationAssignment.newSelection()
	
	For each ($a; This:C1470.assignments)
		If ($a.expiredIn>0)
			$expiry:=$a.expiringDate
			If ($expiry#!00-00-00!) && ($expiry>=$today) && ($expiry<=$limit)
				$assignment_es.add($a)
			End if 
		End if 
	End for each 
	
local Function get email()->$email : Text
	If (This:C1470.contactDetails#Null:C1517) && (This:C1470.contactDetails.communications#Null:C1517)
		$communication:=This:C1470.contactDetails.communications.query("type = :1"; "mail").first()
		If ($communication#Null:C1517)
			$email:=$communication.contact
		End if 
	End if 
	
	
local Function _initCommunication()
	If (This:C1470.contactDetails=Null:C1517)
		This:C1470.contactDetails:=New object:C1471()
	End if 
	
	If (This:C1470.contactDetails.communications=Null:C1517)
		This:C1470.contactDetails.communications:=New collection:C1472
	End if 
	
Function get fullName()->$fullName : Text
	$fullName:=[This:C1470.firstName; This:C1470.lastName].join(" ")
	
	
local Function get retrainDate()->$date : Date
	$date:=This:C1470.stmpRetrain=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpRetrain; True:C214)
	
local Function set retrainDate($date : Date)
	This:C1470.stmpRetrain:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get hireDate()->$date : Date
	$date:=This:C1470.stmpHire=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpHire; True:C214)
	
local Function set hireDate($date : Date)
	This:C1470.stmpHire:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get terminationDate()->$date : Date
	$date:=This:C1470.stmpTermination=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpTermination; True:C214)
	
local Function set terminationDate($date : Date)
	This:C1470.stmpTermination:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get creationDate()->$date : Date
	$date:=This:C1470.stmpCreation=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.stmpCreation; True:C214)
	
local Function set creationDate($date : Date)
	This:C1470.stmpCreation:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
	
local Function itemLoad()
	// This callback is called when the item is selected in the itemList
	This:C1470._initCommunication()
	
local Function afterCreation()
	// This callback is called after saving the new item
	//This.code:=String(This.codeID; "00000#")
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470.codeID:=ds:C1482.Staff.all().max("codeID")+1
	This:C1470.code:=String:C10(This:C1470.codeID; "00000#")
	
	