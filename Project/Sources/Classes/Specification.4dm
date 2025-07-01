Class extends DataClass


local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	//Mark: entry : Specification
	$entry:=cs:C1710.sfw_definitionEntry.new("specification"; ["qualityAssistance"]; "Specs Control")
	$entry.setDataclass("Specification")
	$entry.setSearchboxField("spec")
	$entry.setDisplayOrder(-500)
	$entry.setIcon("image/entry/spec-control-white-50x50.png")
	
	$entry.setSearchboxField("spec"; "placeholder:Spec#")
	
	$entry.setLBItemsColumn("spec"; "Spec#"; "width:100")
	$entry.setLBItemsColumn("revision"; "Revision"; "width:50")
	$entry.setLBItemsColumn("title"; "Title")
	$entry.setLBItemsOrderBy("spec")
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:specification"; "unitN:specifications")
	
	$entry.setPanel("panel_specification")
	
	$entry.setPanelPage(1; ""; "Main")
	$entry.setPanelPage(2; ""; "Documents")
	
	
	$entry.setItemListAction("Print Spec"; "_ga_printSpec")
	
	
	
	
	// MARK: -Filters
	
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterSpecDocumentType")
	$filter.setDefaultTitle("All Type")
	$filter.setFilterByIDInTable("SpecCategory"; "categoryID"; "categoryID")
	$filter.setDynamicTitle("name"; "## document  type")
	$entry.addFilter($filter)
	
	$filter:=cs:C1710.sfw_definitionFilter.new("filterSpecDocumentType")
	$filter.setDefaultTitle("All departments")
	$filter.setFilterByIDInTable("SpecControllingDept"; "departmentID"; "controllingDeptID")
	$filter.setDynamicTitle("name"; "## controlling department")
	$entry.addFilter($filter)
	
	
	
	// MARK: - Views Definition
	
	
	// MARK: All Addendums
	$view:=cs:C1710.sfw_definitionView.new("allAddendums"; "All addendums")
	$view.setLBItemsColumn("spec"; "Spec#"; "width:100")
	$view.setLBItemsColumn("revision"; "Revision"; "width:50")
	$view.setLBItemsColumn("title"; "Title")
	$view.setLBItemsOrderBy("spec")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:specification"; "unitN:specifications")
	$view.setSubset("allAddendums")
	$entry.setView($view)
	
	// MARK: Docs late in reviewing
	$view:=cs:C1710.sfw_definitionView.new("docsLateInReviewing"; "Control Docs late in Reviewing")
	$view.setLBItemsColumn("spec"; "Spec#"; "width:100")
	$view.setLBItemsColumn("revision"; "Revision"; "width:50")
	$view.setLBItemsColumn("title"; "Title")
	$view.setLBItemsOrderBy("spec")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:specification"; "unitN:specifications")
	$view.setSubset("docsLateInReviewing")
	$entry.setView($view)
	
	
	// MARK: Docs late in reviewing
	$view:=cs:C1710.sfw_definitionView.new("docsRequiringReviewSoon"; "Control Docs requiring review in 7 days")
	$view.setLBItemsColumn("spec"; "Spec#"; "width:100")
	$view.setLBItemsColumn("revision"; "Revision"; "width:50")
	$view.setLBItemsColumn("title"; "Title")
	$view.setLBItemsOrderBy("spec")
	$view.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:specification"; "unitN:specifications")
	$view.setSubset("docsRequiringReviewSoon")
	$entry.setView($view)
	
	
	
	// MARK: - Query Functions
	
	
	
local Function cacheLoad()
	
	If (Storage:C1525.cache=Null:C1517)
		Use (Storage:C1525)
			Storage:C1525.cache:=New shared object:C1526
		End use 
	End if 
	If (Storage:C1525.cache.startDate=Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.startDate:=Current date:C33()
		End use 
	End if 
	If (Storage:C1525.cache.endDate=Null:C1517)
		Use (Storage:C1525.cache)
			Storage:C1525.cache.endDate:=Current date:C33()
		End use 
	End if 
	If (Undefined:C82(Storage:C1525.cache.interval))
		Use (Storage:C1525.cache)
			Storage:C1525.cache.interval:="0"
		End use 
	End if 
	
	
local Function setDateInterval($pushUp; $title)
	This:C1470.cacheLoad()
	
	$form:=New object:C1471
	$form.startDate:=Storage:C1525.cache.startDate
	$form.endDate:=Storage:C1525.cache.endDate
	$form.interval:=Storage:C1525.cache.interval
	MOUSE POSITION:C468($mouseX; $mouseY; $mouseButtons)
	CONVERT COORDINATES:C1365($mouseX; $mouseY; XY Current form:K27:5; XY Main window:K27:8)
	If ($pushUp)
		$mouseY:=$mouseY-190
		$mouseX:=$mouseX-100
	End if 
	$form.pushUp:=$pushUp
	$windRef:=Open window:C153($mouseX; $mouseY; $mouseX+270; $mouseY+165; Movable dialog box:K34:7; $title)
	DIALOG:C40("_ga_setDateInterval"; $form)
	CLOSE WINDOW:C154($windRef)
	Use (Storage:C1525.cache)
		Storage:C1525.cache.startDate:=$form.startDate
		Storage:C1525.cache.endDate:=$form.endDate
		Storage:C1525.cache.interval:=$form.interval
	End use 
	
	
Function allAddendums()->$specifications : cs:C1710.SpecificationSelection
	$specifications:=ds:C1482.Specification.query("addendum =:1"; True:C214)
	
	
Function docsLateInReviewing()->$specifications : cs:C1710.SpecificationSelection
	$specifications:=ds:C1482.Specification.query("suppress =:1 & reviewIntervalInDays >0 & eval((This.reviewDate+This.reviewIntervalInDays)<Current date(*))"; False:C215)
	
	
Function docsRequiringReviewSoon()->$specifications : cs:C1710.SpecificationSelection
	$specifications:=ds:C1482.Specification.query("suppress =:1 & reviewIntervalInDays >0 & eval((This.reviewDate+This.reviewIntervalInDays)<(Current date(*)+7))"; False:C215)
	
	
	
	