
If (Num:C11(Application version:C493)<2060)  // Compatibility starting with 4D 20 R6
	$ok:=cs:C1710.sfw_dialog.me.confirm("This database should be opened with 4D20 R6\rOpen anyway? (Cancel will QUIT 4D)")
	If ($ok)
		QUIT 4D:C291
	End if 
End if 

sfw_on_startup_database("goldenAltos_definition")

