//%attributes = {}
#DECLARE($defintionClassName : Text)

Use (Storage:C1525)
	Storage:C1525.definitionClass:=New shared object:C1526("name"; $defintionClassName)
End use 
$visions:=cs:C1710.sfw_definition.me.visions
cs:C1710.sfw_userManager.me.onStartup()
cs:C1710.sfw_notificationManager.me.onStartup()
sfw_scheduler_delayedLaunch