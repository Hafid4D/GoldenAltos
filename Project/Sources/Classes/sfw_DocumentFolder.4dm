Class extends DataClass


Function getAndCreateIfNotExist($ident : Text; $name : Text;  ...  : Text)->$eFolder : cs:C1710.sfw_DocumentFolderEntity
	var $eParentFolder : cs:C1710.sfw_DocumentFolderEntity
	
	If (Application type:C494#4D Remote mode:K5:5)
		$eFolder:=ds:C1482.sfw_DocumentFolder.query("ident = :1"; $ident).first()
		If ($eFolder=Null:C1517)
			$eFolder:=This:C1470.new()
			$eFolder.UUID:=Generate UUID:C1066
			$eFolder.ident:=$ident
			$eFolder.name:=$name
			$eFolder.moreData:=New object:C1471
			
			For ($p; 3; Count parameters:C259)
				$params:=Split string:C1554(${$p}; ":")
				$selector:=$params.shift()
				Case of 
					: ($selector="subFolderOf")
						$eParentFolder:=ds:C1482.sfw_DocumentFolder.query("ident = :1"; $params[0]).first()
						If ($eParentFolder#Null:C1517)
							$eFolder.UUID_ParentFolder:=$eParentFolder.UUID
						End if 
				End case 
			End for 
			$info:=$eFolder.save()
			
		End if 
	End if 