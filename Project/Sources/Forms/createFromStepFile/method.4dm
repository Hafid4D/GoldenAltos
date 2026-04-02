Case of 
	: (FORM Event:C1606.code=On Load:K2:1)
		OBJECT SET VISIBLE:C603(*; "sf_customerSearch"; False:C215)
		OBJECT SET VISIBLE:C603(*; "sf_stepFileSearch"; False:C215)
		Form:C1466.searchCustomer:=Form:C1466.lotInfo.customer.name
		Form:C1466.mode:="replace"
		OBJECT SET VALUE:C1742("replace"; 1)
End case 