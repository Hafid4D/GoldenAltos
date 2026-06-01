//%attributes = {"executedOnServer":true}


var $records : Collection:=New collection:C1472()
var $zeroUUID : Text
var $typeName : Text
var $buyNum : Text


If (True:C214)
	
	// Purpose: Import fixed assets from legacy assetList_export.json (Acc_dep, ExcludeFmDepreciationList, PO link).
	// Parameters: reads DataJson/assetList_export.json from the data folder.
	// Returns: nothing (truncates and reloads Asset + AssetType).
	// modified by 4D/PS [2026-may-19]
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/assetList_export.json")
	$records:=JSON Parse:C1218($file.getText())
	$zeroUUID:="00"*16
	
	// Asset types from legacy export (+ "Others" for blank AssetType).
	$assetTypes:=$records.extract("AssetType").distinct()
	If ($assetTypes.indexOf("Others")<0)
		$assetTypes.push("Others")
	End if 
	
	TRUNCATE TABLE:C1051([AssetType:77])
	For ($i; 0; $assetTypes.length-1)
		
		$typeName:=Split string:C1554($assetTypes[$i]; "\r"; sk trim spaces:K86:2).join("\r")
		If ($typeName#"")
			$assetType:=ds:C1482.AssetType.new()
			$assetType.levelID:=$i+1
			$assetType.name:=$typeName
			$assetType.color:=""
			$assetType.save()
		End if 
		
	End for 
	
	TRUNCATE TABLE:C1051([Asset:76])
	For each ($record; $records)
		
		$eAsset:=ds:C1482.Asset.new()
		
		$eAsset.assetNumber:=$record.Asset_num
		
		$typeName:=Split string:C1554($record.AssetType; "\r"; sk trim spaces:K86:2).join("\r")
		If ($typeName="")
			$typeName:="Others"
		End if 
		$type:=ds:C1482.AssetType.query("name =:1"; $typeName)
		If ($type.length>0)
			$eAsset.UUID_AssetType:=$type[0].UUID
		Else 
			$eAsset.UUID_AssetType:=$zeroUUID
		End if 
		
		$vendorName:=Split string:C1554(String:C10($record.Vendor); "\r"; sk trim spaces:K86:2).join("\r")
		If ($vendorName#"")
			$vendor:=ds:C1482.Supplier.query("name =:1"; $vendorName)
			If ($vendor.length>0)
				$eAsset.UUID_Vendor:=$vendor[0].UUID
			Else 
				$eAsset.UUID_Vendor:=$zeroUUID
			End if 
		Else 
			$eAsset.UUID_Vendor:=$zeroUUID
		End if 
		
		$eAsset.description:=Split string:C1554(String:C10($record.Comments); "\r"; sk trim spaces:K86:2).join("\r")
		$eAsset.originalCost:=$record.Cost
		$eAsset.isScrapped:=$record.Scrapped
		$eAsset.life:=$record.Life
		$eAsset.excludeFmDepreciationList:=$record.ExcludeFmDepreciationList
		$eAsset.acquiredStmp:=Date:C102($record.Date_Acquired)=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build(Date:C102($record.Date_Acquired))
		$eAsset.divestStmp:=Date:C102($record.Divest_Date)=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build(Date:C102($record.Divest_Date))
		
		// Purpose: Preserve legacy accumulated depreciation and book value until depreciation runs update them.
		// modified by 4D/PS [2026-may-19]
		$eAsset.moreData:=New object:C1471(\
			"importedAccDepreciation"; Num:C11($record.Acc_dep); \
			"legacyBookValue"; Num:C11($record.Value); \
			"serialNumber"; Split string:C1554(String:C10($record.Serial_num); "\r"; sk trim spaces:K86:2).join("\r"); \
			"glac"; Split string:C1554(String:C10($record.GLAC); "\r"; sk trim spaces:K86:2).join("\r"))
		
		// Link customer PO via legacy Buynum → PurchaseOrder.oldPoNumber (fallback poNumber).
		$buyNum:=Split string:C1554(String:C10($record.Buynum); "\r"; sk trim spaces:K86:2).join("\r")
		If ($buyNum#"")
			$po:=ds:C1482.PurchaseOrder.query("oldPoNumber = :1"; $buyNum)
			If ($po.length=0) && (Match regex:C1019($buyNum; "^\\d+$"))
				$po:=ds:C1482.PurchaseOrder.query("poNumber = :1"; Num:C11($buyNum))
			End if 
			If ($po.length>0)
				$eAsset.UUID_PurchaseOrder:=$po[0].UUID
			Else 
				$eAsset.UUID_PurchaseOrder:=$zeroUUID
			End if 
		Else 
			$eAsset.UUID_PurchaseOrder:=$zeroUUID
		End if 
		
		$info:=$eAsset.save()
		If (Not:C34($info.success))
			TRACE:C157
		End if 
		
	End for each 
	
End if 
