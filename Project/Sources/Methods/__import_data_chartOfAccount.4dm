//%attributes = {"executedOnServer":true}


var $records : Collection:=New collection:C1472()
var $zeroUUID : Text


If (True:C214)
	
	// Purpose: Import chart of accounts from legacy export JSON (GLAC, AccountType, subaccounts).
	// Parameters: reads DataJson/chartOfAcc_export.json from the data folder.
	// Returns: nothing (truncates and reloads CAO, CAOType, CAOTypeDetail).
	// modified by 4D/PS [2026-may-19]
	
	$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/chartOfAcc_export.json")
	$records:=JSON Parse:C1218($file.getText())
	$zeroUUID:="00"*16
	
	// Legacy export has AccountType only — seed CAOType and CAOTypeDetail from the same distinct values.
	$caoTypes:=$records.extract("AccountType").distinct()
	TRUNCATE TABLE:C1051([CAOTypeDetail:75])
	For ($i; 0; $caoTypes.length-1)
		$typeDetail:=ds:C1482.CAOTypeDetail.new()
		$typeDetail.levelID:=$i+1
		$typeDetail.name:=Split string:C1554($caoTypes[$i]; "\r"; sk trim spaces:K86:2).join("\r")
		$typeDetail.color:=""
		$typeDetail.save()
	End for 
	
	TRUNCATE TABLE:C1051([CAOType:74])
	For ($i; 0; $caoTypes.length-1)
		$type:=ds:C1482.CAOType.new()
		$type.levelID:=$i+1
		$type.name:=Split string:C1554($caoTypes[$i]; "\r"; sk trim spaces:K86:2).join("\r")
		$type.color:=""
		$type.save()
	End for 
	
	TRUNCATE TABLE:C1051([CAO:73])
	
	// PASS 1 — create accounts; parent UUID resolved in PASS 2.
	For each ($record; $records)
		
		$glac:=String:C10($record.GLAC)
		$eChartOfAccount:=ds:C1482.CAO.new()
		
		// Purpose: Map legacy FullAccountName → name and Description → description.
		// modified by 4D/PS [2026-may-19]
		$eChartOfAccount.name:=Split string:C1554($record.FullAccountName; "\r"; sk trim spaces:K86:2).join("\r")
		$eChartOfAccount.description:=Split string:C1554($record.Description; "\r"; sk trim spaces:K86:2).join("\r")
		
		// Purpose: Store legacy GLAC in accountNumber (Text); parent link via UUID_ParentAccount in PASS 2 only
		// (parentAccount is an ORDA relation alias, not a writable Text field).
		// modified by 4D/PS [2026-may-19]
		$eChartOfAccount.accountNumber:=$glac
		
		$typeName:=Split string:C1554($record.AccountType; "\r"; sk trim spaces:K86:2).join("\r")
		$caoType:=ds:C1482.CAOType.query("name =:1"; $typeName)
		If ($caoType.length>0)
			$eChartOfAccount.UUID_CAOType:=$caoType[0].UUID
		Else 
			$eChartOfAccount.UUID_CAOType:=$zeroUUID
		End if 
		
		$caoTypeDetail:=ds:C1482.CAOTypeDetail.query("name =:1"; $typeName)
		If ($caoTypeDetail.length>0)
			$eChartOfAccount.UUID_CAOTypeDetail:=$caoTypeDetail[0].UUID
		Else 
			$eChartOfAccount.UUID_CAOTypeDetail:=$zeroUUID
		End if 
		
		$eChartOfAccount.balance:=$record.Balance
		$eChartOfAccount.isSubaccount:=$record.SubAccount
		$eChartOfAccount.isInacActive:=($record.Remove=True:C214) | ($record.Unused=True:C214)
		$eChartOfAccount.UUID_ParentAccount:=$zeroUUID
		
		// Purpose: Import legacy DefaultKey for system-account resolution (GL posting Phase 2).
		// modified by 4D/PS [2026-june-26]
		If (OB Is defined:C1231($record; "DefaultKey"))
			$eChartOfAccount.defaultKey:=Split string:C1554(String:C10($record.DefaultKey); "\r"; sk trim spaces:K86:2).join("\r")
		Else
			$eChartOfAccount.defaultKey:=""
		End if
		
		$info:=$eChartOfAccount.save()
		If (Not:C34($info.success))
			TRACE:C157
		End if 
		
	End for each 
	
	// Purpose: After all accounts are imported, resolve UUID_ParentAccount via ORDA query on legacy ParentAccountName (parent GLAC = accountNumber).
	// modified by 4D/PS [2026-may-19]
	For each ($record; $records)
		
		$parentGlac:=Split string:C1554(String:C10($record.ParentAccountName); "\r"; sk trim spaces:K86:2).join("\r")
		
		If ($parentGlac#"")
			
			$childSelection:=ds:C1482.CAO.query("accountNumber = :1"; String:C10($record.GLAC))
			$parentSelection:=ds:C1482.CAO.query("accountNumber = :1"; $parentGlac)
			
			If ($childSelection.length>0) & ($parentSelection.length>0)
				$eChild:=$childSelection[0]
				$eChild.UUID_ParentAccount:=$parentSelection[0].UUID
				$eChild.isSubaccount:=True:C214
				$info:=$eChild.save()
				If (Not:C34($info.success))
					TRACE:C157
				End if 
			End if 
			
		End if 
		
	End for each 
	
End if 
