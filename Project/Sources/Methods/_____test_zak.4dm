//%attributes = {}
C_COLLECTION:C1488($customers)
C_LONGINT:C283($randomIndex)

$customers:=ds:C1482.PurchaseOrder.all().toCollection()
$jobs:=ds:C1482.Job.all()

For each ($job; $jobs)
	
	$randomIndex:=(Random:C100%$customers.length)
	$job.UUID_PurchaseOrder:=$customers[$randomIndex].UUID
	
	$job.save()
	
End for each 