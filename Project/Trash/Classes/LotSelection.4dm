Class extends EntitySelection


Function getCollectionToDisplayInWizard($queryParts : Collection; $querySettings : Object; $calculatedLinks : Collection)->$lots : Collection
	var $labelParts : Collection
	
	If ($queryParts.length#0)
		$queryString:=$queryParts.join(" and ")+" order by "+$calculatedLinks.join(", ")
		$esLots:=This:C1470.query($queryString; $querySettings)
	Else 
		$esLots:=This:C1470.orderBy($calculatedLinks.join(", "))
	End if 
	$lots:=New collection:C1472
	For each ($eLot; $esLots)
		$lot:=New object:C1471()
		$lot.UUID:=$eLot.UUID
		$labelParts:=New collection:C1472
		For each ($calculatedLink; $calculatedLinks)
			$labelParts.push($eLot[$calculatedLink])
		End for each 
		$lot.label:=$labelParts.join(" - ")
		$lots.push($lot)
	End for each 