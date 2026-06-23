// Purpose: Entity helpers for InteractionMethod reference records (window title, barcode on creation).
// created by 4D/PS [2026-june-23]
Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.name

// Purpose: Initialize barcode data when a new record is created in the entry panel.
// created by 4D/PS [2026-june-23]
local Function loadAfterCreation()
	// Purpose: Assign a unique barcode in moreData for scanner lookup on new records.
	// modified by 4D/PS [2026-june-23]
	This:C1470.moreData.barcodeData:=String:C10(cs:C1710.Util_ScannerManager.me.getBarcodeData(Form:C1466.sfw.entry.dataclass); "0000000000")
