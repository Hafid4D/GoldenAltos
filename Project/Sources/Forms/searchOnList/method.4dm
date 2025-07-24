Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		Form:C1466.searchLine:=""
		Form:C1466.copy:=New object:C1471("lb_values"; Form:C1466.lb_values)
		
		OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
		
		OBJECT GET COORDINATES:C663(*; "bk_color"; $bk_left; $bk_top; $bk_right; $bk_bottom)
		OBJECT GET COORDINATES:C663(*; "header_bkgd"; $hd_left; $hd_top; $hd_right; $hd_bottom)
		OBJECT GET COORDINATES:C663(*; "lb_values"; $lb_left; $lb_top; $lb_right; $lb_bottom)
		
		OBJECT SET COORDINATES:C1248(*; "bk_color"; $bk_left; $bk_top; $bk_right; $heightSubform)
		OBJECT SET COORDINATES:C1248(*; "header_bkgd"; $hd_left; $hd_top; $hd_right; $heightSubform-1)
		OBJECT SET COORDINATES:C1248(*; "lb_values"; $lb_left; $lb_top; $lb_right; $heightSubform-2)
End case 