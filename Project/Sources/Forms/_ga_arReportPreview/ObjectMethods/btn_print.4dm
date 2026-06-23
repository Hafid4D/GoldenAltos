// Purpose: Print the A/R report shown in the preview dialog.
// created by 4D/PS [2026-june-08]
Case of 
	: (Form event:C1606.code=On Clicked:K2:4)
		// Purpose: Inline Write Pro print so preview dialog print works without a separate project method.
		// modified by 4D/PS [2026-june-08]
		If (Form:C1466.wp#Null:C1517)
			SET PRINT OPTION:C733(Orientation option:K47:2; 1)
			PRINT SETTINGS:C106(2)
			WP PRINT:C1343(Form:C1466.wp)
		End if
End case 
