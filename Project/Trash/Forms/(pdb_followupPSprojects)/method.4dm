Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		Form:C1466.followup_file:=cs:C1710.Followup_file.new()
		Form:C1466.months:=New object:C1471("values"; Form:C1466.followup_file.months; "index"; 0; "currentValue"; Form:C1466.followup_file.months[0])
		Form:C1466.years:=New object:C1471("values"; Form:C1466.followup_file.years; "index"; 1; "currentValue"; 2024)
		
	: (FORM Event:C1606.code=On Bound Variable Change:K2:52)
		Form:C1466.followup_file.build(Form:C1466.current_item.name)
		
		
End case 

OBJECT GET SUBFORM CONTAINER SIZE:C1148($width; $height)
OBJECT GET COORDINATES:C663(*; "ViewProArea"; $g; $h; $d; $b)
OBJECT SET COORDINATES:C1248(*; "ViewProArea"; $g; $h; $width; $height)
OBJECT SET ENABLED:C1123(*; "closing"; Form:C1466.current_item.name="Follow up PS Projects")
