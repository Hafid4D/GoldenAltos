Case of 
	: (FORM Event:C1606.code=On Clicked:K2:4)
		//TODO: Replace with real quotes
		Form:C1466.sf_quotesSearch:=New object:C1471(\
			"colName"; "description"; \
			"lb_values"; Form:C1466.quoteLines\
			)
		
		OBJECT SET SUBFORM:C1138(*; "sf_quotesSearch"; "searchOnList")
		OBJECT SET VISIBLE:C603(*; "sf_quotesSearch"; True:C214)
		
	: (FORM Event:C1606.code=On Mouse Enter:K2:33)
		SET CURSOR:C469(9000)
	: (FORM Event:C1606.code=On Mouse Leave:K2:34)
		SET CURSOR:C469()
End case 