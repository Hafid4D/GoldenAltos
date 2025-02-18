Class extends DataClass


Function getUUIDsWithAppointmentToday()->$coll : Collection
	$stmpFrom:=cs:C1710.sfw_stmp.me.build(Current date:C33; ?00:00:00?)
	$stmpTo:=$stmpFrom+86400
	$coll:=ds:C1482.Appointment.query("startStmp >= :1 & startStmp < :2"; $stmpFrom; $stmpTo).person.UUID
	
	
Function bornAfter2000()->$entitySelection : cs:C1710.PersonSelection
	
	$entitySelection:=This:C1470.query("birthdate >= :1"; !2000-01-01!)
	
	
Function bornAfter($year)->$entitySelection : cs:C1710.PersonSelection
	$date:=Add to date:C393(!00-00-00!; $year; 1; 1)
	$entitySelection:=This:C1470.query("birthdate >= :1"; $date)
	
	
	
	
	
	
	
	
local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("customerHWMH"; "customerHWMH"; "Customers")
	$entry.setXliffLabel("entry.customers")
	$entry.setDataclass("Person")
	$entry.setDisplayOrder(100)
	$entry.setIcon("image/entry/customers-50x50.png")
	
	$entry.setSearchboxField("firstName")
	$entry.setSearchboxField("lastName")
	$entry.setSearchboxField("contactDetails.addresses[].detail.city"; "placeholder:city")
	$entry.setSearchboxSpecific("withAppointment"; "queryString:appointments # null")
	$entry.setSearchboxSpecific("withoutAppointment"; "queryString:appointments = null")
	$entry.setSearchboxSpecific("withLessons"; "queryString:privateLessons # null")
	$entry.setSearchboxSpecific("withLessons2"; "queryString:privateLessons # null and idStatus = 0")
	$entry.setSearchboxSpecific("withoutLessons"; "queryString:privateLessons = null")
	$entry.setSearchboxSpecific("appointmentToday"; "formula:Person_appointment_today")
	$entry.setSearchboxSpecific("appointmentTodayInColl"; "collectionBuilder:collPerson:=Person_appointment_today_coll"; "inCollection:UUID in :collPerson")
	
	$entry.setPanel("panel_person"; 2)
	$entry.setPanelPage(2; "appointments-32x32.png")
	$entry.setPanelPage(1; "address-32x32.png")
	
	$entry.setLBItemsColumn("firstName"; "First Name"; "xliff:entry.customer.field.firstName"; "headerLeft"; "headerStroke:midnightblue")
	$entry.setLBItemsColumn("lastName"; "Last Name"; "xliff:entry.customer.field.lastName"; "headerLeft"; "headerStroke:midnightblue")
	$entry.setLBItemsColumn("contactDetails.addresses[0].detail.city"; "City"; "xliff:address.city"; "orderByFormula:this.contactDetails.addresses[0].detail.city"; "headerLeft"; "headerStroke:midnightblue"; "group:city")
	$entry.setLBItemsColumn("contactDetails.addresses[0].detail.country"; "Country"; "xliff:address.country"; "orderByFormula:this.contactDetails.addresses[0].detail.country"; "headerLeft"; "headerStroke:midnightblue"; "group:city")
	$entry.setLBItemsOrderBy("lastName")
	$entry.setLBItemsOrderBy("firstName")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:person"; "unitN:people"; "unit1xliff:entry.customer.unit1"; "unitNxliff:entry.customer.unitN")
	$entry.setMainViewLabel("All customers")
	
	$entry.setAddable()
	$entry.setItemAction("alert"; "Customer_alertAction")
	
	$view:=cs:C1710.sfw_definitionView.new("bornAfter2000"; "Born after 2000")
	$view.setLBItemsColumn("lastName"; "Last Name"; "xliff:entry.customer.field.lastName"; "headerLeft"; "headerStroke:midnightblue")
	$view.setLBItemsColumn("firstName"; "First Name"; "xliff:entry.customer.field.firstName"; "headerLeft"; "headerStroke:midnightblue")
	$view.setLBItemsColumn("birthdate"; "Birthdate"; "headerLeft"; "headerStroke:midnightblue"; "group:bithdate")
	$view.setLBItemsColumn("age"; "Age"; "headerLeft"; "headerStroke:midnightblue"; "group:bithdate"; "format:##0 years")
	$view.setLBItemsOrderBy("lastName")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:young"; "unitN:youngs")
	$view.setSubset("bornAfter2000")
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("bornAfter2010"; "Born after 2010")
	$view.setLBItemsColumn("lastName"; "Last Name"; "xliff:entry.customer.field.lastName"; "headerLeft"; "headerStroke:midnightblue")
	$view.setLBItemsColumn("firstName"; "First Name"; "xliff:entry.customer.field.firstName"; "headerLeft"; "headerStroke:midnightblue")
	$view.setLBItemsColumn("birthdate"; "Birthdate"; "headerLeft"; "headerStroke:midnightblue"; "group:bithdate")
	$view.setLBItemsColumn("age"; "Age"; "headerLeft"; "headerStroke:midnightblue"; "group:bithdate")
	$view.setLBItemsOrderBy("lastName")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:kid"; "unitN:kids")
	$view.setSubset("bornAfter"; 2010)
	$entry.setView($view)
	
	$view:=cs:C1710.sfw_definitionView.new("customerByCity"; "Customers by city")
	$view.setDisplayType("hierarchical")
	$view.setPictoLabel("/RESOURCES/sfw/image/picto/hierarchical.png")
	$view.setHLItemsFirstLevelGroupBy("contactDetails.addresses[].detail.city")
	$view.setHLItemsLine("fullName")
	
	$entry.setView($view)
	
	$entry.activateComment()
	$entry.enableTransaction()
	
	