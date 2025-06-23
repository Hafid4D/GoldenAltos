//%attributes = {"executedOnServer":true}

var $eCip : cs:C1710.ContinuousImprovementEntity

If (True:C214)
	var $eCategory : cs:C1710.CICategoryEntity
	var $eQuestion : cs:C1710.YesNoQuestionEntity
	var $ePriority : cs:C1710.CIPriorityEntity
	var $eOrigin : cs:C1710.CIOriginEntity
	var $eHumanFactor : cs:C1710.CIHumanFactorEntity
	var $eDisposition : cs:C1710.CIDispositionEntity
	
	var $colors : Collection:=New collection:C1472("#3CB371"; "#FFFF00"; "#FF7F50"; "#1E90FF"; "#FF0000")
	var $categories : Collection:=New collection:C1472("Internal Risk Mitigation"; \
		"External Risk Mitigation"; "Internal Opportunity"; "External Opportunity"; "NMCR Only"; \
		"Resource Need"; "Change to QMS"; "Corrective Action"; "Training Need"; "NCR Only"; "Improve Process"; \
		"SCAR"; "RMA-KPI"; "RMA-NonKPI"; "NCMR Only"; "Corrective Action and Training"; "Repair"; "Other")
	var $questions : Collection:=New collection:C1472("Yes"; "No"; "N/A")
	var $priorities : Collection:=New collection:C1472("Active"; "Monitor"; "Deferred"; "Complete"; "Canceled")
	var $origins : Collection:=New collection:C1472("NCR"; "NCMR"; "SWOT"; "Process Risk"; "Human Factors"; \
		"Management Review"; "Internal Audit"; "Internal Issue"; "Customer Audit"; "CB Audit"; "Customer CAR"; \
		"Complaint"; "Feedback"; "Supplier"; "RMA"; "KPI/Objective Performance"; "Regulatory"; "Process Improvement"; "Other")
	var $humanFactors : Collection:=New collection:C1472("Not CAR"; "Not Applicable"; "Fatigue"; \
		"Lack of Concentration"; "Complacency"; "Lack of Knowledge"; "Distraction"; "Lack of Teamwork"; \
		"Lack of Resources"; "Pressure"; "Lack of Assertiveness"; "Stress"; "Lack of Awareness"; \
		"Negative Norms "; "Ergonomics"; "Equipment"; "Culture"; "Competence"; "Environmental"; \
		"Feelings"; "Lack of personnel"; "Other")
	var $dispositions : Collection:=New collection:C1472("N/A (Not NCP)"; "Awaiting Disp."; "Scrap"; "Rework"; "Notified the customer"; \
		"Repair"; "Use As Is"; "Return To Vendor"; "Improve methods"; "Increase Inventory"; "Revise Spec, Training"; "Revise Procedure")
	
	
	//----> [CICategory]
	TRUNCATE TABLE:C1051([CICategory:33])
	For ($i; 0; $categories.length-1)
		
		$eCategory:=ds:C1482.CICategory.new()
		$eCategory.categoryID:=$i+1
		$eCategory.name:=$categories[$i]
		$eCategory.save()
		
	End for 
	
	//----> [YesNoQuestion]
	TRUNCATE TABLE:C1051([YesNoQuestion:34])
	For ($i; 0; $questions.length-1)
		
		$eQuestion:=ds:C1482.YesNoQuestion.new()
		$eQuestion.responseID:=$i+1
		$eQuestion.name:=$questions[$i]
		$eQuestion.save()
		
	End for 
	
	//----> [CIPriority]
	TRUNCATE TABLE:C1051([CIPriority:27])
	For ($i; 0; $priorities.length-1)
		
		$ePriority:=ds:C1482.CIPriority.new()
		$ePriority.priorityID:=$i+1
		$ePriority.name:=$priorities[$i]
		$ePriority.color:=$colors[$i]
		$ePriority.save()
		
	End for 
	
	//----> [CIOrigin]
	TRUNCATE TABLE:C1051([CIOrigin:31])
	For ($i; 0; $origins.length-1)
		
		$eOrigin:=ds:C1482.CIOrigin.new()
		$eOrigin.originID:=$i+1
		$eOrigin.name:=$origins[$i]
		$eOrigin.save()
		
	End for 
	
	//----> [CIHumanFactor]
	TRUNCATE TABLE:C1051([CIHumanFactor:29])
	For ($i; 0; $humanFactors.length-1)
		
		$eHumanFactor:=ds:C1482.CIHumanFactor.new()
		$eHumanFactor.factorID:=$i+1
		$eHumanFactor.name:=$humanFactors[$i]
		$eHumanFactor.save()
		
	End for 
	
	//----> [CIDisposition]
	TRUNCATE TABLE:C1051([CIDisposition:28])
	For ($i; 0; $dispositions.length-1)
		
		$eDisposition:=ds:C1482.CIDisposition.new()
		$eDisposition.dispositionID:=$i+1
		$eDisposition.name:=$dispositions[$i]
		$eDisposition.save()
		
	End for 
	
	
End if 


$cip_log:=Folder:C1567(fk data folder:K87:12).file("DataJson/continuousImprovement.json")

If ($cip_log.exists)
	$cips:=JSON Parse:C1218($cip_log.getText())
	
	TRUNCATE TABLE:C1051([ContinuousImprovement:25])
	
	For each ($cip; $cips)
		
		$eCip:=ds:C1482.ContinuousImprovement.new()
		
		$eCip.item:=$cip.item
		$eCip.interestedParty:=$cip.interestedParty
		
		$eCip.priority:=$cip.priority
		
		$eCip.dateInitiated:=$cip.dateInitiated
		
		$origin:=ds:C1482.CIOrigin.query("name =:1"; Split string:C1554($cip.origin; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($origin.length>0)
			$eCip.origin:=$origin[0].originID
		Else 
			$eCip.origin:=$origins.length
			
		End if 
		
		$eCip.procedureType:=$cip.procedureType
		$eCip.action:=$cip.action
		$eCip.requirement:=$cip.requirement
		
		$category:=ds:C1482.CICategory.query("name =:1"; Split string:C1554($cip.category; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($category.length>0)
			$eCip.category:=$category[0].categoryID
		Else 
			
			If (Split string:C1554($cip.category; "\r"; sk trim spaces:K86:2).join("\r")="RMA-NonKPI'")
				$eCip.category:=12
			Else 
				$eCip.category:=$categories.length
			End if 
		End if 
		
		$disposition:=ds:C1482.CIDisposition.query("name =:1"; Split string:C1554($cip.disposition; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($disposition.length>0)
			$eCip.disposition:=$disposition[0].dispositionID
			
		Else 
			Case of 
					
				: (Split string:C1554($cip.disposition; "\r"; sk trim spaces:K86:2).join("\r")="Not applicable (Not NCP)") | (Split string:C1554($cip.disposition; "\r"; sk trim spaces:K86:2).join("\r")="NA (Not NCP)")
					$eCip.disposition:=1
				: (Split string:C1554($cip.disposition; "\r"; sk trim spaces:K86:2).join("\r")="Us as is")
					$eCip.disposition:=6
				Else 
					
			End case 
			
		End if 
		
		$humanFactor:=ds:C1482.CIHumanFactor.query("name =:1"; Split string:C1554($cip.humanFactor; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($humanFactor.length>0)
			$eCip.humanFactor:=$humanFactor[0].factorID
		Else 
			$eCip.humanFactor:=$humanFactors.length
		End if 
		
		$eCip.responsible:=$cip.responsible
		$eCip.originalDueDate:=$cip.originalDueDate
		$eCip.dateClosed:=$cip.dateClosed
		
		$eCip.IsAcceptable:=$cip.IsAcceptable
		$IsAcceptable:=ds:C1482.YesNoQuestion.query("name =:1"; Split string:C1554($cip.IsAcceptable; "\r"; sk trim spaces:K86:2).join("\r"))
		If ($IsAcceptable.length>0)
			$eCip.IsAcceptable:=$IsAcceptable[0].responseID
		Else 
			$eCip.IsAcceptable:=3
		End if 
		
		$eCip.externalID:=$cip.externalID
		$eCip.currentDueDate:=$cip.currentDueDate
		$eCip.notes:=$cip.notes
		$eCip.title:=""
		
		
		$res:=$eCip.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		
	End for each 
	
	
End if 

