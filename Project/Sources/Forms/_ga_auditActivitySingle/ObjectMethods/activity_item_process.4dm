var $isInModification : Boolean


$processTypes:=New collection:C1472("Assembly"; "Assembly_AE"; "Assembly_AO"; "Assembly_AP"; "Assembly_D"; "Assembly_E"; "Assembly_M"; \
"Assembly_O"; "Assembly_W"; "Burn-In"; "Environmental"; "Environmental_B1"; "Environmental_B1, B2, B3"; "Environmental_B2"; \
"Environmental_B3"; "Environmental_B4"; "Environmental_B5"; "Environmental_B6"; "Environmental_B7"; "Environmental_B8"; \
"Environmental_C1"; "Environmental_C2"; "Environmental_C3"; "Environmental_C4"; "Environmental_D1"; "Environmental_D1, D4"; \
"Environmental_D2"; "Environmental_D3"; "Environmental_D4"; "Environmental_D5"; "Environmental_D6"; "Environmental_D7"; \
"Environmental_D8"; "Environmental_D9"; "Program Management")


$menu:=Create menu:C408

For each ($process; $processTypes)
	APPEND MENU ITEM:C411($menu; $process; *)
	SET MENU ITEM PARAMETER:C1004($menu; -1; $process)
	If ($process=Form:C1466.process)
		SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
	End if 
End for each 


$choose:=Dynamic pop up menu:C1006($menu)
RELEASE MENU:C978($menu)

Case of 
	: ($choose="")
		
	Else 
		Form:C1466.process:=$choose
		
End case 


OBJECT SET FORMAT:C236(*; "activity_item_process"; Form:C1466.process+";0;3;1;1;8;0;0;0;1;0;1")