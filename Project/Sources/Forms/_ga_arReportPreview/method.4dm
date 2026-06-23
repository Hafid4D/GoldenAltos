// Purpose: Load Write Pro report into preview area.
// created by 4D/PS [2026-june-08]
Case of 
	: (Form event:C1606.code=On Load:K2:1)
		WriteProArea:=WP New:C1317(Form:C1466.wp)
		OBJECT SET TITLE:C194(*; "title"; Form:C1466.title)
End case 
