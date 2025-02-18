Class extends Entity

// MARK: -nameInWizard

Function get companyNameInWizard()->$name : Text
	$name:=This:C1470.phase.project.company.nameInWizard
	
Function get customerNameInWizard()->$name : Text
	$name:=This:C1470.phase.project.customer.nameInWizard
	
Function get projectNameInWizard()->$name : Text
	$name:=This:C1470.phase.project.nameInWizard
	
Function get phaseNameInWizard()->$name : Text
	$name:=This:C1470.phase.nameInWizard
	
Function get nameInWizard()->$name : Text
	var $eLot : cs:C1710.LotEntity
	
	$name:=""
	$eLot:=This:C1470
	$parts:=New collection:C1472
	Repeat 
		$parts.unshift($eLot.name)
		$eLot:=$eLot.parentLot
	Until ($eLot=Null:C1517)
	$name:="🗂️ "+$parts.join(" / ")
	
	//mark:-
	
Function getDescendants()->$esDescendants : cs:C1710.LotSelection
	var $this : cs:C1710.LotEntity
	$esDescendants:=ds:C1482.Lot.newSelection()
	
	$i:=-1
	$this:=This:C1470
	Repeat 
		If ($this.subLots.length>0)
			$esDescendants:=$esDescendants.add($this.subLots)
		End if 
		$i+=1
		If ($i<$esDescendants.length)
			$this:=$esDescendants[$i]
		Else 
			$this:=Null:C1517
		End if 
	Until ($this=Null:C1517)
	
	