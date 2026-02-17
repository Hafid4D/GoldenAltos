//%attributes = {}


$data:=ds:C1482.CreditMemo.all().extract("cmNum").distinct()

$po:=ds:C1482.PurchaseOrder.query("oldPoNumber =:1"; "4513841818")

$jobs:=ds:C1482.Job.query("jobNumber =:1"; 1664)

$poLines:=ds:C1482.PurchaseOrderLine.all()
$invoiceNum:=725
$invoices:=ds:C1482.Invoice.all().extract("invoice").orderBy(ck ascending:K85:9)
$invoice:=ds:C1482.Invoice.query("invoice = :1"; String:C10(1502))
//SET TEXT TO PASTEBOARD($invoices.join("\n"))



