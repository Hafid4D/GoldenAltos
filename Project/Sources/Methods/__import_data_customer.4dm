//%attributes = {}

If (True:C214)
	
	var $eCustomer : cs:C1710.CustomerEntity
	var $eCustomerStatus : cs:C1710.CustomerStatusEntity
	//var $eContact : cs.ContactEntity
	var $carriers; $status : Collection
	$carriers:=New collection:C1472("GAC Driver"; "Fed-Ex Priority"; "fedex Std Overnight"; "fedex"; "fedex Ground"; "Customer Pickup"; "UPS 2nd Day"; "UPS Ground"; "UPS Next Day"; "DHL")
	$status:=New collection:C1472("Active"; "Hold"; "Retired"; "Void")
	
	$customer_Log:=Folder:C1567(fk data folder:K87:12).file("DataJson/Customer_Log.json")
	If ($customer_Log.exists)
		$customers:=JSON Parse:C1218($customer_Log.getText())
		TRUNCATE TABLE:C1051([Contact:1])
		TRUNCATE TABLE:C1051([Customer:114])
		TRUNCATE TABLE:C1051([CustomerStatus:130])
		TRUNCATE TABLE:C1051([CustomerCarrier:7])
		
		//----> [CustomerStatus]
		For ($i; 0; $status.length-1)
			
			$eCustomerStatus:=ds:C1482.CustomerStatus.new()
			$eCustomerStatus.statusID:=$i+1
			$eCustomerStatus.name:=$status[$i]
			$eCustomerStatus.color:=""
			$eCustomerStatus.save()
			
		End for 
		
		//----> [CustomerCarrier]
		For ($i; 0; $carriers.length-1)
			
			$eCustomerCarrier:=ds:C1482.CustomerCarrier.new()
			$eCustomerCarrier.carrierID:=$i+1
			$eCustomerCarrier.name:=$carriers[$i]
			$eCustomerCarrier.color:=""
			$eCustomerCarrier.save()
		End for 
		
		//----> [Customer]
		For each ($customer; $customers)
			$eCustomer:=ds:C1482.Customer.new()
			$eCustomer.name:=$customer.Customer
			$eCustomer.code:=$customer.Cust_Code
			$eCustomer.IDT_status:=$customer.idt_status
			
			//-----------------------------------------------------------
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
			
			//AP Contacts -> TODO : TO BE REMOVED LATER
			$comm:=New object:C1471()
			$comm.type:="AP Contact"
			$comm.detail:=New object:C1471()
			$comm.detail.email:=$customer.AP_email
			$comm.detail.phone:=$customer.AP_tel
			$comm.detail.fax:=$customer.AP_fax
			$comm.detail.mobile:=""
			$comm.detail.email_cc:=""
			
			$eCustomer.contactDetails.communications.push($comm)
			
			
			//Status Contacts -> TODO : TO BE REMOVED LATER
			$comm:=New object:C1471()
			$comm.type:="Status Contact"
			$comm.detail:=New object:C1471()
			$comm.detail.fax:=$customer.AP_fax
			$comm.detail.mobile:=""
			$comm.detail.email_cc:=""
			$comm.detail.phone:=$customer.Status_Tel
			$comm.detail.email:=$customer.StatusEmailAddresses
			
			$eCustomer.contactDetails.communications.push($comm)
			
			//Checkand assign a Carrier if needed
			$carrier:=ds:C1482.CustomerCarrier.query("name =:1"; Split string:C1554($customer.Carrier; "\r"; sk trim spaces:K86:2).join("\r"))
			
			If ($carrier.length>0)
				$eCustomer.IDT_carrier:=$carrier[0].carrierID
			Else 
				$eCustomer.IDT_carrier:=0
			End if 
			
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
		
		//----> [Contact]
		$contacts_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/contacts.json")
		If ($contacts_file.exists)
			
			//All sales and Main contactS  From Contact_log table in the older database
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
				$comm.type:="phone"
				$comm.comment:=""
				$comm.phone:=$contact.Tel
				$eContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="fax"
				$comm.comment:=""
				$comm.fax:=$contact.Fax
				$eContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="mobile"
				$comm.comment:=""
				$comm.mobile:=$contact.MobileNum
				$eContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="mail"
				$comm.comment:=""
				$comm.email:=$contact.Email_address
				$eContact.contactDetails.communications.push($comm)
				
				$eCustomer:=ds:C1482.Customer.query("name = :1"; $contact.Company_Name).first()
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
			
			//AP and Status Contact
			For each ($customer; $customers)
				
				$eCustomer:=ds:C1482.Customer.query("name = :1"; $customer.Customer).first()
				
				//AP Contact
				$cContact:=ds:C1482.Contact.new()
				$cContact.title:="AP"
				$cContact.UUID_Customer:=$eCustomer.UUID
				$cContact.firstName:=$customer.AP_contact_fn
				$cContact.lastName:=$customer.AP_contact_ln
				$cContact.contactDetails:=New object:C1471()
				$cContact.contactDetails.addresses:=New collection:C1472()
				
				$cContact.contactDetails.communications:=New collection:C1472()
				
				$comm:=New object:C1471()
				$comm.type:="mail"
				$comm.comment:=""
				$comm.contact:=$customer.AP_email
				$cContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="phone"
				$comm.comment:=""
				$comm.contact:=$customer.AP_tel
				$cContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="fax"
				$comm.comment:=""
				$comm.contact:=$customer.AP_fax
				$cContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="mobile"
				$comm.contact:=""
				$comm.comment:=""
				$cContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="mail"
				$comm.contact:=""
				$comm.comment:="CC Email"
				$cContact.contactDetails.communications.push($comm)
				
				$result:=$cContact.save()
				If ($result.success=False:C215)
					TRACE:C157
				End if 
				
				//Status Contact
				$cContact:=ds:C1482.Contact.new()
				$cContact.title:="Status"
				$cContact.UUID_Customer:=$eCustomer.UUID
				$cContact.firstName:=$customer.Status_Contact
				$cContact.lastName:=""
				$cContact.contactDetails:=New object:C1471()
				$cContact.contactDetails.addresses:=New collection:C1472()
				
				$cContact.contactDetails.communications:=New collection:C1472()
				
				$comm:=New object:C1471()
				$comm.type:="phone"
				$comm.contact:=$customer.Status_Tel
				$comm.comment:=""
				$cContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="fax"
				$comm.contact:=$customer.Status_fax
				$comm.comment:=""
				$cContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="mobile"
				$comm.contact:=""
				$comm.comment:=""
				$cContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="mail"
				$comm.comment:=""
				$comm.contact:=$customer.StatusEmailAddresses
				$cContact.contactDetails.communications.push($comm)
				
				$comm:=New object:C1471()
				$comm.type:="mail"
				$comm.comment:="CC Email"
				$comm.contact:=$customer.status_email_CC
				$cContact.contactDetails.communications.push($comm)
				
				$result:=$cContact.save()
				If ($result.success=False:C215)
					TRACE:C157
				End if 
				
			End for each 
			
			
		Else 
			TRACE:C157
		End if 
		
	End if 
	
	
End if 
