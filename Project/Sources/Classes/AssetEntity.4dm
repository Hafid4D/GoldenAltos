Class extends Entity


local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=String:C10(This:C1470.assetNumber)
	
	
local Function drowPup($dataClass; $queryField; $queryValue; $pupName)
	
	$entity:=ds:C1482[$dataClass].query($queryField+" =:1"; Form:C1466.current_item[$queryValue]).first() || New object:C1471()
	$name:=$entity.name
	If ($name=Null:C1517)
		$name:=""
	End if 
	If (Not:C34(Undefined:C82($entity.color)))
		$color:=cs:C1710.sfw_htmlColor.me.getName($entity.color)
		$pathIcon:=($color#"") ? "sfw/colors/"+$color+"-circle.png" : "sfw/image/skin/rainbow/icon/spacer-1x24.png"
	Else 
		$pathIcon:=""
	End if 
	Form:C1466.sfw.drawButtonPup($pupName; $name; $pathIcon; ($entity=Null:C1517))
	
	
local Function pup($cacheCollection; $dataClass; $queryField; $queryValue)
	
	If (Form:C1466.sfw.checkIsInModification())
		$menu:=Create menu:C408
		If (Storage:C1525.cache=Null:C1517) || (Storage:C1525.cache[$cacheCollection]=Null:C1517)
			ds:C1482[$dataClass].cacheLoad()
		End if 
		
		For each ($eEntity; Storage:C1525.cache[$cacheCollection])
			APPEND MENU ITEM:C411($menu; $eEntity.name; *)
			SET MENU ITEM PARAMETER:C1004($menu; -1; $eEntity.UUID)
			If ($queryField="UUID")  //# TO BE REMOVED
				
				If ($eEntity[$queryField]=Form:C1466.current_item[$queryValue])
					SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
					If (Is Windows:C1573)
						SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
					End if 
				End if 
			Else 
				
				If (Num:C11($eEntity[$queryField])=Form:C1466.current_item[$queryValue])
					SET MENU ITEM MARK:C208($menu; -1; Char:C90(18))
					If (Is Windows:C1573)
						SET MENU ITEM STYLE:C425($menu; -1; Bold:K14:2)
					End if 
				End if 
				
			End if 
			
		End for each 
		$choose:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		Case of 
			: ($choose#"")
				$eEntity:=ds:C1482[$dataClass].get($choose)
				Form:C1466.current_item[$queryValue]:=$eEntity[$queryField]
		End case 
		
	End if 
	
	
Function get monthlyDepreciation()->$monthlyDepreciation : Real
	// Purpose: Client formula — (cost - accumulated) / useful life; salvage ignored.
	// Returns: Real — monthly depreciation amount (0 when fully depreciated).
	// modified by 4D/PS [2026-may-19]
	If (This:C1470.life=0) | (This:C1470.monthInService>=This:C1470.life)
		$monthlyDepreciation:=0
	Else 
		$monthlyDepreciation:=(This:C1470.originalCost-This:C1470._getAccumulatedDepreciation())/This:C1470.life
	End if 
	
Function get monthInService()->$monthInService : Integer
	
	If (This:C1470.acquiredStmp=0)
		$monthInService:=0
	Else 
		$monthInService:=Month of:C24(This:C1470.acquiredDate)
		$acquiredYear:=Year of:C25(This:C1470.acquiredDate)
		$currentYear:=Year of:C25(Current date:C33(*))
		$currentMonth:=Month of:C24(Current date:C33(*))
		Case of 
			: ($currentYear=$acquiredYear)
				$monthInService:=$currentMonth-$monthInService
				
			: ($currentYear>$acquiredYear)
				$monthInService:=(12-$monthInService)+(12*($currentYear-$acquiredYear-1))+$currentMonth
				
		End case 
	End if 
	
Function get totalAccDepreciation()->$totalAccDepreciation : Real
	// Purpose: Accumulated depreciation based on elapsed service months.
	// Returns: Real
	// modified by 4D/PS [2026-may-19]
	$totalAccDepreciation:=This:C1470._getAccumulatedDepreciation()
	
local Function _getAccumulatedDepreciation()->$accumulated : Real
	// Purpose: Use legacy Acc_dep from import when present; otherwise estimate from service months.
	// Returns: Real
	// modified by 4D/PS [2026-may-19]
	var $importedAccDep : Real
	
	// Purpose: Fix wrong command token IDs (C1119/C1561) that 4D resolved to invalid commands.
	// modified by 4D/PS [2026-may-19]
	If (Value type:C1509(This:C1470.moreData)=Is object:K8:27)
		If (OB Is defined:C1231(This:C1470.moreData; "importedAccDepreciation"))
			$importedAccDep:=Num:C11(This:C1470.moreData.importedAccDepreciation)
			If ($importedAccDep>0)
				$accumulated:=$importedAccDep
				If ($accumulated>This:C1470.originalCost)
					$accumulated:=This:C1470.originalCost
				End if 
				return $accumulated
			End if 
		End if 
	End if 
	
	If (This:C1470.life=0)
		$accumulated:=0
	Else If (This:C1470.monthInService>=This:C1470.life)
		$accumulated:=This:C1470.originalCost
	Else 
		$accumulated:=(This:C1470.originalCost/This:C1470.life)*Num:C11(This:C1470.monthInService)
		If ($accumulated>This:C1470.originalCost)
			$accumulated:=This:C1470.originalCost
		End if 
	End if 
	
local Function get purchaseOrder()->$purchaseOrder : Text
	// Purpose: Display linked customer PO number on the asset panel (read-only).
	// Returns: Text — PO number or empty string
	// modified by 4D/PS [2026-may-19]
	$purchaseOrder:=""
	If (Not:C34(cs:C1710.sfw_string.me.isAnEmptyUUID(This:C1470.UUID_PurchaseOrder)))
		$ePurchaseOrder:=ds:C1482.PurchaseOrder.get(This:C1470.UUID_PurchaseOrder)
		If ($ePurchaseOrder#Null:C1517)
			$purchaseOrder:=String:C10($ePurchaseOrder.poNumber)
		End if 
	End if 
	
local Function get acquiredDate()->$date : Date
	$date:=This:C1470.acquiredStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.acquiredStmp; True:C214)
	
local Function set acquiredDate($date : Date)
	This:C1470.acquiredStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get divestDate()->$date : Date
	$date:=This:C1470.divestStmp=0 ? !00-00-00! : cs:C1710.sfw_stmp.me.getDate(This:C1470.divestStmp; True:C214)
	
local Function set divestDate($date : Date)
	This:C1470.divestStmp:=$date=!00-00-00! ? 0 : cs:C1710.sfw_stmp.me.build($date)
	
local Function get bookValue()->$bookValue : Real
	// Purpose: Remaining book value; zero when fully depreciated or scrapped after divest date.
	// Returns: Real
	// modified by 4D/PS [2026-may-19]
	Case of 
			
		: (This:C1470.isScrapped=True:C214) & (This:C1470.divestDate#!00-00-00!) & (This:C1470.divestDate<=Current date:C33(*))
			$bookValue:=0
		: (This:C1470.life>0) & (This:C1470.monthInService>=This:C1470.life)
			$bookValue:=0
		Else 
			$bookValue:=This:C1470.originalCost-This:C1470.totalAccDepreciation
			If ($bookValue<0)
				$bookValue:=0
			End if 
			$bookValue:=Round:C94($bookValue; 2)
			
	End case 
	
	
Function canApplyManualDepreciation()->$canApply : Boolean
	// Purpose: True when the asset is eligible for a manual depreciation run.
	// Returns: Boolean
	// modified by 4D/PS [2026-may-19]
	$canApply:=False:C215
	If (This:C1470.isScrapped=False:C215) & (This:C1470.excludeFmDepreciationList=False:C215) & (This:C1470.life>0) & (This:C1470.originalCost>0)
		If (This:C1470.monthlyDepreciation>0) & (This:C1470.totalAccDepreciation<This:C1470.originalCost)
			$canApply:=True:C214
		End if 
	End if 
	
	
Function applyManualDepreciation($depreciationDate : Date; $mode : Text)->$result : Object
	// Purpose: Record one manual/automatic depreciation period and update accumulated depreciation.
	// Parameters:
	// $depreciationDate : Date — accounting date for the depreciation entry
	// $mode : Text — "Manual" or "Automatic"
	// Returns: Object — { success : Boolean ; message : Text }
	// modified by 4D/PS [2026-may-19]
	var $moreData : Object
	var $periodKey : Text
	var $amount : Real
	var $newAccumulated : Real
	var $entry : Object
	
	$result:=New object:C1471("success"; False:C215; "message"; "")
	
	If (Not:C34(This:C1470.canApplyManualDepreciation()))
		$result.message:="Asset is not eligible for depreciation"
		return $result
	End if 
	
	$moreData:=This:C1470._ensureMoreData()
	$periodKey:=String:C10(Year of:C25($depreciationDate))+"-"+String:C10(Month of:C24($depreciationDate); "00")
	
	For each ($entry; $moreData.depreciationEntries)
		If ($entry.periodKey=$periodKey)
			$result.message:="Depreciation already recorded for "+$periodKey
			return $result
		End if 
	End for each 
	
	$amount:=Round:C94(This:C1470.monthlyDepreciation; 2)
	$newAccumulated:=This:C1470.totalAccDepreciation+$amount
	If ($newAccumulated>This:C1470.originalCost)
		$amount:=Round:C94(This:C1470.originalCost-This:C1470.totalAccDepreciation; 2)
		$newAccumulated:=This:C1470.originalCost
	End if 
	
	If ($amount<=0)
		$result.message:="Depreciation amount is zero"
		return $result
	End if 
	
	$moreData.importedAccDepreciation:=$newAccumulated
	$moreData.depreciationEntries.push(New object:C1471(\
		"periodKey"; $periodKey; \
		"date"; $depreciationDate; \
		"amount"; $amount; \
		"accumulated"; $newAccumulated; \
		"bookValue"; Round:C94(This:C1470.originalCost-$newAccumulated; 2); \
		"mode"; $mode))
	
	This:C1470.moreData:=$moreData
	
	If ($newAccumulated>=This:C1470.originalCost)
		This:C1470.excludeFmDepreciationList:=True:C214
	End if 
	
	This:C1470.rebuildDeprecationHistory()
	
	$result.success:=True:C214
	$result.message:=""
	
	
Function rebuildDeprecationHistory()
	// Purpose: Build the read-only deprecationHistory text from stored depreciation entries.
	// modified by 4D/PS [2026-may-19]
	var $lines : Collection
	var $entry : Object
	var $moreData : Object
	var $importedAccDep : Real
	
	$lines:=New collection:C1472()
	$moreData:=This:C1470._ensureMoreData()
	
	If (OB Is defined:C1231($moreData; "importedAccDepreciation"))
		$importedAccDep:=Num:C11($moreData.importedAccDepreciation)
		If ($importedAccDep>0) && ($moreData.depreciationEntries.length=0)
			var $legacyBook : Real
			$legacyBook:=This:C1470.originalCost-$importedAccDep
			If ($legacyBook<0)
				$legacyBook:=0
			End if 
			$lines.push("Legacy import | Accumulated: "+String:C10($importedAccDep; "###,###,##0.00")+" | Book value: "+String:C10($legacyBook; "###,###,##0.00"))
		End if 
	End if 
	
	For each ($entry; $moreData.depreciationEntries)
		$lines.push(String:C10($entry.date; System date short:K1:1)+" | Amount: "+String:C10($entry.amount; "###,###,##0.00")+" | Accumulated: "+String:C10($entry.accumulated; "###,###,##0.00")+" | Book value: "+String:C10($entry.bookValue; "###,###,##0.00")+" | "+String:C10($entry.mode))
	End for each 
	
	If ($lines.length=0)
		This:C1470.deprecationHistory:=""
	Else 
		This:C1470.deprecationHistory:=$lines.join("\r")
	End if 
	
	
Function setAutomaticDepreciation($enabled : Boolean)
	// Purpose: Enable or disable automatic monthly depreciation for this asset.
	// Parameters:
	// $enabled : Boolean
	// modified by 4D/PS [2026-may-19]
	var $moreData : Object
	$moreData:=This:C1470._ensureMoreData()
	$moreData.automaticDepreciation:=$enabled
	This:C1470.moreData:=$moreData
	
	
local Function _ensureMoreData()->$moreData : Object
	// Purpose: Guarantee moreData object shape for depreciation tracking.
	// Returns: Object — normalized moreData
	// modified by 4D/PS [2026-may-19]
	// Purpose: Fix wrong command token IDs (C1119/C1561) that 4D resolved to invalid commands.
	// modified by 4D/PS [2026-may-19]
	If (Value type:C1509(This:C1470.moreData)#Is object:K8:27)
		This:C1470.moreData:=New object:C1471()
	End if 
	$moreData:=This:C1470.moreData
	If (Not:C34(OB Is defined:C1231($moreData; "depreciationEntries")))
		$moreData.depreciationEntries:=New collection:C1472()
	End if 
	If (Not:C34(OB Is defined:C1231($moreData; "importedAccDepreciation")))
		$moreData.importedAccDepreciation:=0
	End if 
	If (Not:C34(OB Is defined:C1231($moreData; "automaticDepreciation")))
		$moreData.automaticDepreciation:=False:C215
	End if 
	This:C1470.moreData:=$moreData
	