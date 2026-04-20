//%attributes = {}
//C_COLLECTION($customers)
//C_LONGINT($randomIndex)

//$customers:=ds.PurchaseOrder.all().toCollection()
//$jobs:=ds.Job.all()

//For each ($job; $jobs)

//$randomIndex:=(Random%$customers.length)
//$job.UUID_PurchaseOrder:=$customers[$randomIndex].UUID

//$job.save()

//End for each 


C_LONGINT:C283($i; $index; $v1; $v2)
C_TEXT:C284($format1; $format2; $comment1; $comment2)
ARRAY TEXT:C222($formats1; 10)
ARRAY TEXT:C222($formats2; 6)

// Single value formats
$formats1{1}:="temperature needs to be ### celcius"
$formats1{2}:="pressure must reach ### bar"
$formats1{3}:="humidity level should be ### %"
$formats1{4}:="machine speed is set to ### rpm"
$formats1{5}:="cooling time is ### seconds"
$formats1{6}:="heating duration is ### minutes"
$formats1{7}:="voltage should be ### volts"
$formats1{8}:="current must not exceed ### amps"
$formats1{9}:="material thickness is ### mm"
$formats1{10}:="weight limit is ### kg"

// Multi value formats
$formats2{1}:="the process will take ### min and ### sec"
$formats2{2}:="dimensions are ### mm height and ### mm width"
$formats2{3}:="mixing requires ### sec at ### rpm"
$formats2{4}:="temperature rises from ### to ### celcius"
$formats2{5}:="cycle runs for ### hours and ### minutes"
$formats2{6}:="pressure varies between ### and ### bar"

ALL RECORDS:C47([LotStep:5])

// Loop through each record
For ($i; 1; Records in selection:C76([LotStep:5]))
	GOTO RECORD:C242([LotStep:5]; $i)
	// Pick random formats
	$format1:=$formats1{Random:C100%10+1}
	$format2:=$formats2{Random:C100%6+1}
	
	[LotStep:5]commentFormat1:23:=$format1
	[LotStep:5]commentFormat2:24:=$format2
	
	// Generate random values
	$v1:=Random:C100%898+100
	$v2:=Random:C100%899998+100000
	
	// Replace placeholders
	$comment1:=Replace string:C233($format1; "###"; String:C10($v1))
	
	$comment2:=Replace string:C233($format2; "###"; String:C10($v1))
	$comment2:=Replace string:C233($comment2; "###"; String:C10($v2))
	
	// Assign comments
	//[LotStep]commentFormat1:=$format1
	//[LotStep]commentFormat2:=$format2
	[LotStep:5]comment1:21:=String:C10($v1)
	[LotStep:5]comment2:22:=String:C10($v2)
	
	SAVE RECORD:C53([LotStep:5])
	
End for 