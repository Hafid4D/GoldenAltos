//%attributes = {}


$barCode:=_ga_generateBarCode(ds:C1482.Lot.all().first().lotNumber)
WRITE PICTURE FILE:C680(""; $barCode)

//$data:=ds.CreditMemo.all().extract("cmNum").distinct()

//$po:=ds.PurchaseOrder.query("oldPoNumber =:1"; "4513841818")

//$jobs:=ds.Job.query("jobNumber =:1"; 1664)

//$poLines:=ds.CAOTypeDetail.all()
//$invoiceNum:=725
//$invoices:=ds.Invoice.all().extract("invoice").orderBy(ck ascending)
//$invoice:=ds.Invoice.query("purchaseOrder.customer.name = :1"; "ALDETEC")
////SET TEXT TO PASTEBOARD($invoices.join("\n"))



