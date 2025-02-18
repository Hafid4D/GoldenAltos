Class extends EntitySelection


Function getCollectionToDisplayInWizard($queryParts : Collection; $querySettings : Object; $calculatedLinks : Collection)->$phases : Collection
	var $labelParts : Collection
	
	If ($queryParts.length#0)
		$queryString:=$queryParts.join(" and ")+" order by "+$calculatedLinks.join(", ")
		$esPhases:=This:C1470.query($queryString; $querySettings)
	Else 
		$esPhases:=This:C1470.orderBy($calculatedLinks.join(", "))
	End if 
	$phases:=New collection:C1472
	For each ($ePhase; $esPhases)
		$phase:=New object:C1471()
		$phase.UUID:=$ePhase.UUID
		$labelParts:=New collection:C1472
		For each ($calculatedLink; $calculatedLinks)
			$labelParts.push($ePhase[$calculatedLink])
		End for each 
		$phase.label:=$labelParts.join(" - ")
		$phases.push($phase)
	End for each 