//%attributes = {}


$data:=ds:C1482.CreditMemo.all().extract("cmNum").distinct()

$po:=ds:C1482.PurchaseOrder.query("oldPoNumber =:1"; "PO00153588")

$jobs:=ds:C1482.Job.query("jobNumber =:1"; 319)

