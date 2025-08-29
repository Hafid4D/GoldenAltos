Class extends Entity

local Function get nameInWindowTitle()->$nameInWindowTitle : Text
	$nameInWindowTitle:=This:C1470.name
	
local Function _initSettings()
	LIST TO ARRAY:C288("StepProperty"; $arr_list)
	
	This:C1470.settings:=New object:C1471("properties"; New collection:C1472())
	
	For ($i; 1; Size of array:C274($arr_list))
		$property:=New object:C1471(\
			"name"; $arr_list{$i}; \
			"checked"; False:C215\
			)
		
		If ($arr_list{$i}="@QA signoff is required@")
			$property.profileRequired:="qa"
		End if 
		
		This:C1470.settings.properties.push($property)
	End for 
	
local Function loadAfterCreation()
	// This callback is called after creating the new item but before displaying the panel.
	This:C1470._initSettings()
	This:C1470.templateNumber:=ds:C1482.StepTemplate.all().max("templateNumber")+1
	