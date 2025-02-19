//%attributes = {}
var $eCustomer : cs:C1710.CustomerEntity

$customer_Log:=Folder:C1567(fk data folder:K87:12).file("Customer_Log.json")
If ($customer_Log.exists)
	$customers:=JSON Parse:C1218($customer_Log.getText())
	TRUNCATE TABLE:C1051([Customer:114])
	
	For each ($customer; $customers)
		$eCustomer:=ds:C1482.Customer.new()
		$eCustomer.name:=$customer.Customer
		$eCustomer.code:=$customer.Cust_Code
		$eCustomer.IDT_status:=$customer.idt_status
		
		$eCustomer.contactDetails:=New object:C1471()
		$eCustomer.contactDetails.addresses:=New collection:C1472()
		
		$address:=New object:C1471()
		$address.type:="billing"
		$address.detail:=New object:C1471()
		$address.detail.country:=$customer.BillAddressCountry
		$address.detail.street_1:=$customer.Bill_Address1
		If (String:C10($customer.Bill_Address2)#"")
			$address.detail.street_2:=$customer.Bill_Address2
		End if 
		$address.detail.postcode:=$customer.Bill_addr_zip
		$address.detail.city:=$customer.Bill_add_city
		$eCustomer.contactDetails.addresses.push($address)
		
		
		$address:=New object:C1471()
		$address.type:="shipping"
		$address.detail:=New object:C1471()
		$address.detail.country:=$customer.ShipAddressCountry
		$address.detail.street_1:=$customer.Ship_Address1
		If (String:C10($customer.Ship_Address2)#"")
			$address.detail.street_2:=$customer.Ship_Address2
		End if 
		$address.detail.postcode:=$customer.Ship_Addr_zip
		$address.detail.city:=$customer.Ship_addr_city
		$eCustomer.contactDetails.addresses.push($address)
		
		$eCustomer.contactDetails.communications:=New collection:C1472()
		$eCustomer.carrier:=$customer.Carrier
		$eCustomer.accountNum:=$customer.Account_num
		$eCustomer.resaleLicenseNumber:=$customer.resaleLicenseNumber
		$eCustomer.ftp:=New object:C1471()
		$eCustomer.ftp.domain:=$customer.FTPRepositoryDomain
		$eCustomer.ftp.user:=$customer.FTPRepositoryUser
		$eCustomer.ftp.password:=$customer.FTPRepositoryPass
		
		$result:=$eCustomer.save()
		If ($result.success=False:C215)
			TRACE:C157
		End if 
	End for each 
	
	
	ALERT:C41("Customer import done.")
End if 