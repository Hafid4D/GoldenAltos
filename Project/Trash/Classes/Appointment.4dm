Class extends DataClass



Function book($appointment : Object; $uuid_person : Text)->$eAppointment : Object
	$eAppointment:=ds:C1482.Appointment.new()
	$eAppointment.UUID_MedicalStaff:=$appointment.medicalStaff.UUID
	$eAppointment.UUID_MedicalHouse:=$appointment.medicalHouse.UUID
	$eAppointment.UUID_ConsultationKind:=$appointment.consultation.UUID
	$eAppointment.UUID_Person:=$uuid_person
	$eAppointment.startStmp:=cs:C1710.sfw_stmp.me.build\
		(Add to date:C393(!00-00-00!; $appointment.year; $appointment.month; $appointment.day); \
		Time:C179($appointment.time))
	$eAppointment.duration:=900
	$eAppointment.idStatus:=-1
	$eAppointment.chronoStatus:=New object:C1471("histo"; New collection:C1472; "expiration"; cs:C1710.sfw_stmp.me.build(Current date:C33; Current time:C178+?00:15:00?))
	$eAppointment.save()
	
	
Function fromReservation($uuid_reservation : Text; $status : Integer)->$result : Object
	
	
	$eAppointment:=This:C1470.get($uuid_reservation)
	If ($eAppointment#Null:C1517)
		$eAppointment.idStatus:=$status
		$result:=$eAppointment.save()
	Else 
		$result:=New object:C1471("success"; False:C215)
	End if 
	
	
Function getAvailableAppointements($uuid_staff; $uuid_mh; $uuid_person; $uuid_consultation : Text; $options : Object)->$availableAppointements : Collection
	
	$availableAppointements:=Appointment_FindSlots($uuid_staff; $uuid_mh; $uuid_person; $uuid_consultation; $options)
	
	
exposed Function availableAppointements($day_date : Variant; $medicalCapability : Object)->$availableAppointements : Collection
	var $date : Date
	
	$availableAppointements:=New collection:C1472()
	$continue:=True:C214
	Case of 
		: (Value type:C1509($day_date)=Is text:K8:3)
			$date:=Date:C102($day_date)
			
		: (Value type:C1509($day_date)=Is real:K8:4) & (Session:C1714.storage.appointment.year#Null:C1517) & (Session:C1714.storage.appointment.month#Null:C1517)
			$date:=Add to date:C393(!00-00-00!; Session:C1714.storage.appointment.year; Session:C1714.storage.appointment.month; $day_date)
			
			Use (Session:C1714.storage.appointment)
				Session:C1714.storage.appointment.day:=$day_date
			End use 
		Else 
			$continue:=False:C215
	End case 
	
	If ($continue)
		If ($medicalCapability.uuid_staff#Null:C1517) & ($medicalCapability.uuid_medicalHouse#Null:C1517) & ($medicalCapability.uuid_consultation#Null:C1517)
			
			$uuid_staff:=$medicalCapability.uuid_staff
			$uuid_mh:=$medicalCapability.uuid_medicalHouse
			$uuid_consultation:=$medicalCapability.uuid_consultation
		Else 
			
			$uuid_staff:=Session:C1714.storage.appointment.medicalStaff.UUID
			$uuid_mh:=Session:C1714.storage.appointment.medicalHouse.UUID
			$uuid_consultation:=Session:C1714.storage.appointment.consultation.UUID
		End if 
		
		$options:=New object:C1471
		$options.date:=$date
		$options.nbSlots:=20
		$options.dontMoveDate:=True:C214
		$esAppointements:=This:C1470.getAvailableAppointements($uuid_staff; $uuid_mh; ""; $uuid_consultation; $options)
		
		$uuids_avAppointements:=$esAppointements.distinct("UUID")
		$es_toDelete:=ds:C1482.Appointment.query("UUID in :1"; $uuids_avAppointements)
		$es_toDelete:=$es_toDelete.drop()
		If ($es_toDelete.length#0)
			
		End if 
		
		For each ($e; $esAppointements)
			$availableAppointements.push($e.timeText())
		End for each 
		
	End if 
	
	
exposed Function resetSession
	Use (Session:C1714.storage)
		Session:C1714.storage.appointment:=Null:C1517
	End use 
	
	
	