//%attributes = {}
/*
_ga_createBarcodeDataOnAllTables

*/



C_TEXT:C284($XmlCatalog; $catalogPath; $elementTosearch; $Xmlelement; $name_Nto1; $name_1toN)


$catalogPath:=Folder:C1567(fk database folder:K87:14).platformPath+"Project"+Folder separator:K24:12+"Sources"+Folder separator:K24:12+"catalog.4DCatalog"  //); fk platform path).platformPath

$elementTosearch:="table"

//PaRse Catalog File
$XmlCatalog:=DOM Parse XML source:C719($catalogPath)

$totalTables:=DOM Count XML elements:C726($XmlCatalog; $elementTosearch)

For ($i; 1; $totalTables)  //Loop on all tables
	
	$fieldFind:=False:C215
	
	$targetedElement:=$elementTosearch+"["+String:C10($i)+"]"
	
	$tableNode:=DOM Find XML element:C864($XmlCatalog; $targetedElement)
	
	DOM GET XML ATTRIBUTE BY NAME:C728($tableNode; "name"; $tableName)
	
	$targetedChildToSearch:="field"
	
	$totalfields:=DOM Count XML elements:C726($tableNode; $targetedChildToSearch)
	
	For ($j; 1; $totalfields)  //Loop on on all fields of the current table and search for "barcodeData"
		
		$targetedChildElement:=$targetedChildToSearch+"["+String:C10($j)+"]"
		
		$field:=DOM Find XML element:C864($tableNode; $targetedChildElement)
		
		DOM GET XML ATTRIBUTE BY NAME:C728($field; "name"; $fieldName)
		
		If ($fieldName="moreData")
			
			$fieldFind:=True:C214
			
		End if 
		
	End for 
	$UUID:=Generate UUID:C1066
	If (Not:C34($fieldFind))  // If not found the create it
		
		
		$name:="moreData"
		$uuid:=Generate UUID:C1066  //"EBF096AA221543D59956F8268859F11F"
		$id:=8
		$vxPath:="base/table/field["+String:C10($j)+"]"
		
		// 1. Création de l'élément 'field' sous le nœud table parent ($tableRef)
		$fieldRef:=DOM Create XML element:C865($tableNode; $vxPath)  //; "field")
		
		// 2. Ajout de chaque attribut tel qu'ils apparaissent dans votre extrait
		DOM SET XML ATTRIBUTE:C866($fieldRef; "name"; $name)
		DOM SET XML ATTRIBUTE:C866($fieldRef; "uuid"; $uuid)
		DOM SET XML ATTRIBUTE:C866($fieldRef; "type"; "21")  // Type Objet
		DOM SET XML ATTRIBUTE:C866($fieldRef; "blob_switch_size"; "2147483647")
		DOM SET XML ATTRIBUTE:C866($fieldRef; "never_null"; "true")
		//DOM SET XML ATTRIBUTE($fieldRef; "id"; String($id))
		
		//DOM Append XML element($tableNode; $fieldRef)
		
	End if 
	
	
	
	//DOM GET XML ATTRIBUTE BY NAME($XmlElement; "name_Nto1"; $name_Nto1)
	
	//DOM GET XML ATTRIBUTE BY NAME($XmlElement; "name_1toN"; $name_1toN)
	
	//If ($name_Nto1="@_id_added_by_converter") & ($name_1toN="id_added_by_converter_@")
	
	//DOM REMOVE XML ELEMENT($XmlElement)
	
	//$i:=$i-1
	//End if 
	
	//End if 
*/
End for 

DOM EXPORT TO FILE:C862($XmlCatalog; $catalogPath)



