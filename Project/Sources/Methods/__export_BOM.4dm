//%attributes = {}
var $folderPath : Text
var $myFolder : Object

$folderPath:=Get 4D folder:C485(Database folder:K5:14)+"DataJson"

$myFolder:=Folder:C1567(Convert path system to POSIX:C1106($folderPath))

If (Not:C34($myFolder.exists))
	$myFolder.create()
End if 
If (True:C214)  // export po & po lines (po <-- po_lines)
	ALL RECORDS:C47([BOM:96])
	ALL RECORDS:C47([Bom_Items])
	
	$records:=New collection:C1472()
	$records2:=New collection:C1472()
	
	While (Not:C34(End selection:C36([BOM:96])))
		$record:=New object:C1471(\
			"Bom_Part_Num"; [BOM:96]Bom_Part_Num:2; \
			"Inv_Status_Date"; [BOM:96]Inv_Status_Date:3; \
			"Inv_Status_Time"; [BOM:96]Inv_Status_Time:4; \
			"CreatedBy"; [BOM:96]CreatedBy:5; \
			"CreationDateTimeStamp"; [BOM:96]CreationDateTimeStamp:11; \
			"Rev"; [BOM:96]Rev:6; \
			"RevDate"; [BOM:96]RevDate:7; \
			"RevHistory"; [BOM:96]RevHistory:8; \
			"ReasonForLastChange"; [BOM:96]ReasonForLastChange:9; \
			"DateTimeStamp"; [BOM:96]DateTimeStamp:10; \
			"Void"; [BOM:96]Void:12; \
			"PhaseOut"; [BOM:96]PhaseOut:13; \
			"Division"; [BOM]Division; \
			"Customer"; [BOM]Customer\
			)
		$records.push($record)
		NEXT RECORD:C51([BOM:96])
	End while 
	
	
	While (Not:C34(End selection:C36([Bom_Items])))
		$record2:=New object:C1471(\
			"Bom_Part_Num"; [Bom_Items]Bom_part_num; \
			"Supplier_partnum"; [Bom_Items]Supplier_partnum; \
			"Times_factor"; [Bom_Items]Times_factor; \
			"Division"; [Bom_Items]Division; \
			"Internal_partnum"; [Bom_Items]Internal_partnum; \
			"DispensedByTool"; [Bom_Items]DispensedByTool; \
			"Bom_Qty"; [Bom_Items]Bom_Qty; \
			"Qty_in_inventory"; [Bom_Items]Qty_in_inventory; \
			"Supplier"; [Bom_Items]Supplier; \
			"BO_number"; [Bom_Items]BO_number; \
			"BO_line_item_num"; [Bom_Items]BO_line_item_num; \
			"unit_price"; [Bom_Items]unit_price; \
			"Part_Description"; [Bom_Items]Part_Description; \
			"Units"; [Bom_Items]Units; \
			"MinAbsoluteQty"; [Bom_Items]MinAbsoluteQty; \
			"BuyUnitsDivFactor"; [Bom_Items]BuyUnitsDivFactor; \
			"DateTimeStamp"; [Bom_Items]DateTimeStamp; \
			"SequenceID"; [Bom_Items]SequenceID; \
			"CreationDateTimeStamp"; [Bom_Items]CreationDateTimeStamp; \
			"BOM_Nested"; [Bom_Items]BOM_Nested\
			)
		$records2.push($record2)
		NEXT RECORD:C51([Bom_Items])
	End while 
	
	//TEXT TO DOCUMENT($myFolder.platformPath+"po_log_export.json"; JSON Stringify($records))
	vhDoc:=Create document:C266($myFolder.platformPath+"bom.json")
	SEND PACKET:C103(vhDoc; JSON Stringify:C1217($records))
	CLOSE DOCUMENT:C267(vhDoc)
	
	vhDoc2:=Create document:C266($myFolder.platformPath+"bomItems.json")
	SEND PACKET:C103(vhDoc2; JSON Stringify:C1217($records2))
	CLOSE DOCUMENT:C267(vhDoc2)
End if 


ALERT:C41("done exporting BOMs & BOM items")