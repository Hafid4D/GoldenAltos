Class extends Entity

// MARK: -nameInWizard

Function get companyNameInWizard()->$name : Text
	$name:=This:C1470.project.company.nameInWizard
	
Function get customerNameInWizard()->$name : Text
	$name:=This:C1470.project.customer.nameInWizard
	
Function get projectNameInWizard()->$name : Text
	$name:=This:C1470.project.nameInWizard
	
local Function get nameInWizard()->$name : Text
	
	$name:="📓 "+This:C1470.name
	
Function getDescendantsLots()->$esDescendants : cs:C1710.LotSelection
	
	
	var $this : cs:C1710.LotEntity
	$esDescendants:=This:C1470.lots
	
	
	$i:=-1
	For each ($lot; This:C1470.lots)
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
		
	End for each 