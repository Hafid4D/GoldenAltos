//%attributes = {}
#DECLARE($defintionClassName : Text)


Use (Storage:C1525)
	Storage:C1525.definitionClass:=New shared object:C1526("name"; $defintionClassName)
End use 

cs:C1710.sfw_userManager.me.login()

ds:C1482.dataMaintenance()

cs:C1710.sfw_userManager.me.onStartup()
cs:C1710.sfw_notificationManager.me.onStartup()

sfw_cs_register_client
sfw_toolbar_launch
sfw_scheduler_delayedLaunch