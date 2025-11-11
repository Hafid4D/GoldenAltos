// cs.jobDataExporter class declaration 

property filePath : Text
property fields : Collection:=New collection:C1472()
property area : Text
property result : Object
property jobs : cs:C1710.JobSelection
property fileName : Text

Class constructor($path : Text; $fields : Collection; $jobs : cs:C1710.JobSelection; $fileName : Text)
	This:C1470.filePath:=$path
	This:C1470.fields:=$fields
	This:C1470.jobs:=$jobs
	This:C1470.fileName:=$fileName
	
	// This function will be called on each event of the offscreen area 
Function onEvent()
	Case of 
		: (FORM Event:C1606.code=On VP Ready:K2:59)
			//$o:=New object
			$excelOptions:={}  //New object("includeStyles"; True; "includeFormulas"; True)
			$excelOptions.includeBindingSource:=False:C215
			$excelOptions.includeStyles:=True:C214
			$excelOptions.includeFormulas:=True:C214
			$excelOptions.saveAsView:=False:C215
			$excelOptions.rowHeadersAsFrozenColumns:=False:C215
			$excelOptions.columnHeadersAsFrozenRows:=False:C215
			$excelOptions.includeAutoMergedCells:=True:C214
			$excelOptions.includeCalcModelCache:=False:C215
			$excelOptions.includeUnusedNames:=True:C214
			$excelOptions.includeEmptyRegionCells:=True:C214
			VP IMPORT DOCUMENT(This:C1470.area; This:C1470.filePath; {excelOptions: $excelOptions})
			
			$row:=2
			$col:=0
			
			//Export data
			
			For each ($job; This:C1470.jobs)
				//VP INSERT ROWS(VP Row(This.area; $row; 1))
				For each ($field; This:C1470.fields)
					Case of 
							
						: ($field="postToPO") | ($field="shipped")
							$content:=$job[$field]=False:C215 ? "N" : "Y"
							VP SET TEXT VALUE(VP Cell(This:C1470.area; $col; $row); $content)
							
						Else 
							VP SET TEXT VALUE(VP Cell(This:C1470.area; $col; $row); String:C10($job[$field]))
							
					End case 
					$col:=$col+1
				End for each 
				$row:=$row+1
				$col:=0
				VP INSERT ROWS(VP Row(This:C1470.area; $row; 1))
			End for each 
			
			//$title:=
			$folderPath:=Get 4D folder:C485(Current resources folder:K5:16)+"exportedData"
			$fileName:=Split string:C1554(This:C1470.fileName; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2).join("")+".xls"
			$file:=Folder:C1567(Convert path system to POSIX:C1106($folderPath)).file($fileName)
			
			If (Not:C34($file.exists))
				$file.create()
			End if 
			$option:=New object:C1471("format"; vk MS Excel format:K89:2)
			VP EXPORT DOCUMENT(This:C1470.area; $file.platformPath; $option)
			
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")
			SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_HIDE_CONSOLE"; "true")
			LAUNCH EXTERNAL PROCESS:C811("cmd.exe /C  start \"\" \""+$file.platformPath+"\"")
	End case 
	
	
	
	
	
	
	
	