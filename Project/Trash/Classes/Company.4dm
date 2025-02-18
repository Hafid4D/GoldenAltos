Class extends DataClass



local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("company"; "teamManagment"; "4D Companies")
	$entry.setDataclass("Company")
	$entry.setIcon("image/entry/company4D-50x50.png")
	$entry.setToolbarLabel("4D Comp.")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_company")
	$entry.setPanelPage(1; "staff-32x32.png"; "Staff")
	$entry.setPanelPage(2; "holidays-32x32.png"; "Bank holidays")
	$entry.setPanelPage(3; "address-32x32.png"; "Address")
	
	$entry.setLBItemsColumn("country.iso_code_2"; " "; "type:flag"; "width:30"; "orderByFormula:this.country.iso_code_2")
	$entry.setLBItemsColumn("name"; "Name"; "width:200")
	$entry.setLBItemsOrderBy("name")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:company"; "unitN:companies")
	
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize"; "message:The name is mandatory")
	$entry.setValidationRule("UUID_Country"; ""; "UUIDNotNull"; "message:The country must be defined")
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	$entry.setItemAction("Generate French bank holidays for a year..."; "dialogGenerateFrenchBankHolidays"; "activateIf:(Form.sfw.checkIsInModification())")
	$entry.setItemAction("Generate United States bank holidays for a year..."; "dialogGenerateUSBankHolidays"; "activateIf:(Form.sfw.checkIsInModification())")
	$entry.setItemAction("Generate Germany bank holidays for a year..."; "dialogGenerateGermanyBankHolidays"; "activateIf:(Form.sfw.checkIsInModification())")
	$entry.setItemAction("Generate Japan bank holidays for a year..."; "dialogGenerateJapanBankHolidays"; "activateIf:(Form.sfw.checkIsInModification())")
	$entry.setItemAction("Generate Australia bank holidays for a year..."; "dialogGenerateAustraliaBankHolidays"; "activateIf:(Form.sfw.checkIsInModification())")
	$entry.setItemAction("Generate Morocco bank holidays for a year..."; "dialogGenerateMoroccoBankHolidays"; "activateIf:(Form.sfw.checkIsInModification())")
	
	$entry.setItemListProjection("Projection to staff"; "projectionToStaffs"; "staff"; "teamManagment")
	$entry.setItemListProjection("Projection to manager"; "projectionToManagers"; "staff"; "teamManagment")
	
	$entry.allowMultiSelectionInLB()
	
	
local Function dialogGenerateFrenchBankHolidays()
	var $year : Integer
	
	$year:=Num:C11(Request:C163("Enter the year to generate holidays"; String:C10(Year of:C25(Current date:C33))))
	If (ok=1) && ($year>=2024) && ($year<2050)
		ds:C1482.BankHoliday.generateFrenchBankHolidays($year; Form:C1466.current_item.UUID)
	End if 
	
	
	//MARK:-
local Function dialogGenerateUSBankHolidays()
	var $year : Integer
	
	$year:=Num:C11(Request:C163("Enter the year to generate holidays"; String:C10(Year of:C25(Current date:C33))))
	If (ok=1) && ($year>=2024) && ($year<2050)
		ds:C1482.BankHoliday.generateUSBankHolidays($year; Form:C1466.current_item.UUID)
	End if 
	
	
	
	
	//MARK:-
local Function dialogGenerateMoroccoBankHolidays()
	var $year : Integer
	
	$year:=Num:C11(Request:C163("Enter the year to generate holidays"; String:C10(Year of:C25(Current date:C33))))
	If (ok=1) && ($year>=2024) && ($year<2050)
		ds:C1482.BankHoliday.generateMoroccoBankHolidays($year; Form:C1466.current_item.UUID)
	End if 
	$islamiqueDates:=New object:C1471()
	$islamiqueDates.dateM:=Date:C102(Request:C163("Enter the date of the first Muharram of last year"; String:C10(Current date:C33)))
	$islamiqueDates.dateF:=Date:C102(Request:C163("Enter the date of Eid al-Fitr of last year"; String:C10(Current date:C33)))
	$islamiqueDates.dateA:=Date:C102(Request:C163("Enter the date of Eid al-Adha of last year"; String:C10(Current date:C33)))
	$islamiqueDates.dateMAW:=Date:C102(Request:C163("Enter the date of Eid al-Mawlid of last year"; String:C10(Current date:C33)))
	
	If (ok=1)
		ds:C1482.BankHoliday.generateMoroccoUncertainBankHolidays($year; Form:C1466.current_item.UUID; $islamiqueDates)
	End if 
	
	
	
	//MARK:-
local Function dialogGenerateGermanyBankHolidays()
	var $year : Integer
	
	$year:=Num:C11(Request:C163("Enter the year to generate holidays"; String:C10(Year of:C25(Current date:C33))))
	If (ok=1) && ($year>=2024) && ($year<2050)
		ds:C1482.BankHoliday.generateGermanyBankHolidays($year; Form:C1466.current_item.UUID)
	End if 
	
	
	
	
	//MARK:-
local Function dialogGenerateJapanBankHolidays()
	var $year : Integer
	
	$year:=Num:C11(Request:C163("Enter the year to generate holidays"; String:C10(Year of:C25(Current date:C33))))
	If (ok=1) && ($year>=2024) && ($year<2050)
		ds:C1482.BankHoliday.generateJapanBankHolidays($year; Form:C1466.current_item.UUID)
	End if 
	
	
	
	
	//MARK:-
local Function dialogGenerateAustraliaBankHolidays()
	var $year : Integer
	
	$year:=Num:C11(Request:C163("Enter the year to generate holidays"; String:C10(Year of:C25(Current date:C33))))
	If (ok=1) && ($year>=2024) && ($year<2050)
		ds:C1482.BankHoliday.generateAustraliaBankHolidays($year; Form:C1466.current_item.UUID)
	End if 
	
	
	//Mark:- Function to manage the cache
local Function cacheClear()
	If (Storage:C1525.cache#Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.company:=Null:C1517
		End use 
	End if 
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.company=Null:C1517)
		$companyCall:=This:C1470._loadAsCollection()
		Use (Storage:C1525.cache)
			Storage:C1525.cache.company:=$companyCall.copy(ck shared:K85:29; Storage:C1525.cache)
		End use 
	End if 
	
	
local Function cacheGet($uuid : Text)->$company : Object
	If (Storage:C1525.cache=Null:C1517)
		This:C1470.cacheLoad()
	Else 
		If (Storage:C1525.cache.company=Null:C1517)
			This:C1470.cacheLoad()
		End if 
	End if 
	$indices:=Storage:C1525.cache.company.indices("UUID = :1"; $uuid)
	If ($indices.length>0)
		$company:=Storage:C1525.cache.company[$indices[0]]
	Else 
		$company:=New object:C1471
	End if 
	
	
Function trigger()
	If (Application type:C494=4D Local mode:K5:1)
		This:C1470.cacheClear()
	Else 
		EXECUTE ON CLIENT:C651("@"; "sfw_cacheManager"; "clear"; "Company")
	End if 
	
Function _loadAsCollection()->$companyCall : Collection
	
	$companyCall:=This:C1470.all().toCollection("UUID, name, country.iso_code_2").orderBy("name")
	
	//local Function updateHolidaysCalendarOld()
	//$year:=Form.pupYear.currentValue
	
	//var $date : Date
	//var $from; $to : Date
	//var $eBankHoliday : cs.BankHolidayEntity
	//var $esBankHolidays : cs.BankHolidaySelection
	//var $eCloseDay : cs.CloseDayEntity
	//var $esCloseDays : cs.CloseDaySelection
	//var $datesOff : Collection
	
	//$dateFrom:=Add to date(!00-00-00!; $year; 1; 1)
	//$dateTo:=Add to date($dateFrom; 1; 0; -1)
	
	//$settings:=New object("queryPlan"; True)
	//$settings.parameters:=New object
	//$criteras:=New collection
	//$criteras.push("dateOff >= :from")
	//$settings.parameters.from:=$dateFrom
	//$criteras.push("dateOff <= :to")
	//$settings.parameters.to:=$dateTo
	//$criteras.push("UUID_Company = :uuidCompany")
	//$settings.parameters.uuidCompany:=Form.current_item.UUID
	
	//$criterasString:=$criteras.join(" & ")
	
	//$esBankHolidays:=ds.BankHoliday.query($criterasString; $settings)
	//$esCloseDays:=ds.CloseDay.query($criterasString; $settings)
	
	
	//OBJECT SET VISIBLE(*; "day_@"; False)
	//OBJECT GET COORDINATES(*; "day_1"; $gday1; $hday1; $dday1; $bday1)
	
	//$dnum:=0
	//FORM GET OBJECTS($_names)
	//$maxValues:=8
	
	//$date:=$dateFrom
	//While (Year of($date)=$year)
	//$dnum:=$dnum+1
	//$buttonName:="day_"+String($dnum)
	//If (Find in array($_names; $buttonName)=-1)
	//OBJECT DUPLICATE(*; "day_1"; $buttonName)
	//End if 
	//OBJECT SET VISIBLE(*; $buttonName; True)
	//$dayNum:=Day of($date)
	//$monthNum:=Month of($date)
	//If ($buttonName#"day_1")
	//OBJECT SET COORDINATES(*; $buttonName; \
						$gday1+(($dayNum-1)*25); \
						$hday1+(($monthNum-1)*25); \
						$gday1+(($dayNum-1)*25)+24; \
						$hday1+(($monthNum-1)*25)+24)
	//End if 
	
	//$eBankHoliday:=$esBankHolidays.query("dateOff = :1"; $date).first()
	//$eCloseDay:=$esCloseDays.query("dateOff = :1"; $date).first()
	
	//Case of 
	//: ($eCloseDay#Null)
	//OBJECT SET FORMAT(*; $buttonName; Replace string(Form.calculation.format_day_1; "red_000"; "red_050"))
	//OBJECT SET RGB COLORS(*; $buttonName; "white")
	//OBJECT SET HELP TIP(*; $buttonName; String($eCloseDay.dateOff; System date long)+": "+$eCloseDay.label)
	//: ($eBankHoliday#Null)
	//OBJECT SET FORMAT(*; $buttonName; Replace string(Form.calculation.format_day_1; "red_000"; "grey"))
	//OBJECT SET RGB COLORS(*; $buttonName; "white")
	//OBJECT SET HELP TIP(*; $buttonName; String($eBankHoliday.dateOff; System date long)+": "+$eBankHoliday.name)
	
	//: (Day number($date)=1) || (Day number($date)=7)
	//OBJECT SET FORMAT(*; $buttonName; Replace string(Form.calculation.format_day_1; "red_000"; "lightgrey"))
	//OBJECT SET RGB COLORS(*; $buttonName; "black")
	//OBJECT SET HELP TIP(*; $buttonName; String($date; System date long))
	
	//Else 
	//OBJECT SET FORMAT(*; $buttonName; Replace string(Form.calculation.format_day_1; "red_000"; "white"))
	//OBJECT SET RGB COLORS(*; $buttonName; "black")
	//OBJECT SET HELP TIP(*; $buttonName; String($date; System date long))
	//End case 
	//OBJECT SET TITLE(*; $buttonName; Substring(Form.days[Day number($date)-1]; 1; 1))
	
	//$date:=$date+1
	//End while 
	
local Function updateHolidaysCalendar()
	$year:=Form:C1466.pupYear.currentValue
	
	var $date : Date
	var $from; $to : Date
	var $bankHoliday : Object
	var $bankHolidays : Collection
	var $closeDay : Object
	var $closeDays : Collection
	var $datesOff : Collection
	
	$dateFrom:=Add to date:C393(!00-00-00!; $year; 1; 1)
	$dateTo:=Add to date:C393($dateFrom; 1; 0; -1)
	
	$settings:=New object:C1471("queryPlan"; True:C214)
	$settings.parameters:=New object:C1471
	$criteras:=New collection:C1472
	$criteras.push("dateOff >= :from")
	$settings.parameters.from:=$dateFrom
	$criteras.push("dateOff <= :to")
	$settings.parameters.to:=$dateTo
	$criteras.push("UUID_Company = :uuidCompany")
	$settings.parameters.uuidCompany:=Form:C1466.current_item.UUID
	
	$criterasString:=$criteras.join(" & ")
	
	$bankHolidays:=ds:C1482.BankHoliday.query($criterasString; $settings).toCollection("dateOff,name,UUID")
	$closeDays:=ds:C1482.CloseDay.query($criterasString; $settings).toCollection("dateOff,label,UUID")
	
	
	OBJECT SET VISIBLE:C603(*; "day_@"; False:C215)
	OBJECT GET COORDINATES:C663(*; "day_1"; $gday1; $hday1; $dday1; $bday1)
	
	$dnum:=0
	FORM GET OBJECTS:C898($_names)
	$maxValues:=8
	
	$date:=$dateFrom
	While (Year of:C25($date)=$year)
		$dnum:=$dnum+1
		$buttonName:="day_"+String:C10($dnum)
		If (Find in array:C230($_names; $buttonName)=-1)
			OBJECT DUPLICATE:C1111(*; "day_1"; $buttonName)
		End if 
		OBJECT SET VISIBLE:C603(*; $buttonName; True:C214)
		$dayNum:=Day of:C23($date)
		$monthNum:=Month of:C24($date)
		If ($buttonName#"day_1")
			OBJECT SET COORDINATES:C1248(*; $buttonName; \
				$gday1+(($dayNum-1)*25); \
				$hday1+(($monthNum-1)*25); \
				$gday1+(($dayNum-1)*25)+24; \
				$hday1+(($monthNum-1)*25)+24)
		End if 
		
		$bankHoliday:=$bankHolidays.query("dateOff = :1"; $date).first()
		$closeDay:=$closeDays.query("dateOff = :1"; $date).first()
		
		Case of 
			: ($closeDay#Null:C1517)
				OBJECT SET FORMAT:C236(*; $buttonName; Replace string:C233(Form:C1466.calculation.format_day_1; "red_000"; "red_050"))
				OBJECT SET RGB COLORS:C628(*; $buttonName; "white")
				OBJECT SET HELP TIP:C1181(*; $buttonName; String:C10($closeDay.dateOff; System date long:K1:3)+": "+$closeDay.label)
			: ($bankHoliday#Null:C1517)
				OBJECT SET FORMAT:C236(*; $buttonName; Replace string:C233(Form:C1466.calculation.format_day_1; "red_000"; "grey"))
				OBJECT SET RGB COLORS:C628(*; $buttonName; "white")
				OBJECT SET HELP TIP:C1181(*; $buttonName; String:C10($bankHoliday.dateOff; System date long:K1:3)+": "+$bankHoliday.name)
				
			: (Day number:C114($date)=1) || (Day number:C114($date)=7)
				OBJECT SET FORMAT:C236(*; $buttonName; Replace string:C233(Form:C1466.calculation.format_day_1; "red_000"; "lightgrey"))
				OBJECT SET RGB COLORS:C628(*; $buttonName; "black")
				OBJECT SET HELP TIP:C1181(*; $buttonName; String:C10($date; System date long:K1:3))
				
			Else 
				OBJECT SET FORMAT:C236(*; $buttonName; Replace string:C233(Form:C1466.calculation.format_day_1; "red_000"; "white"))
				OBJECT SET RGB COLORS:C628(*; $buttonName; "black")
				OBJECT SET HELP TIP:C1181(*; $buttonName; String:C10($date; System date long:K1:3))
		End case 
		OBJECT SET TITLE:C194(*; $buttonName; Substring:C12(Form:C1466.days[Day number:C114($date)-1]; 1; 1))
		
		$date:=$date+1
	End while 
	
	
	
	
	