Class extends EntitySelection


Function projectionToTaskTimes()->$esTasks : cs:C1710.TaskSelection
	
	$esTasks:=This:C1470.affectations.taskTimes
	
	
	
	
Function getCollectionToDisplayInWizard($queryParts : Collection; $querySettings : Object; $calculatedLinks : Collection)->$tasks : Collection
	var $labelParts : Collection
	
	If ($queryParts.length#0)
		$queryString:=$queryParts.join(" and ")+" order by "+$calculatedLinks.join(", ")
		$esTasks:=This:C1470.query($queryString; $querySettings)
	Else 
		$esTasks:=This:C1470.orderBy($calculatedLinks.join(", "))
	End if 
	$tasks:=New collection:C1472
	For each ($eTask; $esTasks)
		$task:=New object:C1471()
		$task.UUID:=$eTask.UUID
		$labelParts:=New collection:C1472
		For each ($calculatedLink; $calculatedLinks)
			$labelParts.push($eTask[$calculatedLink])
		End for each 
		$task.label:=$labelParts.join(" - ")
		$tasks.push($task)
	End for each 