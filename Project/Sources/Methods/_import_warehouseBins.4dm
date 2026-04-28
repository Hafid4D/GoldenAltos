//%attributes = {}

TRUNCATE TABLE:C1051([Bin:47])

var $projectFolder : 4D.Folder
var $importsFolder : 4D.Folder
var $file : 4D.File
var $data : Object
var $paths : Collection
var $path : Text
var $parts : Collection
var $idx : Integer
var $accPath : Text
var $created : Integer
var $existing : Integer
var $failed : Integer
var $seen : Object
var $bin : cs.BinEntity
var $saveResult : Object

$projectFolder:=Folder(fk database folder)
$importsFolder:=$projectFolder.folder("project/imports")
$file:=$importsFolder.file("warehouseBins_levels.json")

If (Not($file.exists))
	ALERT("Import file not found: "+$file.platformPath)
Else 
	$data:=JSON Parse($file.getText())
	$paths:=$data.paths
	
	If ($paths=Null)
		ALERT("Invalid JSON format. Missing 'paths' collection.")
	Else 
		$seen:=New object()
		$created:=0
		$existing:=0
		$failed:=0
		
		For each ($path; $paths)
			$parts:=Split string($path; "/"; sk trim spaces)
			$accPath:=""
			
			For ($idx; 0; $parts.length-1)
				If (String($parts[$idx])#"")
					$accPath:=($accPath="") ? String($parts[$idx]) : ($accPath+"/"+String($parts[$idx]))
					
					If ($seen[$accPath]=Null)
						$seen[$accPath]:=True
						
						$bin:=ds.Bin.query("binLocationPath = :1"; $accPath).first()
						If ($bin=Null)
							$bin:=ds.Bin.new()
							$bin.binLocationPath:=$accPath
							$bin.isEmpty:=True
							$saveResult:=$bin.save()
							
							If ($saveResult.success)
								$created:=$created+1
							Else 
								$failed:=$failed+1
							End if 
						Else 
							$existing:=$existing+1
						End if 
					End if 
				End if 
			End for 
		End for each 
		
		// Refresh shared cache used by the bin picker utility.
		If (Storage#Null)
			If (Storage.cache#Null)
				Use (Storage.cache)
					Storage.cache.bins:=Null
				End use 
			End if 
		End if 
		ds.Bin.cacheLoad()
		
		ALERT("Warehouse bins import termine - created: "+String($created)+" | existing: "+String($existing)+" | failed: "+String($failed))
	End if 
End if 
