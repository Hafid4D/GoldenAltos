Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("bankHoliday"; "administration"; "Bank holidays")
	$entry.setDataclass("BankHoliday")
	$entry.setDisplayOrder(-6500)
	$entry.setIcon("image/entry/holidays-50x50.png")
	$entry.setSearchboxField("name")
	$entry.setSearchboxField("dateOff")
	$entry.setSearchboxField("company.country.name"; "placeholder:countryName")
	
	
	$entry.setPanel("panel_bankHoliday"; 2)
	$entry.setLBItemsColumn("dateOff"; "Date off"; "type:date"; "format:"+String:C10(Internal date short:K1:7))
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsColumn("company.name"; "Company"; "type:picture"; "width:100"; "orderByFormula:this.company.name")
	
	$entry.setLBItemsOrderBy("dateOff DESC, name")
	
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:holiday"; "unitN:holidays")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	$entry.enableTransaction()
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	$entry.setToolBarGroup("Holidays"; "Holidays"; "sfw/entry/THoliday-50x50.png")
	
	//MARK:-French
	
Function generateFrenchBankHolidays($year : Integer; $uuidCompany : Text)
	var $eBankHoliday : cs:C1710.BankHolidayEntity
	
	// jours fixes
	$bankHolidays:=New collection:C1472
	$bankHolidays.push({name: "Jour de l'an"; type: 1; date: Add to date:C393(!00-00-00!; $year; 1; 1)})
	$bankHolidays.push({name: "Fête du travail"; type: 1; date: Add to date:C393(!00-00-00!; $year; 5; 1)})
	$bankHolidays.push({name: "Victoire 1945"; type: 1; date: Add to date:C393(!00-00-00!; $year; 5; 8)})
	$bankHolidays.push({name: "Fête nationale"; type: 1; date: Add to date:C393(!00-00-00!; $year; 7; 14)})
	$bankHolidays.push({name: "Assomption"; type: 1; date: Add to date:C393(!00-00-00!; $year; 8; 15)})
	$bankHolidays.push({name: "Toussaint"; type: 1; date: Add to date:C393(!00-00-00!; $year; 11; 1)})
	$bankHolidays.push({name: "Armistice 1918"; type: 1; date: Add to date:C393(!00-00-00!; $year; 11; 11)})
	$bankHolidays.push({name: "Jour de Noël"; type: 1; date: Add to date:C393(!00-00-00!; $year; 12; 25)})
	
	// jours qui dépendent de Pâques
	$easter:=cs:C1710.sfw_stmp.me.getEaster($year)
	$bankHolidays.push({name: "Lundi de Pâques"; type: 1; date: $easter+1})  // Lundi de Pâques
	$bankHolidays.push({name: "Jeudi de l'Ascension"; type: 1; date: $easter+39})  // Jeudi de l'Ascension
	$bankHolidays.push({name: "Lundi de Pentecôte"; type: 1; date: $easter+50})  // Lundi de Pentecôte
	
	For each ($bankHoliday; $bankHolidays)
		
		$eBankHoliday:=ds:C1482.BankHoliday.query("UUID_Company = :1 AND dateOff = :2"; $uuidCompany; $bankHoliday.date).first()
		If ($eBankHoliday=Null:C1517)
			$eBankHoliday:=ds:C1482.BankHoliday.new()
			$eBankHoliday.dateOff:=$bankHoliday.date
			$eBankHoliday.UUID_Company:=$uuidCompany
			$eBankHoliday.typeID:=$bankHoliday.type
		End if 
		$eBankHoliday.name:=$bankHoliday.name
		
		$info:=$eBankHoliday.save()
		//End if 
	End for each 
	
	//MARK:-US
	
Function generateUSBankHolidays($year : Integer; $uuidCompany : Text)
	var $eBankHoliday : cs:C1710.BankHolidayEntity
	
	// Jours fixes
	$bankHolidays:=New collection:C1472
	$bankHolidays.push({name: "New Year's Day"; type: 2; date: Add to date:C393(!00-00-00!; $year; 1; 1)})
	$bankHolidays.push({name: "Inauguration Day"; type: 2; date: Add to date:C393(!00-00-00!; $year; 1; 20)})
	$bankHolidays.push({name: "Juneteenth National Independence Day"; type: 2; date: Add to date:C393(!00-00-00!; $year; 6; 19)})
	$bankHolidays.push({name: "Independence Day"; type: 2; date: Add to date:C393(!00-00-00!; $year; 7; 4)})
	$bankHolidays.push({name: "Veterans Day"; type: 2; date: Add to date:C393(!00-00-00!; $year; 11; 11)})
	$bankHolidays.push({name: "Christmas Day"; type: 2; date: Add to date:C393(!00-00-00!; $year; 12; 25)})
	
	// Jours variables
	$bankHolidays.push({name: "Martin Luther King Jr. Day"; type: 2; date: cs:C1710.sfw_stmp.me.getNthWeekday($year; 1; 3; 2)})  // 3ème lundi de janvier
	$bankHolidays.push({name: "Presidents' Day"; type: 2; date: cs:C1710.sfw_stmp.me.getNthWeekday($year; 2; 3; 2)})  // 3ème lundi de février
	$bankHolidays.push({name: "Memorial Day"; type: 2; date: cs:C1710.sfw_stmp.me.getLastWeekday($year; 5; 2)})  // Dernier lundi de mai
	$bankHolidays.push({name: "Labor Day"; type: 2; date: cs:C1710.sfw_stmp.me.getNthWeekday($year; 9; 1; 2)})  // 1er lundi de septembre
	$bankHolidays.push({name: "Columbus Day"; type: 2; date: cs:C1710.sfw_stmp.me.getNthWeekday($year; 10; 2; 2)})  // 2ème lundi d'octobre
	$bankHolidays.push({name: "Thanksgiving Day"; type: 2; date: cs:C1710.sfw_stmp.me.getNthWeekday($year; 11; 4; 5)})  // 4ème jeudi de novembre
	
	For each ($bankHoliday; $bankHolidays)
		$eBankHoliday:=ds:C1482.BankHoliday.query("UUID_Company = :1 AND dateOff = :2"; $uuidCompany; $bankHoliday.date).first()
		If ($eBankHoliday=Null:C1517)
			$eBankHoliday:=ds:C1482.BankHoliday.new()
			$eBankHoliday.dateOff:=$bankHoliday.date
			$eBankHoliday.UUID_Company:=$uuidCompany
			$eBankHoliday.typeID:=$bankHoliday.type
		End if 
		$eBankHoliday.name:=$bankHoliday.name
		
		$info:=$eBankHoliday.save()
	End for each 
	
	
	
	//MARK:-Morocco 
	
Function generateMoroccoBankHolidays($year : Integer; $uuidCompany : Text)
	var $eBankHoliday : cs:C1710.BankHolidayEntity
	
	// jours fixes
	$bankHolidays:=New collection:C1472
	$bankHolidays.push({name: "Jour de l'an"; type: 3; date: Add to date:C393(!00-00-00!; $year; 1; 1)})
	$bankHolidays.push({name: "Fête de l'indépendance"; type: 3; date: Add to date:C393(!00-00-00!; $year; 1; 11)})
	$bankHolidays.push({name: "Nouvel An Amazigh"; type: 3; date: Add to date:C393(!00-00-00!; $year; 1; 14)})
	$bankHolidays.push({name: "Fête du Travail"; type: 3; date: Add to date:C393(!00-00-00!; $year; 5; 1)})
	$bankHolidays.push({name: "Fête du Trône"; type: 3; date: Add to date:C393(!00-00-00!; $year; 7; 30)})
	$bankHolidays.push({name: "Journée d'Oued Ed-Dahab"; type: 3; date: Add to date:C393(!00-00-00!; $year; 8; 14)})
	$bankHolidays.push({name: "Journée de la Révolution"; type: 3; date: Add to date:C393(!00-00-00!; $year; 8; 20)})
	$bankHolidays.push({name: "Journée de la Jeunesse"; type: 3; date: Add to date:C393(!00-00-00!; $year; 8; 21)})
	$bankHolidays.push({name: "La Marche verte"; type: 3; date: Add to date:C393(!00-00-00!; $year; 11; 6)})
	$bankHolidays.push({name: "Fête de l’Indépendance"; type: 3; date: Add to date:C393(!00-00-00!; $year; 11; 18)})
	
	For each ($bankHoliday; $bankHolidays)
		
		$eBankHoliday:=ds:C1482.BankHoliday.query("UUID_Company = :1 AND dateOff = :2"; $uuidCompany; $bankHoliday.date).first()
		If ($eBankHoliday=Null:C1517)
			$eBankHoliday:=ds:C1482.BankHoliday.new()
			$eBankHoliday.dateOff:=$bankHoliday.date
			$eBankHoliday.UUID_Company:=$uuidCompany
			$eBankHoliday.typeID:=$bankHoliday.type
		End if 
		$eBankHoliday.name:=$bankHoliday.name
		
		$info:=$eBankHoliday.save()
		//End if 
	End for each 
Function generateMoroccoUncertainBankHolidays($year : Integer; $uuidCompany : Text; $islamiqueDates : Object)
	var $eBankHoliday : cs:C1710.BankHolidayEntity
	
	// jours fixes
	$bankHolidays:=New collection:C1472
	$bankHolidays.push({name: "Islamic New Year"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateM; $year)-1})
	$bankHolidays.push({name: "Islamic New Year"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateM; $year)})
	$bankHolidays.push({name: "Islamic New Year"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateM; $year)+1})
	
	$bankHolidays.push({name: "Eid al-Fitr"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateF; $year)-1})
	$bankHolidays.push({name: "Eid al-Fitr"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateF; $year)})
	$bankHolidays.push({name: "Eid al-Fitr"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateF; $year)+1})
	
	$bankHolidays.push({name: "Eid al-Adha"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateA; $year)-1})
	$bankHolidays.push({name: "Eid al-Adha"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateA; $year)})
	$bankHolidays.push({name: "Eid al-Adha"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateA; $year)+1})
	
	$bankHolidays.push({name: "Eid al-Mawlid"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateMAW; $year)-1})
	$bankHolidays.push({name: "Eid al-Mawlid"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateMAW; $year)})
	$bankHolidays.push({name: "Eid al-Mawlid"; type: 4; date: cs:C1710.sfw_stmp.me.getIslamiqueDay($islamiqueDates.dateMAW; $year)+1})
	
	For each ($bankHoliday; $bankHolidays)
		
		$eBankHoliday:=ds:C1482.BankHoliday.query("UUID_Company = :1 AND dateOff = :2"; $uuidCompany; $bankHoliday.date).first()
		If ($eBankHoliday=Null:C1517)
			$eBankHoliday:=ds:C1482.BankHoliday.new()
			$eBankHoliday.dateOff:=$bankHoliday.date
			$eBankHoliday.UUID_Company:=$uuidCompany
			$eBankHoliday.typeID:=$bankHoliday.type
		End if 
		$eBankHoliday.name:=$bankHoliday.name
		
		$info:=$eBankHoliday.save()
		//End if 
	End for each 
	
	For each ($bankHoliday; $bankHolidays)
		
		$eBankHoliday:=ds:C1482.BankHoliday.query("UUID_Company = :1 AND dateOff = :2"; $uuidCompany; $bankHoliday.date).first()
		If ($eBankHoliday=Null:C1517)
			$eBankHoliday:=ds:C1482.BankHoliday.new()
			$eBankHoliday.dateOff:=$bankHoliday.date
			$eBankHoliday.UUID_Company:=$uuidCompany
			$eBankHoliday.typeID:=$bankHoliday.type
		End if 
		$eBankHoliday.name:=$bankHoliday.name
		
		$info:=$eBankHoliday.save()
		//End if 
	End for each 
	
	
	
	//MARK:-Germany
	
Function generateGermanyBankHolidays($year : Integer; $uuidCompany : Text)
	var $eBankHoliday : cs:C1710.BankHolidayEntity
	
	// Fixed holidays
	$bankHolidays:=New collection:C1472
	$bankHolidays.push({name: "New Year's Day"; type: 5; date: Add to date:C393(!00-00-00!; $year; 1; 1)})
	$bankHolidays.push({name: "Labour Day"; type: 5; date: Add to date:C393(!00-00-00!; $year; 5; 1)})
	$bankHolidays.push({name: "German Unity Day"; type: 5; date: Add to date:C393(!00-00-00!; $year; 10; 3)})
	$bankHolidays.push({name: "Christmas Day"; type: 5; date: Add to date:C393(!00-00-00!; $year; 12; 25)})
	$bankHolidays.push({name: "Boxing Day/Second Christmas Day"; type: 5; date: Add to date:C393(!00-00-00!; $year; 12; 26)})
	
	// Easter-related holidays
	$easter:=cs:C1710.sfw_stmp.me.getEaster($year)
	$bankHolidays.push({name: "Easter Sunday"; type: 5; date: $easter})
	$bankHolidays.push({name: "Good Friday"; type: 5; date: $easter-2})
	$bankHolidays.push({name: "Easter Monday"; type: 5; date: $easter+1})
	$bankHolidays.push({name: "Ascension Day"; type: 5; date: $easter+39})
	$bankHolidays.push({name: "Whit Monday"; type: 5; date: $easter+50})
	$bankHolidays.push({name: "Corpus Christi"; type: 5; date: $easter+60})
	
	For each ($bankHoliday; $bankHolidays)
		
		$eBankHoliday:=ds:C1482.BankHoliday.query("UUID_Company = :1 AND dateOff = :2"; $uuidCompany; $bankHoliday.date).first()
		If ($eBankHoliday=Null:C1517)
			$eBankHoliday:=ds:C1482.BankHoliday.new()
			$eBankHoliday.dateOff:=$bankHoliday.date
			$eBankHoliday.UUID_Company:=$uuidCompany
			$eBankHoliday.typeID:=$bankHoliday.type
		End if 
		$eBankHoliday.name:=$bankHoliday.name
		
		$info:=$eBankHoliday.save()
		//End if 
	End for each 
	
	
	//MARK:-Japan
	
Function generateJapanBankHolidays($year : Integer; $uuidCompany : Text)
	var $eBankHoliday : cs:C1710.BankHolidayEntity
	
	// jours fixes
	$bankHolidays:=New collection:C1472
	$bankHolidays.push({name: "New Year's Day"; type: 6; date: Add to date:C393(!00-00-00!; $year; 1; 1)})
	$bankHolidays.push({name: "National Foundation Day"; type: 6; date: Add to date:C393(!00-00-00!; $year; 2; 11)})
	$bankHolidays.push({name: "Emperor's Birthday"; type: 6; date: Add to date:C393(!00-00-00!; $year; 2; 23)})
	$bankHolidays.push({name: "Constitution Memorial Day"; type: 6; date: Add to date:C393(!00-00-00!; $year; 5; 3)})
	$bankHolidays.push({name: "Greenery Day"; type: 6; date: Add to date:C393(!00-00-00!; $year; 5; 4)})
	$bankHolidays.push({name: "Children's Day"; type: 6; date: Add to date:C393(!00-00-00!; $year; 5; 5)})
	$bankHolidays.push({name: "Mountain Day"; type: 6; date: Add to date:C393(!00-00-00!; $year; 8; 11)})
	$bankHolidays.push({name: "Culture Day"; type: 6; date: Add to date:C393(!00-00-00!; $year; 11; 3)})
	$bankHolidays.push({name: "Labor Thanksgiving Day"; type: 6; date: Add to date:C393(!00-00-00!; $year; 11; 23)})
	
	// Jours variables
	$bankHolidays.push({name: "Coming of Age Day"; type: 6; date: cs:C1710.sfw_stmp.me.getNthWeekday($year; 1; 2; 2)})  // 2ème lundi de janvier
	$bankHolidays.push({name: "Marine Day"; type: 6; date: cs:C1710.sfw_stmp.me.getNthWeekday($year; 7; 3; 2)})  // 3ème lundi de juillet
	$bankHolidays.push({name: "Respect for the Aged Day"; type: 6; date: cs:C1710.sfw_stmp.me.getNthWeekday($year; 9; 3; 2)})  // 3ème lundi de septembre
	$bankHolidays.push({name: "Health and Sports Day"; type: 6; date: cs:C1710.sfw_stmp.me.getNthWeekday($year; 10; 2; 2)})  // 2ème lundi de octobre 
	
	For each ($bankHoliday; $bankHolidays)
		$eBankHoliday:=ds:C1482.BankHoliday.query("UUID_Company = :1 AND dateOff = :2"; $uuidCompany; $bankHoliday.date).first()
		If ($eBankHoliday=Null:C1517)
			$eBankHoliday:=ds:C1482.BankHoliday.new()
			$eBankHoliday.dateOff:=$bankHoliday.date
			$eBankHoliday.UUID_Company:=$uuidCompany
			$eBankHoliday.typeID:=$bankHoliday.type
		End if 
		$eBankHoliday.name:=$bankHoliday.name
		
		$info:=$eBankHoliday.save()
	End for each 
	
	
	
	
	
	//MARK:-Austrilia
	
Function generateAustraliaBankHolidays($year : Integer; $uuidCompany : Text)
	var $eBankHoliday : cs:C1710.BankHolidayEntity
	
	// Fixed holidays
	$bankHolidays:=New collection:C1472
	$bankHolidays.push({name: "New Year's Day"; type: 7; date: Add to date:C393(!00-00-00!; $year; 1; 1)})
	$bankHolidays.push({name: "Australia Day"; type: 7; date: Add to date:C393(!00-00-00!; $year; 1; 26)})
	$bankHolidays.push({name: "ANZAC Day"; type: 7; date: Add to date:C393(!00-00-00!; $year; 4; 25)})
	$bankHolidays.push({name: "Labour Day"; type: 7; date: Add to date:C393(!00-00-00!; $year; 3; 4)})
	$bankHolidays.push({name: "Queen's Birthday"; type: 7; date: Add to date:C393(!00-00-00!; $year; 6; 10)})
	$bankHolidays.push({name: "Christmas Day"; type: 7; date: Add to date:C393(!00-00-00!; $year; 12; 25)})
	$bankHolidays.push({name: "Boxing Day"; type: 7; date: Add to date:C393(!00-00-00!; $year; 12; 26)})
	
	// Easter-related holidays
	$easter:=cs:C1710.sfw_stmp.me.getEaster($year)
	$bankHolidays.push({name: "Easter Sunday"; type: 7; date: $easter})  // Easter Sunday
	$bankHolidays.push({name: "Good Friday"; type: 7; date: $easter-2})  // Good Friday
	$bankHolidays.push({name: "Easter Saturday"; type: 7; date: $easter-1})  // Easter Saturday
	$bankHolidays.push({name: "Easter Monday"; type: 7; date: $easter+1})  // Easter Monday
	
	For each ($bankHoliday; $bankHolidays)
		
		$eBankHoliday:=ds:C1482.BankHoliday.query("UUID_Company = :1 AND dateOff = :2"; $uuidCompany; $bankHoliday.date).first()
		If ($eBankHoliday=Null:C1517)
			$eBankHoliday:=ds:C1482.BankHoliday.new()
			$eBankHoliday.dateOff:=$bankHoliday.date
			$eBankHoliday.UUID_Company:=$uuidCompany
			$eBankHoliday.typeID:=$bankHoliday.type
		End if 
		$eBankHoliday.name:=$bankHoliday.name
		
		$info:=$eBankHoliday.save()
		//End if 
	End for each 
	