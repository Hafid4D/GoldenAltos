

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		Form:C1466.listbox:=New collection:C1472(New object:C1471("nom"; "Alice"; "age"; 30); New object:C1471("nom"; "Bob"; "age"; 25); \
			New object:C1471("nom"; "Medard"; "age"; 29); New object:C1471("nom"; "Angele"; "age"; 26))
		
		
		$listboxName:="listbox"
		cs:C1710.Util_DynamicListBox.me.deleteAllColumns($listboxName)
		
		$colSettings:=New collection:C1472(\
			New object:C1471("field"; "nom"; "title"; "User Name"; "minWidth"; 150; "maxWidth"; 250); \
			New object:C1471("field"; "age"; "title"; "User Age"; "minWidth"; 150; "maxWidth"; 250)\
			)
		cs:C1710.Util_DynamicListBox.me.insertColumns($listboxName; $colSettings)
		
		//$colSettings:=New object("field"; "nom"; "title"; "User Name"; "minWidth"; 150; "maxWidth"; 250)
		//cs.Util_ListBox.me.insertColumn($listboxName; $colSettings)
		
		//$colSettings:=New object("field"; "age"; "title"; "User Age"; "minWidth"; 150; "maxWidth"; 250)
		//cs.Util_ListBox.me.insertColumn($listboxName; $colSettings)
		
		////OBJECT SET DATA SOURCE(*; "listbox"; ->Form.maCollection)
		//var HeaderVarName; $Last : Integer
		//$last:=LISTBOX Get number of columns(*; "listbox")+1
		
		////First column
		//$colFormula:="This.nom"
		//LISTBOX INSERT COLUMN FORMULA(*; "listbox"; $last; "col_test"; "This.nom"; Is text; "HeaderName"; HeaderVarName)
		//OBJECT SET TITLE(*; "HeaderName"; "Test Header")
		//LISTBOX SET COLUMN WIDTH(*; "listbox"; 100; 200)
		//OBJECT SET FONT STYLE(*; "HeaderName"; Bold)
		
		//// Boucle ou série d'insertions pour vos colonnes dynamiques
		//LISTBOX INSERT COLUMN FORMULA(*; "LB_Generique"; 1; "Col1"; "This.id"; Is longint; "H1"; ->[])
		//OBJECT SET TITLE(*; "H1"; "ID")
		//OBJECT SET WIDTH(*; "Col1"; 50)
		
		//LISTBOX INSERT COLUMN FORMULA(*; "LB_Generique"; 2; "Col2"; "This.libelle"; Is text; "H2"; ->[])
		//OBJECT SET TITLE(*; "H2"; "Désignation")
		//OBJECT SET WIDTH(*; "Col2"; 250)
		
	Else 
		
End case 

