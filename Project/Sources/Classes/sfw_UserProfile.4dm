Class extends DataClass


Function getAndCreateIfNotExist($ident : Text; $name : Text;  ...  : Text)->$eProfil : cs:C1710.sfw_UserProfileEntity
	
	$eProfil:=This:C1470.query("ident = :1"; $ident).first()
	If ($eProfil=Null:C1517)
		$eProfil:=This:C1470.new()
		$eProfil.UUID:=Generate UUID:C1066
		$eProfil.ident:=$ident
		$eProfil.name:=$name
		$eProfil.moreData:=New object:C1471
		For ($i; 3; Count parameters:C259)
			$param:=${$i}
			Case of 
				: ($param="autoCreation")
					$eProfil.moreData.autoCreation:=cs:C1710.sfw_stmp.me.now()
			End case 
		End for 
		$info:=$eProfil.save()
	End if 
	
	