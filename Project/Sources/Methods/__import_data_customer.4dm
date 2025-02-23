//%attributes = {}
var $eCustomer : cs:C1710.CustomerEntity
var $eCustomerStatus : cs:C1710.CustomerStatusEntity
var $eContact : cs:C1710.ContactEntity

$customer_Log:=Folder:C1567(fk data folder:K87:12).file("DataJson/Customer_Log.json")
If ($customer_Log.exists)
	$customers:=JSON Parse:C1218($customer_Log.getText())
	TRUNCATE TABLE:C1051([Contact:1])
	TRUNCATE TABLE:C1051([Customer:114])
	TRUNCATE TABLE:C1051([CustomerStatus:130])
	
	
	$eCustomerStatus:=ds:C1482.CustomerStatus.new()
	$eCustomerStatus.statusID:=1
	$eCustomerStatus.name:="Active"
	$eCustomerStatus.color:=""
	$eCustomerStatus.save()
	
	$eCustomerStatus:=ds:C1482.CustomerStatus.new()
	$eCustomerStatus.statusID:=2
	$eCustomerStatus.name:="Hold"
	$eCustomerStatus.color:=""
	$eCustomerStatus.save()
	
	$eCustomerStatus:=ds:C1482.CustomerStatus.new()
	$eCustomerStatus.statusID:=3
	$eCustomerStatus.name:="Retired"
	$eCustomerStatus.color:=""
	$eCustomerStatus.save()
	
	$eCustomerStatus:=ds:C1482.CustomerStatus.new()
	$eCustomerStatus.statusID:=4
	$eCustomerStatus.name:="Void"
	$eCustomerStatus.color:=""
	$eCustomerStatus.save()
	
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
		$address.detail.country:="US"
		$address.detail.street_1:=$customer.Bill_Address1
		If (String:C10($customer.Bill_Address2)#"")
			$address.detail.street_2:=$customer.Bill_Address2
		End if 
		$address.detail.postcode:=$customer.Bill_addr_zip
		$address.detail.iso_code_2:="US"
		$address.detail.city:=$customer.Bill_add_city
		$eCustomer.contactDetails.addresses.push($address)
		
		
		$address:=New object:C1471()
		$address.type:="shipping"
		$address.detail:=New object:C1471()
		$address.detail.country:="US"
		$address.detail.street_1:=$customer.Ship_Address1
		If (String:C10($customer.Ship_Address2)#"")
			$address.detail.street_2:=$customer.Ship_Address2
		End if 
		$address.detail.postcode:=$customer.Ship_Addr_zip
		$address.detail.city:=$customer.Ship_addr_city
		$address.detail.iso_code_2:="US"
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
	
	$contacts_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/contacts.json")
	If ($contacts_file.exists)
		$contacts:=JSON Parse:C1218($contacts_file.getText())
		For each ($contact; $contacts)
			$eContact:=ds:C1482.Contact.new()
			$eContact.firstName:=$contact.FirstName
			$eContact.lastName:=$contact.LastName
			$eContact.code:=$contact.Contactcode
			$eContact.title:=$contact.Title
			
			$eContact.contactDetails:=New object:C1471()
			$eContact.contactDetails.addresses:=New collection:C1472()
			$address:=New object:C1471()
			$address.type:="main"
			$address.detail:=New object:C1471()
			$address.detail.country:="US"
			$address.detail.street_1:=$contact.CtAddress1
			If (String:C10($contact.CtAddress2)#"")
				$address.detail.street_2:=$contact.CtAddress2
			End if 
			$address.detail.postcode:=$contact.CtZip
			$address.detail.iso_code_2:="US"
			$address.detail.city:=$contact.CtCity
			$address.detail.state:=$contact.CtState
			$eContact.contactDetails.addresses.push($address)
			
			
			$eContact.contactDetails.communications:=New collection:C1472()
			$comm:=New object:C1471()
			$comm.phone:=$contact.Tel
			$comm.fax:=$contact.Fax
			$comm.mobile:=$contact.MobileNum
			$comm.email:=$contact.Email_address
			$eContact.contactDetails.communications.push($comm)
			
			$eCustomer:=ds:C1482.Customer.query("name == :1"; $contact.Company_Name).first()
			If ($eCustomer=Null:C1517)
				$eCustomer:=ds:C1482.Customer.new()
				$eCustomer.name:=$contact.Company_Name
				$eCustomer.save()
			End if 
			$eContact.UUID_Customer:=$eCustomer.UUID
			
			$result:=$eContact.save()
			If ($result.success=False:C215)
				TRACE:C157
			End if 
		End for each 
	Else 
		TRACE:C157
	End if 
	
	ALERT:C41("Import done.")
End if 