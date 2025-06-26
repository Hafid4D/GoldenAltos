//%attributes = {"executedOnServer":true}


var $colors : Collection:=New collection:C1472("#3CB371"; "#FFFF00"; "#FF7F50"; "#1E90FF"; "#FF0000")


//---->[SpecControllingDept]
var $eControllingDept : cs:C1710.SpecControllingDeptEntity
var $SpecControllingDepts : Collection:=New collection:C1472("All"; "Accounting"; "Assembly"; "Beanch"; \
"Business Development"; "Customer"; "Electrical Test"; "EMS"; "ESD-LU"; "Facilities"; "FSO"; \
"Hardware"; "HR"; "IT"; "Planning"; "Product Assurance"; "Program Management"; "Purchasing"; "QA"; \
"Reliability"; "Test"; "Vendor")
TRUNCATE TABLE:C1051([SpecControllingDept:45])
For ($i; 0; $SpecControllingDepts.length-1)
	$eControllingDept:=ds:C1482.SpecControllingDept.new()
	$eControllingDept.departmentID:=$i
	$eControllingDept.name:=$SpecControllingDepts[$i]
	$eControllingDept.save()
End for 

//---->[SpecCategory]
var $eCategory : cs:C1710.SpecCategoryEntity
var $specificationCategories : Collection:=New collection:C1472("All"; "Customer Service"; "Document Control"; \
"Golden Altos Forms (including Logs, Checklists)"; "Maintenance Engineering"; \
"Military Standard"; "Process_Production Procedures"; "Quality Assurance"; "Quality Control"; \
"Quality Manual"; "System Procedure"; "Training")
TRUNCATE TABLE:C1051([SpecCategory:44])
For ($i; 0; $specificationCategories.length-1)
	$eCategory:=ds:C1482.SpecCategory.new()
	$eCategory.categoryID:=$i
	$eCategory.name:=$specificationCategories[$i]
	$eCategory.save()
End for 


//----> [EquipementLocation]
var $eEquipmentLocation : cs:C1710.EquipmentLocationEntity
var $equipmentsLocations : Collection:=New collection:C1472("4TH OPTICAL"; "Burn-in"; "Eng'r"; \
"Engineering"; "Environmental"; "EOL"; "FACILITY"; "FOL"; "FOL for Profiler"; \
"FOL/RTC"; "Front of Line"; "Lab/ Vibration"; "Lab/Mechanical Shock"; \
"Lab/Milpitas"; "Marking"; "Pad"; "Solder"; "Solder Dip"; "Trim")
TRUNCATE TABLE:C1051([EquipmentLocation:19])
For ($i; 0; $equipmentsLocations.length-1)
	$eEquipmentLocation:=ds:C1482.EquipmentLocation.new()
	$eEquipmentLocation.locationID:=$i+1
	$eEquipmentLocation.name:=$equipmentsLocations[$i]
	$eEquipmentLocation.save()
End for 


//----> [Division]
var $eDivision : cs:C1710.DivisionEntity
var $divisions : Collection:=New collection:C1472("GAC")
TRUNCATE TABLE:C1051([Division:20])
For ($i; 0; $divisions.length-1)
	$eDivision:=ds:C1482.Division.new()
	$eDivision.divisionID:=$i+1
	$eDivision.name:=$divisions[$i]
	$eDivision.save()
End for 


//----> [CICategory]
var $eCipCategory : cs:C1710.CICategoryEntity
TRUNCATE TABLE:C1051([CICategory:33])
var $cipCategories : Collection:=New collection:C1472("Internal Risk Mitigation"; \
"External Risk Mitigation"; "Internal Opportunity"; "External Opportunity"; "NMCR Only"; \
"Resource Need"; "Change to QMS"; "Corrective Action"; "Training Need"; "NCR Only"; "Improve Process"; \
"SCAR"; "RMA-KPI"; "RMA-NonKPI"; "NCMR Only"; "Corrective Action and Training"; "Repair"; "Other")
For ($i; 0; $cipCategories.length-1)
	$eCipCategory:=ds:C1482.CICategory.new()
	$eCipCategory.categoryID:=$i+1
	$eCipCategory.name:=$cipCategories[$i]
	$eCipCategory.save()
End for 

//----> [YesNoQuestion]
var $eQuestion : cs:C1710.YesNoQuestionEntity
var $questions : Collection:=New collection:C1472("Yes"; "No"; "N/A")
TRUNCATE TABLE:C1051([YesNoQuestion:34])
For ($i; 0; $questions.length-1)
	$eQuestion:=ds:C1482.YesNoQuestion.new()
	$eQuestion.responseID:=$i+1
	$eQuestion.name:=$questions[$i]
	$eQuestion.save()
End for 

//----> [CIPriority]
var $ePriority : cs:C1710.CIPriorityEntity
var $cipPriorities : Collection:=New collection:C1472("Active"; "Monitor"; "Deferred"; "Complete"; "Canceled")
TRUNCATE TABLE:C1051([CIPriority:27])
For ($i; 0; $cipPriorities.length-1)
	$ePriority:=ds:C1482.CIPriority.new()
	$ePriority.priorityID:=$i+1
	$ePriority.name:=$cipPriorities[$i]
	$ePriority.color:=$colors[$i]
	$ePriority.save()
End for 

//----> [CIOrigin]
var $eOrigin : cs:C1710.CIOriginEntity
var $cipOrigins : Collection:=New collection:C1472("NCR"; "NCMR"; "SWOT"; "Process Risk"; "Human Factors"; \
"Management Review"; "Internal Audit"; "Internal Issue"; "Customer Audit"; "CB Audit"; "Customer CAR"; \
"Complaint"; "Feedback"; "Supplier"; "RMA"; "KPI/Objective Performance"; "Regulatory"; "Process Improvement"; "Other")
TRUNCATE TABLE:C1051([CIOrigin:31])
For ($i; 0; $cipOrigins.length-1)
	$eOrigin:=ds:C1482.CIOrigin.new()
	$eOrigin.originID:=$i+1
	$eOrigin.name:=$cipOrigins[$i]
	$eOrigin.save()
End for 


//----> [CIHumanFactor]
var $eHumanFactor : cs:C1710.CIHumanFactorEntity
var $cipHumanFactors : Collection:=New collection:C1472("Not CAR"; "Not Applicable"; "Fatigue"; \
"Lack of Concentration"; "Complacency"; "Lack of Knowledge"; "Distraction"; "Lack of Teamwork"; \
"Lack of Resources"; "Pressure"; "Lack of Assertiveness"; "Stress"; "Lack of Awareness"; \
"Negative Norms "; "Ergonomics"; "Equipment"; "Culture"; "Competence"; "Environmental"; \
"Feelings"; "Lack of personnel"; "Other")
TRUNCATE TABLE:C1051([CIHumanFactor:29])
For ($i; 0; $cipHumanFactors.length-1)
	$eHumanFactor:=ds:C1482.CIHumanFactor.new()
	$eHumanFactor.factorID:=$i+1
	$eHumanFactor.name:=$cipHumanFactors[$i]
	$eHumanFactor.save()
End for 


//----> [CIDisposition]
var $eDisposition : cs:C1710.CIDispositionEntity
var $cipDispositions : Collection:=New collection:C1472("N/A (Not NCP)"; "Awaiting Disp."; "Scrap"; "Rework"; "Notified the customer"; \
"Repair"; "Use As Is"; "Return To Vendor"; "Improve methods"; "Increase Inventory"; "Revise Spec, Training"; "Revise Procedure")
TRUNCATE TABLE:C1051([CIDisposition:28])
For ($i; 0; $cipDispositions.length-1)
	$eDisposition:=ds:C1482.CIDisposition.new()
	$eDisposition.dispositionID:=$i+1
	$eDisposition.name:=$cipDispositions[$i]
	$eDisposition.save()
End for 


