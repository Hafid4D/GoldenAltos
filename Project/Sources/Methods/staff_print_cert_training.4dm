//%attributes = {}



If (True:C214)
	
	
	
Else 
	
	var $assign : cs:C1710.CertificationAssignmentEntity
	
	QUERY:C277([Staff:135]; [Staff:135]UUID:1=Form:C1466.current_item.UUID)
	
	//FORM SET OUTPUT([Staff]; "cert_training")
	//PRINT RECORD([Staff])
	
	PRINT SETTINGS:C106()
	
	OPEN PRINTING JOB:C995
	
	$form:=New object:C1471()
	
	$form.employee:=New object:C1471(\
		"lastName"; [Staff:135]lastName:5; \
		"firstName"; [Staff:135]firstName:4; \
		"department"; [Staff:135]moreData:11; \
		"division"; [Staff:135]UUID_Division:14; \
		"code"; [Staff:135]code:10; \
		"retrainingDate"; [Staff:135]stmpRetrain:3\
		)
	
	Print form:C5([Staff:135]; "cert_training"; $form; Form header:K43:3)
	
	// Purpose: Valid trainings — expiredIn is duration days; filter uses computed validityActive, not expiredIn versus now().
	// modified by 4D/PS [2026-may-12]
	For each ($assign; Form:C1466.current_item.assignments)
		If ($assign.validityActive)
			
			$form:=New object:C1471()
			
			$form.certification:=New object:C1471(\
				"name"; $assign.certification.name; \
				"date"; $assign.certificationDate\
				)
			Print form:C5([Staff:135]; "cert_training"; $form; Form detail:K43:1)
			Print form:C5([Staff:135]; "cert_training"; Form break0:K43:14)
			
		End if 
	End for each 
	
	Print form:C5([Staff:135]; "other_traning"; Form header:K43:3)
	
	// Purpose: Expired trainings — finite duration rows whose validity window ended before today.
	// modified by 4D/PS [2026-may-12]
	For each ($assign; Form:C1466.current_item.assignments)
		If (($assign.expiredIn>0) && Not:C34($assign.validityActive))
			
			$form:=New object:C1471()
			
			$form.certification:=New object:C1471(\
				"name"; $assign.certification.name; \
				"date"; $assign.certificationDate\
				)
			Print form:C5([Staff:135]; "cert_training"; $form; Form detail:K43:1)
			Print form:C5([Staff:135]; "cert_training"; Form break0:K43:14)
			
		End if 
	End for each 
	
	
	Print form:C5([Staff:135]; "cert_training"; Form footer:K43:2)
	
	CLOSE PRINTING JOB:C996
End if 
