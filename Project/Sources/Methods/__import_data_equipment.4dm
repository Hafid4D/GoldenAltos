//%attributes = {"executedOnServer":true}
var $eEquipment : cs:C1710.EquipmentEntity
var $eEquipmentLocation : cs:C1710.EquipmentLocationEntity
var $eDivision : cs:C1710.DivisionEntity
var $eRepair : cs:C1710.RepairLogEntity

var $locations; $types; $divisions : Collection

$locations:=New collection:C1472("4TH OPTICAL"; "Burn-in"; "Eng'r"; "Engineering"; "Environmental"; "EOL"; "FACILITY"; "FOL"; "FOL for Profiler"; \
"FOL/RTC"; "Front of Line"; "Lab/ Vibration"; "Lab/Mechanical Shock"; "Lab/Milpitas"; "Marking"; "Pad"; "Solder"; "Solder Dip"; "Trim")

$divisions:=New collection:C1472("GAC")

$equipment_Log:=Folder:C1567(fk data folder:K87:12).file("DataJson/equipments_export.json")

If ($equipment_Log.exists)
	$equipments:=JSON Parse:C1218($equipment_Log.getText())
	TRUNCATE TABLE:C1051([Equipment:13])
	TRUNCATE TABLE:C1051([EquipmentLocation:19])
	TRUNCATE TABLE:C1051([Division:20])
	
	//----> [Division]
	For ($i; 0; $divisions.length-1)
		
		$eDivision:=ds:C1482.Division.new()
		$eDivision.divisionID:=$i+1
		$eDivision.name:=$divisions[$i]
		$eDivision.save()
		
	End for 
	
	//----> [EquipementLocation]
	For ($i; 0; $locations.length-1)
		
		$eEquipmentLocation:=ds:C1482.EquipmentLocation.new()
		$eEquipmentLocation.locationID:=$i+1
		$eEquipmentLocation.name:=$locations[$i]
		//$eEquipmentLocation.color:="#FFFFFF"
		$eEquipmentLocation.save()
	End for 
	
	
	$docs:=Folder:C1567(fk data folder:K87:12).file("DataJson/docServerIndex_export.json")
	$count:=0
	If ($docs.exists)
		
		
		$documents:=JSON Parse:C1218($docs.getText())
		
		
	End if 
	
	
	For each ($equipment; $equipments)
		
		$eEquipment:=ds:C1482.Equipment.new()
		
		$eEquipment.assignedID:=$equipment.AssignedID
		
		//Checkand assign a Location if needed
		$location:=ds:C1482.EquipmentLocation.query("name =:1"; Split string:C1554($equipment.LOC; "\r"; sk trim spaces:K86:2).join("\r"))  //$eEquipment.location:=$equipment.LOC
		
		If ($location.length>0)
			$eEquipment.locationID:=$location[0].locationID
		Else 
			$eEquipment.locationID:=0
		End if 
		
		$eEquipment.model:=$equipment.MODEL
		$eEquipment.serialNumber:=$equipment.SerialNumber
		$eEquipment.nextCalDate:=$equipment.NextCalDate
		$eEquipment.lastCalDate:=$equipment.LastCalDate
		$eEquipment.lastPMDate:=$equipment.LastPMDate
		$eEquipment.nextPMDate:=$equipment.NextPMDate
		$eEquipment.notAtSite:=$equipment.Not_at_site
		
		//Checkand assign a division if needed
		$division:=ds:C1482.Division.query("name =:1"; Split string:C1554($equipment.Division; "\r"; sk trim spaces:K86:2).join("\r"))  //$eEquipment.type:=$equipment.EquipmentType
		
		If ($division.length>0)
			$eEquipment.divisionID:=$division[0].divisionID
		Else 
			$eEquipment.divisionID:=0
		End if 
		
		$eEquipment.engg:=$equipment.Engg
		$eEquipment.calibrationNotRequired:=$equipment.CalibrationNotRequired
		
		//Check and assign a Location if needed
		$type:=ds:C1482.ToolType.query("name =:1"; Split string:C1554($equipment.EquipmentType; "\r"; sk trim spaces:K86:2).join("\r"))  //$eEquipment.type:=$equipment.EquipmentType
		
		If ($type.length>0)
			$eEquipment.UUID_ToolType:=$type[0].UUID
		Else 
			
		End if 
		
		$eEquipment.status:=$equipment.ATE_STATUS
		$eEquipment.calTech:=$equipment.TECH
		$eEquipment.pmTech:=$equipment.PMTech
		$eEquipment.description:=$equipment.Description
		$eEquipment.manufacturer:=$equipment.Manufacturer
		//$eEquipment.equipmentConfig:=$equipment.EquipmentConfig
		$eEquipment.statusHistory:=$equipment.Status_History
		If ($equipment.Status_History#"")
			
		End if 
		$eEquipment.down:=$equipment.Down
		$eEquipment.calInProgress:=$equipment.Cal_inprocess
		$eEquipment.calInterval:=$equipment.CalInterval
		$eEquipment.pmInterval:=$equipment.PMInterval
		$eEquipment.calDocument:=$equipment.CalDocument
		$eEquipment.pmDocument:=$equipment.PMDocument
		$eEquipment.pmNotRequired:=$equipment.PMnotRequired
		
		$_documents:=$documents.query("PrimaryKeyValue=:1 & TableNumber=:2"; String:C10($equipment.UniqueID); 10)
		
		$eEquipment.reports:=New object:C1471()
		$eEquipment.reports.documents:=New collection:C1472()
		
		For each ($document; $_documents)
			$doc:=New object:C1471
			
			$doc.code:=$document.DocCode
			$doc.dateTimeStamp:=$document.DateTimeStamp
			$doc.creationDateTimeStamp:=$document.CreationDateTimeStamp
			$doc.documentPath:=$document.DocumentPath
			$doc.sourcePath:=$document.SourcePath
			$doc.description:=$document.DocDescription
			$doc.approvalDate:=!00-00-00!
			$doc.approvedBy:=""
			$doc.isApproved:=False:C215
			
			$report:=Folder:C1567(fk data folder:K87:12).file("DataJson/EquipmentReports/"+String:C10($document.UniqueID+$document.PrimaryKeyValue))
			If ($report.exists)
				
				C_BLOB:C604($blob)
				DOCUMENT TO BLOB:C525($report.platformPath; $blob)
				
				$doc.blob:=$blob
				
			End if 
			
			$eEquipment.reports.documents.push($doc)
		End for each 
		
		$res:=$eEquipment.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
	End for each 
	
	
End if 


$repair_Log_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/repair_log_export.json")

If ($repair_Log_file.exists)
	$repair_log:=JSON Parse:C1218($repair_Log_file.getText())
	TRUNCATE TABLE:C1051([RepairLog:21])
	
	
	
	For each ($repair; $repair_log)
		
		$eRepair:=ds:C1482.RepairLog.new()
		
		$eRepair.systemID:=$repair.Sys_ID
		$eRepair.reportedBy:=$repair.Rep_by
		$eRepair.fixedBy:=$repair.Fixed_by
		$eRepair.reportedBy:=$repair.Rep_by
		$eRepair.fixedDate:=$repair.Date_fixed
		$eRepair.reportDate:=$repair.Rep_date
		$eRepair.status:=$repair.E_status
		$eRepair.problem:=Split string:C1554($repair.Problem; "\r"; sk trim spaces:K86:2).join("\r")
		$eRepair.reportID:=$repair.Rep_num
		$eRepair.fix:=$repair.Fix
		$eRepair.downHrs:=$repair.Down_hrs
		$eRepair.downAt:=$repair.Down_at
		$eRepair.upAt:=$repair.Up_at
		$eRepair.dateUp:=$repair.Date_fixed
		
		
		$res:=$eRepair.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		
	End for each 
	
End if 






