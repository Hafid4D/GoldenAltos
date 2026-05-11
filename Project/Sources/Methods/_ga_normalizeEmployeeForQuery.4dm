//%attributes = {}
#DECLARE($param : Object)

var $employee : Object

$employee:=$param.value

$employee.Last_Name_key:=Replace string:C233(String:C10($employee.lastName); " "; "")
$employee.First_Name_key:=Replace string:C233(String:C10($employee.firstName); " "; "")

$param.result:=$employee