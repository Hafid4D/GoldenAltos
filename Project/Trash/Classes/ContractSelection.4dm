Class extends EntitySelection


Function getCollectionToDisplayInWizard($queryParts : Collection; $querySettings : Object; $calculatedLinks : Collection)->$contracts : Collection
	var $labelParts : Collection
	
	If ($queryParts.length#0)
		$queryString:=$queryParts.join(" and ")+" order by "+$calculatedLinks.join(", ")
		$esContracts:=This:C1470.query($queryString; $querySettings)
	Else 
		$esContracts:=This:C1470.orderBy($calculatedLinks.join(", "))
	End if 
	$contracts:=New collection:C1472
	For each ($eContract; $esContracts)
		$contract:=New object:C1471()
		$contract.UUID:=$eContract.UUID
		$labelParts:=New collection:C1472
		For each ($calculatedLink; $calculatedLinks)
			$labelParts.push($eContract[$calculatedLink])
		End for each 
		$contract.label:=$labelParts.join(" - ")
		$contracts.push($contract)
	End for each 