Class extends Entity


local Function get invoiceDate()->$invoiceDate : Date
	$invoiceDate:=This:C1470.invoiceStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.invoiceStmp; True:C214)
	
local Function set invoiceDate($invoiceDate : Date)
	This:C1470.invoiceStmp:=$invoiceDate=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($invoiceDate)
	
	