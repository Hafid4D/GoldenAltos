singleton Class constructor
	
	This:C1470.serverSMTP:=cs:C1710.sfw_definition.me.globalParameters.serverSMTP
	This:C1470.serverSMTP.logFile:="LogTest.txt"  //Extended log to save in the Logs folder
	
	This:C1470.SMTP_transporter:=SMTP New transporter:C1608(This:C1470.serverSMTP)
	
	This:C1470.launch()
	
	
Function launch()
	
	ds:C1482.sfw_fireAndForgetFormula(Formula:C1597(cs:C1710.sfw_EMailManager.me.worker()); "sfw_eMail_manager")
	
	
Function worker()
	var $uuids : Collection
	var $uuid : Text
	
	$uuids:=ds:C1482.sfw_EMailQueue.all().orderBy("stmpEntranceInQueue").extract("UUID")
	For each ($uuid; $uuids)
		This:C1470._sendItemInQueue($uuid)
	End for each 
	
	
	
Function _sendItemInQueue($uuid : Text)
	var $eEMailQueue : cs:C1710.sfw_EMailQueueEntity
	
	$eEMailQueue:=ds:C1482.sfw_EMailQueue.get($uuid)
	
	$status:=This:C1470.SMTP_transporter.send($eEMailQueue.mailData)
	If (Not:C34($status.success))
		ALERT:C41("An error occurred sending the mail: "+$status.message)
	End if 
	
	
	
Function sendAnEMail($mailData : Object; $extraData : Object)
	var $eEMailQueue : cs:C1710.sfw_EMailQueueEntity
	
	$eEMailQueue:=ds:C1482.sfw_EMailLog.new()
	$eEMailQueue.UUID:=Generate UUID:C1066
	$eEMailQueue.stmpEntranceInQueue:=cs:C1710.sfw_stmp.me.now()
	$eEMailQueue.mailData:=$mailData
	$eEMailQueue.extraData:=$extraData || New object:C1471
	$info:=$eEMailQueue.save()
	
	This:C1470.launch()
	
	
	