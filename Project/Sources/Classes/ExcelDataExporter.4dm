// Class to export data to excel using template

property templatePath : Text
property mapping : Collection:=New collection:C1472()
property area : Text
property entitySelection
property fileName : Text
property destinationFolderPath : Text
property autoQuit : Boolean


Class constructor($templatePath : Text; $mapping : Collection; $entitySelection; $destinationFileName : Text; $destinationFolderPath : Text)
	This:C1470.templatePath:=$templatePath
	This:C1470.mapping:=$mapping
	This:C1470.entitySelection:=$entitySelection
	This:C1470.destinationFileName:=$destinationFileName
	This:C1470.autoQuit:=False:C215
	This:C1470.destinationFolderPath:=$destinationFolderPath
	
	// This function will be called on each event of the offscreen area 
Function onEvent()
	Case of 
		: (FORM Event:C1606.code=On VP Ready:K2:59)
			
			$o:=New object:C1471()
			
			$excelOptions:={includeStyles: False:C215; includeFormulas: True:C214; openMode: ""}
			$o.excelOptions:=$excelOptions
			$o.formula:=Formula:C1597(SET TIMER:C645(30))
			VP IMPORT DOCUMENT(This:C1470.area; This:C1470.templatePath; $o)  // make an asynch callback
			
		: (Form event code:C388=On Timer:K2:25)
			
			SET TIMER:C645(0)
			
			$row:=2
			$col:=0
			
			//Headers
			For each ($header; This:C1470.mapping.extract("header"))
				VP SET TEXT VALUE(VP Cell(This:C1470.area; $col; $row); $header)
				$col:=$col+1
			End for each 
			
			// The header style
			$style:=New object:C1471
			$style.font:="bold"
			$style.backColor:="#FFFF00"
			
			VP ADD STYLESHEET(This:C1470.area; "header"; $style)
			
			VP SET CELL STYLE(VP Cells(This:C1470.area; 0; $row; $col+1; 1); New object:C1471("name"; "header"))
			
			
			$row:=$row+1
			$col:=0
			
			//Data
			For each ($entity; This:C1470.entitySelection)
				
				For each ($field; This:C1470.mapping.extract("field"))
					
					Case of 
							
						: ($field="")
							
						: (String:C10($entity[$field])="False") | (String:C10($entity[$field])="True")  //Boolean fields
							
							$content:=$entity[$field]=False:C215 ? "N" : "Y"
							VP SET TEXT VALUE(VP Cell(This:C1470.area; $col; $row); $content)
							
						Else 
							
							$linksFields:=Split string:C1554($field; "."; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
							$content:=$entity[String:C10($linksFields[0])]
							
							For ($i; 1; $linksFields.length-1)
								$content:=$content[String:C10($linksFields[$i])]
								If ($content=Null:C1517)
									$content:=""
									break
								End if 
								
							End for 
							
							If (String:C10($content)="False") | (String:C10($content)="True")
								$content:=$content=False:C215 ? "N" : "Y"
							End if 
							
							//If (Type($content)=Is integer) | (Type($content)=Is real) | (Type($content)=Is longint) | (Type($content)=Is integer 64 bits)
							VP SET VALUE(VP Cell(This:C1470.area; $col; $row); New object:C1471("value"; $content))
							//Else 
							//VP SET TEXT VALUE(VP Cell(This.area; $col; $row); String($content))
							//End if 
							
							
					End case 
					$col:=$col+1
				End for each 
				$row:=$row+1
				$col:=0
				VP INSERT ROWS(VP Row(This:C1470.area; $row; 1))
			End for each 
			
			$file:=Folder:C1567(Convert path system to POSIX:C1106(This:C1470.destinationFolderPath)).file(This:C1470.destinationFileName)
			
			If (Not:C34($file.exists))
				$file.create()
			End if 
			
			var $params:={}
			$params.format:=vk MS Excel format:K89:2
			$params.formula:=Formula:C1597(ACCEPT:C269)
			$excelOptions:={includeStyles: True:C214; includeFormulas: True:C214}
			$params.excelOptions:=$excelOptions
			VP EXPORT DOCUMENT(This:C1470.area; $file.platformPath; $params)
			
			OPEN URL:C673($file.platformPath; *)
			
	End case 
	
	
	
	
	
	
	
	
	
	