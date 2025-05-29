Class extends DataClass

local Function entryDefinition()->$entry : cs:C1710.sfw_definitionEntry
	
	$entry:=cs:C1710.sfw_definitionEntry.new("emailTemplate"; "administration"; "Email templates")
	$entry.setXliffLabel("emailtemplate.title")
	$entry.setDataclass("sfw_EmailTemplate")
	$entry.setDisplayOrder(-1500)
	$entry.setIcon("image/entry/emailTemplate-50x50.png")
	
	$entry.setSearchboxField("ident")
	$entry.setSearchboxField("name")
	
	$entry.setPanel("panel_emailTemplate")
	$entry.setPanelPage(1; "description-32x32.png"; "Exemples")
	
	$entry.setLBItemsColumn("ident"; "Identifier"; "xliff:emailtemplate.field.ident"; "width:80")
	$entry.setLBItemsColumn("name"; "Name"; "xliff:emailtemplate.field.name"; "width:200")
	$entry.setLBItemsColumn("subject"; "Subject"; "xliff:emailtemplate.field.subject"; "width:200")
	
	$entry.setLBItemsOrderBy("ident")
	
	$entry.setLBItemsCounter("###,###,##0 ^1;;"; "unit1:email template"; "unitN:email templates")
	$entry.setValidationRule("ident"; "entryField_ident"; "mandatory"; "trimSpace")
	$entry.setValidationRule("name"; "entryField_name"; "mandatory"; "trimSpace"; "capitalize")
	$entry.setValidationRule("subject"; "entryField_subject"; "mandatory"; "trimSpace"; "capitalize")
	
	
	$entry.setItemListPreconfigAction("exportReferenceRecords")
	$entry.setItemListPreconfigAction("importReferenceRecords")
	$entry.setItemListPreconfigAction("copyItemsListToPasteboard")
	
	
Function prepareEmail($templateIdent : Text; $dataContext : Object)->$email : Object
	var $emailBody : Text
	var $emailMime : Object
	$email:=New object:C1471
	
	$emailTemplate:=ds:C1482.sfw_EmailTemplate.query("ident = :1"; $templateIdent).first()
	If ($emailTemplate#Null:C1517)
		
		$wpDoc:=WP New:C1317($emailTemplate.descriptionWP)
		WP SET DATA CONTEXT:C1786($wpDoc; $dataContext)
		WP EXPORT VARIABLE:C1319($wpDoc; $emailBody; wk mime html:K81:1)
		
		$emailMime:=MAIL Convert from MIME:C1681($emailBody)
		
		$email.body:=New object:C1471
		$email.body.content:=""
		For each ($part; $emailMime.bodyValues)
			$email.body.content+=$emailMime.bodyValues[$part].value
		End for each 
		$email.body.contentType:="HTML"  // or HTML
		
		$email.subject:=$emailTemplate.subject
	End if 