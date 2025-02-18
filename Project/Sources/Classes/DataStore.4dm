Class extends DataStoreImplementation



//Mark:-Start of the sfw part 

//Mark:-Xliff
exposed Function sfw_getXliffs($resnames : Object)->$labels : Object
	$labels:=New object:C1471()
	For each ($attribut; $resnames)
		$labels[$attribut]:=This:C1470.sfw_readXliff($resnames[$attribut]; $attribut)
	End for each 
	
	
local exposed Function sfw_readXliff($xliff : Text; $label : Text)->$string : Text
	$string:=$label
	If ($xliff#Null:C1517)
		$xliff:=Localized string:C991($xliff)
		If ($xliff#"")
			$string:=$xliff
		Else 
			// write in a log file for missing xliff
		End if 
	Else 
		// write in a log file for missing xliff
	End if 
	
	//Mark:-Comment
Function sfw_getNbComments($uuid_target : Text)->$nbComments : Integer
	
	$nbComments:=ds:C1482.sfw_Comment.query("UUID_target = :1"; $uuid_target).length
	
	
Function sfw_getNbEvents($uuid_target : Text; $entry : cs:C1710.sfw_definitionEntry)->$nbEvents : Integer
	
	$nbEvents:=ds:C1482[$entry.event.dataclass].query($entry.event.linkedAttribute+" = :1"; $uuid_target).length
	
	
	//Mark:-Execute formula on server from client
Function sfw_callFormula($formula : 4D:C1709.Function;  ...  : Variant)
	
	var $params : Collection:=New collection:C1472
	var $p : Integer
	
	For ($p; 2; Count parameters:C259)
		$params.push(${$p})
	End for 
	$formula.apply(This:C1470; $params)
	
	
Function sfw_askFormula($formula : 4D:C1709.Function;  ...  : Variant)->$result : Variant
	
	var $params : Collection:=New collection:C1472
	var $p : Integer
	
	For ($p; 2; Count parameters:C259)
		$params.push(${$p})
	End for 
	$result:=$formula.apply(Null:C1517; $params)
	
	
Function sfw_fireAndForgetFormula($formula : 4D:C1709.Function; $workerName : Text;  ...  : Variant)
	var $params : Collection:=New collection:C1472
	var $p : Integer
	var $kill : Boolean
	
	For ($p; 3; Count parameters:C259)
		$params.push(${$p})
	End for 
	If ($workerName="")
		$workerName:="Worker"+Generate UUID:C1066
		$kill:=True:C214
	Else 
		$kill:=False:C215
	End if 
	CALL WORKER:C1389($workerName; Formula:C1597(ds:C1482._sfw_fireAndForgetWorker($1; $2; $3)); $formula; $kill; $params)
	
Function _sfw_fireAndForgetWorker($formula : 4D:C1709.Function; $kill : Boolean; $params : Collection)
	$formula.apply(This:C1470; $params)
	If ($kill)
		KILL WORKER:C1390
	End if 
	
	
Function sfw_checkValidationRuleUnique($dataclassName : Text; $attributeName : Text; $value : Variant; $uuid : Text)->$isUnique : Boolean
	var $esFound : Object
	
	$esFound:=ds:C1482[$dataclassName].query($attributeName+" = :1 and UUID # :2"; $value; $uuid)
	
	$isUnique:=($esFound.length=0)
	
	
Function sfw_reloadProjectOnServer()
	RELOAD PROJECT:C1739
	
	// mark:- data maintenance
exposed Function dataMaintenance()
	This:C1470.initAddressIfDoesntExist()
	//This.initContractSow()
	This:C1470.initDescriptionWP()
	This:C1470.initColor()
	//This.initTasksTechnology()
	//This.initProjectsMoreData()
	This:C1470.initCounters()
	
exposed Function initCounters()
	var $eCounter : cs:C1710.sfw_CounterEntity
	
	$eCounter:=ds:C1482.sfw_Counter.query("ident = :1"; "projectCode").first()
	If ($eCounter=Null:C1517)
		$eCounter:=ds:C1482.sfw_Counter.new()
		$eCounter.ident:="projectCode"
		$eCounter.currentValue:=104
		$info:=$eCounter.save()
	End if 
	
	
	//exposed Function initProjectsMoreData()
	//For each ($eProject; ds.Project.query("moreData = Null"))
	//$eProject.moreData:=New object
	//$eProject.UUID:=$eProject.UUID
	//$info:=$eProject.save()
	//End for each 
	
	//exposed Function initTasksTechnology()
	
	//For each ($task; ds.Task.all())
	//$task.technology:=$task.technology || cs.taskTechnologyManager.me.getDefaultTechnology()
	//$info:=$task.save()
	//End for each 
	
	
exposed Function initColor()
	For each ($dataclass; ds:C1482)
		
		If (OB Keys:C1719(ds:C1482[$dataclass]).indexOf("color")>=0)
			For each ($entity; ds:C1482[$dataclass].query("color = :1"; ""))
				$entity.color:="#FFFF00"
				$info:=$entity.save()
			End for each 
		End if 
	End for each 
	
	
exposed Function initDescriptionWP()
	For each ($dataclass; ds:C1482)
		
		If (OB Keys:C1719(ds:C1482[$dataclass]).indexOf("descriptionWP")>=0)
			For each ($entity; ds:C1482[$dataclass].query("descriptionWP = Null"))
				If ($entity.descriptionWP=Null:C1517)
					//$entity.descriptionWP:=New object
					$entity.descriptionWP:=WP New:C1317()
					
				End if 
				
				If ($entity.touched())
					$info:=$entity.save()
				End if 
				
			End for each 
		End if 
	End for each 
	
	
exposed Function initAddressIfDoesntExist()
	
	For each ($dataclass; ds:C1482)
		
		If (OB Keys:C1719(ds:C1482[$dataclass]).indexOf("contactDetails")>=0)
			For each ($entity; ds:C1482[$dataclass].query("contactDetails = Null OR contactDetails.addresses=Null"))
				If ($entity.contactDetails=Null:C1517)
					$entity.contactDetails:=New object:C1471
				End if 
				If ($entity.contactDetails.addresses=Null:C1517)
					$entity.contactDetails.addresses:=New collection:C1472
				End if 
				If ($entity.contactDetails.communications=Null:C1517)
					$entity.contactDetails.communications:=New collection:C1472
				End if 
				
				$mainAddress:=$entity.contactDetails.addresses.query("type = :1"; "main").first()
				If ($mainAddress=Null:C1517)
					$mainAddress:=New object:C1471
					$mainAddress.type:="main"
					$mainAddress.detail:=New object:C1471
					$mainAddress.detail.country:=cs:C1710.sfw_definition.me.globalParameters.address.defaultCountry
					$entity.contactDetails.addresses.push($mainAddress)
					$entity.contactDetails:=$entity.contactDetails
				End if 
				
				If ($entity.touched())
					$info:=$entity.save()
				End if 
				
			End for each 
		End if 
	End for each 
	
	
	//exposed Function initContractSow()
	//var $consumption : cs.ConsumptionEntity
	//var $contract : cs.ContractEntity
	
	//For each ($contract; ds.Contract.query("sowHours = 0"))
	//$contract.sowDays:=$contract.consumptions.sum("sowDays")
	//$contract.sowHours:=$contract.sowDays*7
	//$contract.budget:=$contract.consumptions.sum("budget")
	
	//$info:=$contract.save()
	//End for each 
	
	//For each ($consumption; ds.Consumption.query("sowHours = 0"))
	//$consumption.sowHours:=$consumption.sowDays*7
	//$info:=$consumption.save()
	//End for each 
	
	
	//Mark:-
	//Function duplicatePhasesLotsTasksForProjectOrTemplate($originalUUID : Text; $newUUID : Text; $originalAttribute : Text; $newAtribute : Text)
	
	//For each ($ePhase; ds.Phase.query($originalAttribute+" = :1"; $originalUUID))
	//$eNewPhase:=ds.Phase.new()
	//For each ($attributeName; ds.Phase)
	//$attribute:=ds.Phase[$attributeName]
	//If ($attribute.kind="storage")
	//$eNewPhase[$originalAttribute]:=""
	//Case of 
	//: ($attributeName="UUID") & ($attribute.type="string")
	//$eNewPhase[$attributeName]:=Generate UUID
	//: ($attributeName=$newAtribute) & ($attribute.type="string")
	//$eNewPhase[$newAtribute]:=$newUUID
	//Else 
	//$eNewPhase[$attributeName]:=$ePhase[$attributeName]
	//End case 
	//End if 
	//End for each 
	//$info:=$eNewPhase.save()
	//$replacementUUIDS:=New collection
	//For each ($eLot; ds.Lot.query("UUID_Phase = :1"; $ePhase.UUID))
	//$eNewLot:=ds.Lot.new()
	//For each ($attributeName; ds.Lot)
	//$attribute:=ds.Lot[$attributeName]
	//If ($attribute.kind="storage")
	//Case of 
	//: ($attributeName="UUID") & ($attribute.type="string")
	//$eNewLot[$attributeName]:=Generate UUID
	//$replacementUUIDS.push({old: $eLot.UUID; new: $eNewLot.UUID})
	//: ($attributeName="UUID_Phase") & ($attribute.type="string")
	//$eNewLot[$attributeName]:=$eNewPhase.UUID
	//Else 
	//$eNewLot[$attributeName]:=$eLot[$attributeName]
	//End case 
	//End if 
	//End for each 
	//$info:=$eNewLot.save()
	
	//For each ($eTask; ds.Task.query("UUID_Lot = :1"; $eLot.UUID))
	//$eNewTask:=ds.Task.new()
	//For each ($attributeName; ds.Task)
	//$attribute:=ds.Task[$attributeName]
	//If ($attribute.kind="storage")
	//Case of 
	//: ($attributeName="UUID") & ($attribute.type="string")
	//$eNewTask[$attributeName]:=Generate UUID
	//: ($attributeName="UUID_Lot") & ($attribute.type="string")
	//$eNewTask[$attributeName]:=$eNewLot.UUID
	//Else 
	//$eNewTask[$attributeName]:=$eTask[$attributeName]
	//End case 
	//End if 
	//End for each 
	//$info:=$eNewTask.save()
	
	//End for each 
	
	//End for each 
	
	//For each ($replacementUUID; $replacementUUIDS)
	//For each ($eNewLot; ds.Lot.query("UUID_Phase = :1 and UUID_parentLot = :2"; $eNewPhase.UUID; $replacementUUID.old))
	//$eNewLot.UUID_parentLot:=$replacementUUID.new
	//$info:=$eNewLot.save()
	//End for each 
	//End for each 
	
	
	//End for each 
	
	