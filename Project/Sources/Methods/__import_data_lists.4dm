//%attributes = {"executedOnServer":true}


var $colors : Collection:=New collection:C1472("#3CB371"; "#FFFF00"; "#FF7F50"; "#1E90FF"; "#FF0000")


var $carriers; $status; $customerStatuscolors : Collection
$carriers:=New collection:C1472("GAC Driver"; "Fed-Ex Priority"; "fedex Std Overnight"; "fedex"; "fedex Ground"; "Customer Pickup"; "UPS 2nd Day"; "UPS Ground"; "UPS Next Day"; "DHL")
$status:=New collection:C1472("Active"; "Hold"; "Retired"; "Void")
$customerStatuscolors:=New collection:C1472("#32CD32"; "#1E90FF"; "#FF0000"; "#FFFF00")


//----> [CustomerStatus]
TRUNCATE TABLE:C1051([CustomerStatus:130])
For ($i; 0; $status.length-1)
	
	$eCustomerStatus:=ds:C1482.CustomerStatus.new()
	$eCustomerStatus.levelID:=$i+1
	$eCustomerStatus.name:=$status[$i]
	$eCustomerStatus.color:=$customerStatuscolors[$i]
	$eCustomerStatus.save()
	
End for 

//----> [CustomerCarrier]
TRUNCATE TABLE:C1051([CustomerCarrier:7])
For ($i; 0; $carriers.length-1)
	
	$eCustomerCarrier:=ds:C1482.CustomerCarrier.new()
	$eCustomerCarrier.levelID:=$i+1
	$eCustomerCarrier.name:=$carriers[$i]
	$eCustomerCarrier.color:=""
	$eCustomerCarrier.save()
End for 


//---->[ControllingDepartment]
var $eControllingDept : cs:C1710.ControllingDepartmentEntity
var $SpecControllingDepts : Collection:=New collection:C1472("All"; "Accounting"; "Assembly"; "Beanch"; \
"Business Development"; "Customer"; "Electrical Test"; "EMS"; "ESD-LU"; "Facilities"; "FSO"; \
"Hardware"; "HR"; "IT"; "Planning"; "Product Assurance"; "Program Management"; "Purchasing"; "QA"; \
"Reliability"; "Test"; "Vendor")
TRUNCATE TABLE:C1051([ControllingDepartment:45])
For ($i; 0; $SpecControllingDepts.length-1)
	$eControllingDept:=ds:C1482.ControllingDepartment.new()
	$eControllingDept.levelID:=$i
	$eControllingDept.name:=$SpecControllingDepts[$i]
	$eControllingDept.save()
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
	$eEquipmentLocation.levelID:=$i+1
	$eEquipmentLocation.name:=$equipmentsLocations[$i]
	$eEquipmentLocation.color:="#FFFFFF"
	$eEquipmentLocation.save()
End for 


//----> [Division]
var $eDivision : cs:C1710.DivisionEntity
var $divisions : Collection:=New collection:C1472("GAC")
TRUNCATE TABLE:C1051([Division:20])
For ($i; 0; $divisions.length-1)
	$eDivision:=ds:C1482.Division.new()
	$eDivision.levelID:=$i+1
	$eDivision.name:=$divisions[$i]
	$eDivision.color:="#FFFFFF"
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
	$eCipCategory.levelID:=$i+1
	$eCipCategory.name:=$cipCategories[$i]
	$eCipCategory.color:="#FFFFFF"
	$eCipCategory.save()
End for 

//----> [YesNoQuestion]
var $eQuestion : cs:C1710.YesNoQuestionEntity
var $questions : Collection:=New collection:C1472("Yes"; "No"; "N/A")
TRUNCATE TABLE:C1051([YesNoQuestion:34])
For ($i; 0; $questions.length-1)
	$eQuestion:=ds:C1482.YesNoQuestion.new()
	$eQuestion.levelID:=$i+1
	$eQuestion.name:=$questions[$i]
	$eQuestion.color:="#FFFFFF"
	$eQuestion.save()
End for 

//----> [CIPriority]
var $ePriority : cs:C1710.CIPriorityEntity
var $cipPriorities : Collection:=New collection:C1472("Active"; "Monitor"; "Deferred"; "Complete"; "Canceled")
TRUNCATE TABLE:C1051([CIPriority:27])
For ($i; 0; $cipPriorities.length-1)
	$ePriority:=ds:C1482.CIPriority.new()
	$ePriority.levelID:=$i+1
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
	$eOrigin.levelID:=$i+1
	$eOrigin.name:=$cipOrigins[$i]
	$eOrigin.color:="#FFFFFF"
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
	$eHumanFactor.levelID:=$i+1
	$eHumanFactor.name:=$cipHumanFactors[$i]
	$eHumanFactor.color:="#FFFFFF"
	$eHumanFactor.save()
End for 


//----> [CIDisposition]
var $eDisposition : cs:C1710.CIDispositionEntity
var $cipDispositions : Collection:=New collection:C1472("N/A (Not NCP)"; "Awaiting Disp."; "Scrap"; "Rework"; "Notified the customer"; \
"Repair"; "Use As Is"; "Return To Vendor"; "Improve methods"; "Increase Inventory"; "Revise Spec, Training"; "Revise Procedure"; "Other")
TRUNCATE TABLE:C1051([CIDisposition:28])
For ($i; 0; $cipDispositions.length-1)
	$eDisposition:=ds:C1482.CIDisposition.new()
	$eDisposition.levelID:=$i+1
	$eDisposition.name:=$cipDispositions[$i]
	$eDisposition.color:="#FFFFFF"
	$eDisposition.save()
End for 


//----> [Units]
var $eUnit : cs:C1710.UnitsEntity
var $units : Collection:=New collection:C1472("Bag"; "Can"; "EA"; "Hour"; "Lot"; "Pcs"; "Roll"; "Set"; "Box"; "Spool"; "Gallon"; "Ream"; "Case"; \
"Pack"; "Yesr"; "Lbs"; "Pair")
TRUNCATE TABLE:C1051([Units:49])
For ($i; 0; $units.length-1)
	$eUnit:=ds:C1482.Units.new()
	$eUnit.levelID:=$i+1
	$eUnit.name:=$units[$i]
	$eUnit.color:="#FFFFFF"
	$eUnit.save()
End for 


var $eDocCategory : cs:C1710.DocumentCategoryEntity
var $docCategories : Collection:=New collection:C1472("Internal- Procedure"; "Form. External Specifications"; "Military Standard"; "Industry Standards")
TRUNCATE TABLE:C1051([DocumentCategory:42])
For ($i; 0; $docCategories.length-1)
	$eDocCategory:=ds:C1482.DocumentCategory.new()
	$eDocCategory.levelID:=$i+1
	$eDocCategory.name:=$docCategories[$i]
	$eDocCategory.color:="#FFFFFF"
	$eDocCategory.save()
End for 


var $eAuditStatus : cs:C1710.DocumentCategoryEntity
var $auditStatus : Collection:=New collection:C1472("C"; "OFI"; "NCR")
TRUNCATE TABLE:C1051([AuditStatus:46])
For ($i; 0; $auditStatus.length-1)
	$eAuditStatus:=ds:C1482.AuditStatus.new()
	$eAuditStatus.levelID:=$i+1
	$eAuditStatus.name:=$auditStatus[$i]
	$eAuditStatus.color:="#FFFFFF"
	$eAuditStatus.save()
End for 



