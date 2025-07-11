//%attributes = {"executedOnServer":true}

var $eCip : cs:C1710.ContinuousImprovementEntity


$cip_log:=Folder:C1567(fk data folder:K87:12).file("DataJson/continuousImprovement.json")

If ($cip_log.exists)
	$cips:=JSON Parse:C1218($cip_log.getText())
	
	TRUNCATE TABLE:C1051([ContinuousImprovement:25])
	
	For each ($cip; $cips)
		
		$eCip:=ds:C1482.ContinuousImprovement.new()
		
		$eCip.item:=$cip.item
		$eCip.interestedParty:=Split string:C1554($cip.interestedParty; "\n"; sk ignore empty strings:K86:1+sk trim spaces:K86:2).join(",")
		
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

