//%attributes = {}
var $eEquipment : cs:C1710.EquipmentEntity
var $eEquipmentLocation : cs:C1710.EquipmentLocationEntity
var $eDivision : cs:C1710.DivisionEntity
var $eRepair : cs:C1710.Repair_LogEntity

var $locations; $types; $divisions : Collection

$locations:=New collection:C1472("4TH OPTICAL"; "Burn-in"; "Eng'r"; "Engineering"; "Environmental"; "EOL"; "FACILITY"; "FOL"; "FOL for Profiler"; \
"FOL/RTC"; "Front of Line"; "Lab/ Vibration"; "Lab/Mechanical Shock"; "Lab/Milpitas"; "Marking"; "Pad"; "Solder"; "Solder Dip"; "Trim")

$types:=New collection:C1472("Accelerometer"; "ADS Digimatic Indicator"; "Ball Shear"; "Bubble Leak Test Detector"; "Burn-In Oven"; "Caliper"; \
"Centrifuge"; "Cleaner"; "Data Recorder"; "Die Attach"; "Die Grind"; "Die Shear"; "Digi Timer"; "Digital  Thermometer"; "Digital Force Gauge"; \
"Digital Multimeter"; "Digital Vacuum Gauge"; "Dip Trimmer"; "Dispenser"; "Electrostatic Field Meter"; "ESD Box"; "Facilities"; "Fatigue Tester"; \
"FILTRATION SYSTEM"; "Fine Leak bomb"; "Fine Leak Detector"; "Freezer"; "Furnace"; "Gauge block"; "Gross Leak Bomb"; "Ionizer"; "IR Reflow Oven"; \
"Lazer Engraver"; "MARKER"; "Mechanical shock"; "Micrometer"; "Microscope"; "Microscope, Tool Maker"; "Moisture Chamber"; "Moisture Sensor"; \
"Oscilloscope"; "Oven"; "Particle Counter"; "PIND"; "Plate Maker"; "Power Supply"; "Pressure Gauge"; "Resistance System"; "RTC"; "Salt Atmospheric Chamber"; \
"Saw"; "SCALE"; "Sealing Furnance"; "Seam Sealer"; "Solder Dip Tester"; "Steam Age Chamber"; "Stud Pull Test"; "Tachometer, Laser, Photo"; \
"Temp Cycle"; "Temp/ Humidity Recorder"; "Temperature Probe"; "Thermal Shock"; "Thermocouple"; "Thermocouple TX"; "Torque Tester"; "Trim Form"; \
"Vacuum Gauge"; "VACUUM SEALER"; "Vacuum, Pressure Gauge"; "VIBRATION"; "Wafer Clean"; "Wafer Expander"; "Wafer Mount"; "Weight Set (Class M2)"; \
"Welder"; "Wire Pull Tester"; "Wirebond"; "Wriststrap/Footstrap Tester")


$divisions:=New collection:C1472("GAC")

$equipment_Log:=Folder:C1567(fk data folder:K87:12).file("DataJson/equipments_export.json")

If ($equipment_Log.exists)
	$equipments:=JSON Parse:C1218($equipment_Log.getText())
	TRUNCATE TABLE:C1051([Equipment:13])
	TRUNCATE TABLE:C1051([EquipmentLocation:19])
	TRUNCATE TABLE:C1051([EquipmentType])
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
			//$eEquipment.UUID_ToolType:=0
		End if 
		
		$eEquipment.status:=$equipment.ATE_STATUS
		$eEquipment.calTech:=$equipment.TECH
		$eEquipment.pmTech:=$equipment.PMTech
		$eEquipment.description:=$equipment.Description
		$eEquipment.manufacturer:=$equipment.Manufacturer
		//$eEquipment.equipmentConfig:=$equipment.EquipmentConfig
		$eEquipment.statusHistory:=$equipment.Status_History
		$eEquipment.down:=$equipment.Down
		$eEquipment.calInProgress:=$equipment.Cal_inprocess
		$eEquipment.calInterval:=$equipment.CalInterval
		$eEquipment.pmInterval:=$equipment.PMInterval
		$eEquipment.calDocument:=$equipment.CalDocument
		$eEquipment.pmDocument:=$equipment.PMDocument
		
		
		
		
		$res:=$eEquipment.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		
	End for each 
	
	
End if 


$repair_Log_file:=Folder:C1567(fk data folder:K87:12).file("DataJson/repair_log_export.json")

If ($repair_Log_file.exists)
	$repair_log:=JSON Parse:C1218($repair_Log_file.getText())
	TRUNCATE TABLE:C1051([Repair_Log:21])
	
	
	
	For each ($repair; $repair_log)
		
		$eRepair:=ds:C1482.Repair_Log.new()
		
		$eRepair.systemID:=$repair.Sys_ID
		$eRepair.fixedBy:=$repair.Fixed_by
		$eRepair.dateFixed:=$repair.Date_fixed
		$eRepair.reportDate:=$repair.Rep_date
		$eRepair.status:=$repair.E_status
		$eRepair.problem:=$repair.Problem
		$eRepair.reportID:=$repair.Rep_num
		$eRepair.fix:=$repair.Fix
		
		$res:=$eRepair.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
		
	End for each 
	
End if 






