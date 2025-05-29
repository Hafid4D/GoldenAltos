Class extends DataClass


local Function getAndCreateIfNotExist($ident : Text; $name : Text;  ...  : Text)->$eProfil : cs:C1710.sfw_UserProfileEntity
	
	If (Application type:C494#4D Remote mode:K5:5)
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
	End if 
	
	
	
	
local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("profile"; "userManagement"; "Profiles")
	$entry.setXliffLabel("profile.profiles")
	$entry.setDataclass("sfw_UserProfile")
	
	$entry.setIcon("sfw/entry/profile-50x50.png")
	
	$entry.setSearchboxField("ident")
	
	$entry.setPanel("sfw_panel_profile")
	
	$entry.setLBItemsColumn("ident"; "Identifier"; "width:65"; "xliff:profile.field.ident")
	$entry.setLBItemsColumn("name"; "Name"; "xliff:profile.field.name")
	
	$entry.setLBItemsOrderBy("ident")
	
	$entry.setLBItemsCounter("###0###0##0^1;;"; "unit1: profile"; "unitN: profiles")
	
	$entry.setAddable("hiddenLineInModeMenu")
	
	$entry.setAllowedProfiles(cs:C1710.sfw_globalParameters.me.userVision.entryProfile.allowedProfiles || "admin")