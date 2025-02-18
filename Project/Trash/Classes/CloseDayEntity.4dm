Class extends Entity


local Function get type()->$label : Text
	
	Case of 
		: (This:C1470.typeID=1)
			$label:="French closing day"
		: (This:C1470.typeID=2)
			$label:="US closing day"
		: (This:C1470.typeID=3)
			$label:="Moroccan closing day"
		: (This:C1470.typeID=4)
			$label:="Germany closing day"
		: (This:C1470.typeID=5)
			$label:="Japan closing day"
		: (This:C1470.typeID=6)
			$label:="Autralia closing day"
	End case 