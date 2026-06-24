//var $rowHeight; $buttonBarHeight; $wantedWidth; $wantedHeight : Integer
//var $maxLabelLen; $minWidth; $maxWidth; $maxHeight : Integer
//var $item : Object

Case of 
	: (Form event code:C388=On Load:K2:1)
		
		
		If (Form:C1466.options=Null:C1517)
			Form:C1466.options:=New collection:C1472
		End if 
		If (Form:C1466.choice=Null:C1517)
			Form:C1466.choice:=""
		End if 
		
		If (Form:C1466.allowCreate=True:C214)
			OBJECT SET VISIBLE:C603(*; "btn_createSublevel"; True:C214)
		End if 
		
		
		// 1. Récupérer les infos de la listbox
		var $rowCount; $rowHeight; $headerHeight : Integer
		var $lbLeft; $lbTop; $lbWidth; $lbHeight : Integer
		
		$rowCount:=LISTBOX Get number of rows:C915(*; "lb_options")
		$rowHeight:=LISTBOX Get rows height:C836(*; "lb_options")
		$headerHeight:=LISTBOX Get headers height:C1144(*; "lb_options")
		
		// 2. Position actuelle de la listbox dans le formulaire
		OBJECT GET COORDINATES:C663(*; "lb_options"; $lbLeft; $lbTop; $lbWidth; $lbHeight)
		
		// 3. Hauteur exacte nécessaire pour la listbox
		var $totalLbHeight : Integer
		$totalLbHeight:=($rowCount*($rowHeight+2))  //+$headerHeight
		
		// 4. Calculer la marge fixe SOUS la listbox (boutons, padding, etc.)
		// = hauteur actuelle de la fenêtre - (position top de la listbox + hauteur actuelle de la listbox)
		var $left; $top; $w; $h : Integer
		GET WINDOW RECT:C443($left; $top; $w; $h; Current form window:C827)
		
		var $currentWinHeight : Integer
		$currentWinHeight:=$h-$top
		
		var $marginBelow : Integer
		$marginBelow:=$currentWinHeight-($lbTop+$lbHeight)
		
		// 5. Nouvelle hauteur de fenêtre = position listbox + hauteur listbox calculée + marge fixe en bas
		var $newWinHeight : Integer
		$newWinHeight:=$lbTop+$totalLbHeight  //+$marginBelow
		OBJECT SET COORDINATES:C1248(*; "lb_options"; $lbLeft; $lbTop; $lbWidth; $newWinHeight)
		
		OBJECT GET COORDINATES:C663(*; "b_accept"; $bLeft; $bTop; $bWidth; $bHeight)
		$bTop:=$newWinHeight+5
		$bHeight:=$newWinHeight+37
		OBJECT SET COORDINATES:C1248(*; "b_accept"; $bLeft; $bTop; $bWidth; $bHeight)
		
		OBJECT GET COORDINATES:C663(*; "b_cancel"; $bLeft; $bTop; $bWidth; $bHeight)
		$bTop:=$newWinHeight+5
		$bHeight:=$newWinHeight+37
		OBJECT SET COORDINATES:C1248(*; "b_cancel"; $bLeft; $bTop; $bWidth; $bHeight)
		
		// 6. Redimensionner
		RESIZE FORM WINDOW:C890(0; $newWinHeight-$lbHeight)  //$currentWinHeight)
		
		
	: (Form event code:C388=On Outside Call:K2:11) | (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
End case 
