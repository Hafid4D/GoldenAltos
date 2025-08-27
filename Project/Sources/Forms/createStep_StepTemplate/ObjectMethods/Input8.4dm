Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		Form:C1466.sf_templateSearch:=New object:C1471(\
			"colName"; "name"; \
			"lb_values"; ds:C1482.StepTemplate.all().orderBy("name asc")\
			)
		
		OBJECT SET SUBFORM:C1138(*; "sf_templateSearch"; "searchOnList")
		OBJECT SET VISIBLE:C603(*; "sf_templateSearch"; True:C214)
		
	: (FORM Event:C1606.code=On Mouse Move:K2:35)
		SET CURSOR:C469(9000)
End case 