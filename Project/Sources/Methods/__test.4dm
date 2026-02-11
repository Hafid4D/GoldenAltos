//%attributes = {}


$data:=ds:C1482.CreditMemo.all().extract("cmNum").distinct()

$po:=ds:C1482.PurchaseOrder.query("oldPoNumber =:1"; "Credit Card1")

$jobs:=ds:C1482.Job.all()  //query("jobNumber =:1"; 378)

$poLines:=ds:C1482.PurchaseOrderLine.all()

$file:=Folder:C1567(fk data folder:K87:12).file("DataJson/job_log_export.json")

$records:=JSON Parse:C1218($file.getText())



