$form:=New object:C1471
$form.date:=Form:C1466.startDate
OBJECT GET COORDINATES:C663(*; "pup_startDate"; $left; $top; $rigth; $bottom)
CONVERT COORDINATES:C1365($left; $bottom; XY Current form:K27:5; XY Main window:K27:8)
Open window:C153($left; $bottom; $left+285; $bottom+210; Pop up form window:K39:11; "calendar")
DIALOG:C40("_ga_calendar"; $form)
Form:C1466.startDate:=$form.calendar.display.date
OBJECT SET TITLE:C194(*; "pup_startDate"; String:C10(Form:C1466.startDate))
Form:C1466.interval:=String:C10(Form:C1466.endDate-Form:C1466.startDate)




