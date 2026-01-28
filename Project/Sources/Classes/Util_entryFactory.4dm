
Class constructor
	// Dossier racine du projet
	This:C1470.projectFolder:=Folder:C1567(fk database folder:K87:14)
	This:C1470.sources:=This:C1470.projectFolder.folder("Sources")
	
/**
    Génère l'entrée complète pour une table
*/
Function buildEntry($tableName : Text; $moduleName : Text)
	
	var $dataclass : cs:C1710.sfw_definitionEntry
	
	// 1. Créer les dossiers nécessaires
	This:C1470.sources.folder("Classes").create()
	This:C1470.sources.folder("Forms").folder("panel_"+Lowercase:C14($tableName)).create()
	
	// 2. Générer les fichiers .4dm (Classes)
	This:C1470.generateDataClass($tableName; $moduleName)
	This:C1470.generateEntity($tableName)
	This:C1470.generatePanelClass($tableName)
	
	// 3. Générer le JSON du formulaire
	This:C1470.generateFormJson($tableName)
	
	// 4. Rafraîchir l'IDE
	RELOAD PROJECT:C1739
	
/**
    Génère la classe DataClass avec la définition de l'entrée
*/
Function generateDataClass($tableName : Text; $moduleName : Text)
	var $code : Text
	var $file : 4D:C1709.File
	
	$file:=This:C1470.sources.folder("Classes").file($tableName+".4dm")
	
	$code:="Class extends DataClass\n\n"
	$code+="Function entryDefinition()->$entry : cs.sfw_definitionEntry\n"
	$code+="\t$entry:=cs.sfw_definitionEntry.new(\""+$tableName+"\"; [\""+$moduleName+"\"]; \"icon\")\n"
	$code+="\t$entry.setDataclass(\""+$tableName+"\")\n"
	$code+="\t$entry.setPanel(\"panel_"+Lowercase:C14($tableName)+"\")\n"
	
	// Auto-détection des colonnes (exemple simplifié)
	var $attrs : Collection
	$attrs:=ds:C1482[$tableName].getInfo().attributes.query("kind = 'storage'")
	For each ($attr; $attrs)
		If ($attr.type="text")
			$code+="\t$entry.setLBItemsColumn(\""+$attr.name+"\"; \""+$attr.name+"\"; \"width:150\")\n"
		End if 
	End for each 
	
	$code+="\treturn $entry"
	$file.setText($code)
	
/**
    Génère le fichier form.json pour le panel
*/
Function generateFormJson($tableName : Text)
	var $form : Object
	var $file : 4D:C1709.File
	
	$file:=This:C1470.sources.folder("Forms").folder("panel_"+Lowercase:C14($tableName)).file("form.json")
	
	// Structure minimale d'un formulaire 4D
	$form:=New object:C1471("pages"; New collection:C1472(New object:C1471("objects"; New object:C1471)))
	
	// Le crawler peut ici ajouter les champs dynamiquement
	$attrs:=ds:C1482[$tableName].getInfo().attributes.query("kind = 'storage'")
	var $y : Integer:=20
	
	For each ($attr; $attrs)
		$form.pages[0].objects["label_"+$attr.name]:=New object:C1471(\
			"type"; "text"; "text"; $attr.name+":"; \
			"left"; 20; "top"; $y; "width"; 100; "height"; 20)
		
		$form.pages[0].objects["input_"+$attr.name]:=New object:C1471(\
			"type"; "input"; \
			"dataSource"; "Form.current_item."+$attr.name; \
			"left"; 130; "top"; $y; "width"; 250; "height"; 20)
		$y:=$y+30
	End for each 
	
	$file.setText(JSON Stringify:C1217($form; *))
	