//%attributes = {}

_ga_createMoreDataFields

__import_quote_param
__import_lead_param
__import_data_lists
// Purpose: AR import chain — Customer before PO/Invoice; Invoice+JobInvoice before SalesTransaction build.
// modified by 4D/PS [2026-june-08]
__import_data_customer
//__import_data_employees
__import_teams
__import_purchaseOrders
__import_data_salesTransaction
//__import_data_archivedJobs
__import_data_equipment
__import_country
__import_data_CIP

__import_data_avl_aml
__import_data_quote
__import_data_audit
__import_data_managementReview
// Purpose: AP import chain — CAO before bills; Bank before Checks; apFinalize links credits/checks; GL via journalEntry later in this method.
// modified by 4D/PS [2026-june-29]
__import_data_chartOfAccount
__import_data_buyingOrders
__import_data_bank
__import_data_check
__import_data_supplierCredit
__import_data_expense
__import_data_billPayment
// Purpose: Resolve check bank GL and supplier-credit bill links after all AP tables are loaded.
// modified by 4D/PS [2026-june-29]
__import_data_apFinalize
__import_data_assetList
__import_data_creditMemo
__import_data_deposit
__import_data_journalEntry
__import_data_financialReport

_ga_fillBarcodeDataField

ALERT:C41("Import done")

