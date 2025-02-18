Class extends EntitySelection


Function projectionToTasks()->$esTasks : cs:C1710.TaskSelection
	
	$esTasks:=This:C1470.phases.lots.tasks
	
	
Function getCollectionToDisplayInWizard($queryParts : Collection; $querySettings : Object; $calculatedLinks : Collection)->$projects : Collection
	var $labelParts : Collection
	
	If ($queryParts.length#0)
		$queryString:=$queryParts.join(" and ")+" order by "+$calculatedLinks.join(", ")
		$esProjects:=This:C1470.query($queryString; $querySettings)
	Else 
		$esProjects:=This:C1470.orderBy($calculatedLinks.join(", "))
	End if 
	$projects:=New collection:C1472
	For each ($eProject; $esProjects)
		If ($eProject.phases#Null:C1517)
			$project:=New object:C1471()
			$project.UUID:=$eProject.UUID
			$labelParts:=New collection:C1472
			For each ($calculatedLink; $calculatedLinks)
				$labelParts.push($eProject[$calculatedLink])
			End for each 
			$project.label:=$labelParts.join(" - ")
			$projects.push($project)
		End if 
	End for each 