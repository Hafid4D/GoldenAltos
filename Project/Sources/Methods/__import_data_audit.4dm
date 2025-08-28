//%attributes = {}


//Audit
var $eAudit : cs:C1710.AuditEntity

$audit_log:=Folder:C1567(fk data folder:K87:12).file("DataJson/log_book_export.json")

If ($audit_log.exists)
	$audits:=JSON Parse:C1218($audit_log.getText())
	
	TRUNCATE TABLE:C1051([Audit:44])
	
	$docs:=Folder:C1567(fk data folder:K87:12).file("DataJson/docServerIndex_export.json")
	$count:=0
	If ($docs.exists)
		
		$documents:=JSON Parse:C1218($docs.getText()).query("TableNumber=:1"; 39)
		
	End if 
	
	
	For each ($audit; $audits)
		
		$eAudit:=ds:C1482.Audit.new()
		//$eAudit.page:=$audit.Page
		$eAudit.stmpPage:=cs:C1710.sfw_stmp.me.build(Date:C102($audit.Page_Date))
		$eAudit.supervisor:=$audit.Supervisor
		$eAudit.dateTimeStamp:=$audit.DateTimeStamp
		$eAudit.stmpCreationDate:=$audit.CreationDateTimeStamp
		$eAudit.title:=$audit.LogTitle
		$eAudit.storageFilename:=$audit.StoragedFilename
		$eAudit.book:=$audit.Book
		
		
		$_documents:=$documents.query("PrimaryKeyValue=:1"; String:C10($audit.Page))
		
		$eAudit.attachedDocuments:=New object:C1471()
		$eAudit.attachedDocuments.documents:=New collection:C1472()
		
		For each ($document; $_documents)
			$doc:=New object:C1471
			
			$doc.code:=$document.DocCode
			$doc.dateTimeStamp:=$document.DateTimeStamp
			$doc.creationDateTimeStamp:=$document.CreationDateTimeStamp
			$doc.documentPath:=$document.DocumentPath
			$doc.sourcePath:=$document.SourcePath
			$doc.description:=$document.DocDescription
			$doc.approvalDate:=!00-00-00!
			$doc.approvedBy:=""
			$doc.isApproved:=False:C215
			
			
			$report:=Folder:C1567(fk data folder:K87:12).file("DataJson/LogBookDocs/"+String:C10($document.UniqueID+$document.PrimaryKeyValue))
			If ($report.exists)
				
				C_BLOB:C604($blob)
				DOCUMENT TO BLOB:C525($report.platformPath; $blob)
				
				$doc.blob:=$blob
				
			End if 
			
			$eAudit.attachedDocuments.documents.push($doc)
			
		End for each 
		
		$res:=$eAudit.save()
		If (Not:C34($res.success))
			TRACE:C157
		End if 
		
	End for each 
	
End if 
