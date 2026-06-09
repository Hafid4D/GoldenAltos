//%attributes = {}
//BackgroundColor lb_assignments

If (This:C1470.certified)
	// Purpose: Highlight rows where QA granted punch-in override on an expired assignment.
	// modified by 4D/PS [2026-june-02]
	If (Bool:C1537(This:C1470.overrideExpired))
		$0:="#87CEEB"
		return 
	End if 
	$today:=Current date:C33()
	
	$date_15j:=Add to date:C393($today; 0; 0; 15)
	$date_30j:=Add to date:C393($today; 0; 0; 30)
	
	// Purpose: Row colors use calendar expiringDate (lb_assignments.expiringDate), not duration days.
	// modified by 4D/PS [2026-june-08]
	Case of 
		: (This:C1470.oneTime)
			$0:="#7befb2"  //green
			
		: ((This:C1470.expiringDate>=$today) & (This:C1470.expiringDate<=$date_15j))
			$0:="#ff7979"  //red
			
		: ((This:C1470.expiringDate>=$today) & (This:C1470.expiringDate<=$date_30j))
			$0:="#f6e58d"  //yellow
			
		: (This:C1470.expiringDate>$date_30j)
			$0:="#7befb2"  //green
			
		Else 
			$0:="transparent"
	End case 
Else 
	$0:="transparent"
End if 
