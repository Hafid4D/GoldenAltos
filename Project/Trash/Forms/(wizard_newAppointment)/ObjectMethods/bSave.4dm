$eSlot:=Form:C1466.current_slot.entity
$chrono:=New object:C1471
$chrono.status:=1
$chrono.date:=Current date:C33
$chrono.stmp:=cs:C1710.sfw_stmp.me.now()
$chrono.origin:=1  // C/S

$eSlot.idStatus:=1
$eSlot.chronoStatus.histo.push($chrono)
$eSlot.chronoStatus:=$eSlot.chronoStatus
OB REMOVE:C1226($eSlot.chronoStatus; "expiration")

$info:=$eSlot.save()

ACCEPT:C269
