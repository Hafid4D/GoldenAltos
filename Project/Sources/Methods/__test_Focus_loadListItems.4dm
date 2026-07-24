// Purpose: Copy all items from a named 4D List into a runtime list ref for Form.lbList.
// Parameters:
// $listName : Text — 4D List resource name (empty = built-in sample rows for UI test)
// $targetList : Integer — list ref to fill (typically Form.lbList)
// created by 4D/PS [2026-july-08]

#DECLARE($listName : Text; $targetList : Integer)

ARRAY TEXT:C222($items; 0)
ARRAY LONGINT:C221($refs; 0)
var $i : Integer

If ($listName#"")
	LIST TO ARRAY:C288($listName; $items; $refs)
	If (Size of array:C274($items)>0)
		For ($i; 1; Size of array:C274($items))
			APPEND TO LIST:C376($targetList; $items{$i}; $refs{$i})
		End for 
	End if 
End if 

If (List size:C277($targetList)=0)
	// Purpose: Fallback sample data when no project List exists (matches legacy Programs picker layout).
	// modified by 4D/PS [2026-july-08]
	APPEND TO LIST:C376($targetList; "01-ArtisanPAK"; 1)
	APPEND TO LIST:C376($targetList; "07-Land Improvement"; 2)
	APPEND TO LIST:C376($targetList; "10-Bowling Centers"; 3)
	APPEND TO LIST:C376($targetList; "12-NALP"; 4)
End if 
