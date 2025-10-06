//%attributes = {"executedOnServer":true}
/*
_ga_dateRelatedNotifications

*/

var $equipments : cs:C1710.EquipmentSelection


/*
Equipment out of calibration in 30 days Notifications
*/
$equipments:=ds:C1482.Equipment.query("nextCalDate<=:1 & notAtSite=:2"; Current date:C33(*)+30; False:C215)
_ga_equipmentNotification(->$equipments; "soonDueCal"; "EquipmentSoonDueCalibration")

/*
Due Equipment out of calibration
*/
$equipments:=ds:C1482.Equipment.query("nextCalDate<=:1 & calibrationNotRequired=:2 & notAtSite=:3"; Current date:C33(*); False:C215; False:C215)
_ga_equipmentNotification(->$equipments; "dueCal"; "DueEquipmentOutOfCalibration")


/*
Equipment out of PM in 30 days
*/
$equipments:=ds:C1482.Equipment.query("nextPMDate<=:1 & nextPMDate#:2 & notAtSite=:3"; Current date:C33(*)+30; !00-00-00!; False:C215)
_ga_equipmentNotification(->$equipments; "soonDuePM"; "EquipmentSoonDuePM")


/*
Due Equipment out of PM Notification
*/
$equipments:=ds:C1482.Equipment.query("nextPMDate<=:1 & nextPMDate#:2 & notAtSite=:3"; Current date:C33(*); !00-00-00!; False:C215)
_ga_equipmentNotification(->$equipments; "duePM"; "DueEquipmentOutOfPM")

/*
Employees requiring retraining in the next 30 days
*/
var $staffs : cs:C1710.StaffRoleSelection
$staffs:=ds:C1482.Equipment.query("retrainDate<=:1 & retrainDate#:2"; Current date:C33(*)+30; !00-00-00!)
_ga_equipmentNotification(->$equipments; "retrainNotified"; "EmployeeRetrainRequired")
