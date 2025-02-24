singleton Class constructor
	
	//This.serverSMTP:=cs.sfw_definition.me.globalParameters.serverSMTP
	//This.serverSMTP.logFile:="LogMail.txt"  //Extended log to save in the Logs folder
	This:C1470.SMTP_object:=cs:C1710.microsoftGraphAPI.new()  //SMTP New transporter(This.serverSMTP)
	
	This:C1470.launch()
	
	
Function launch()
	
	ds:C1482.sfw_fireAndForgetFormula(Formula:C1597(cs:C1710.sfw_eMailManager.me.worker()); "sfw_eMail_manager")
	
	
Function worker()
	var $uuids : Collection
	var $uuid : Text
	
	$uuids:=ds:C1482.sfw_EMailQueue.all().orderBy("stmpEntranceInQueue").extract("UUID")
	For each ($uuid; $uuids)
		This:C1470._sendItemInQueue($uuid)
	End for each 
	
Function initEmailObject()->$email : Object
	
	$email:=New object:C1471
	
	// From
	$email.from:=New object:C1471
	$email.from.emailAddress:=New object:C1471("name"; "Kairos"; "address"; "noreply.kairos@4d.com")
	
	// To
	$addressTo:=New object:C1471
	$addressTo.emailAddress:=New object:C1471
	$addressto.emailAddress.address:="berengere.lagrange@4d.com"
	$email.toRecipients:=New collection:C1472($addressTo)
	$email.subject:="Test"
	
	$CorpsMessage:="Ceci est un test qui fonctionne depuis un service"
	$email.body:=New object:C1471()
	$email.body.content:=$CorpsMessage
	$email.body.contentType:="text"  // or HTML, 
	
Function _sendItemInQueue($uuid : Text)
	var $eEMailQueue : cs:C1710.sfw_EMailQueueEntity
	SMTP_object
	$eEMailQueue:=ds:C1482.sfw_EMailQueue.get($uuid)
	
	$status:=This:C1470.SMTP_object.sendMail($eEMailQueue.mailData)
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
	
	
	