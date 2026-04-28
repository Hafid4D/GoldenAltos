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


//C_LONGINT($i; $index; $v1; $v2)
//C_TEXT($format1; $format2; $comment1; $comment2)
//ARRAY TEXT($formats1; 10)
//ARRAY TEXT($formats2; 6)

//// Single value formats
//$formats1{1}:="temperature needs to be ### celcius"
//$formats1{2}:="pressure must reach ### bar"
//$formats1{3}:="humidity level should be ### %"
//$formats1{4}:="machine speed is set to ### rpm"
//$formats1{5}:="cooling time is ### seconds"
//$formats1{6}:="heating duration is ### minutes"
//$formats1{7}:="voltage should be ### volts"
//$formats1{8}:="current must not exceed ### amps"
//$formats1{9}:="material thickness is ### mm"
//$formats1{10}:="weight limit is ### kg"

//// Multi value formats
//$formats2{1}:="the process will take ### min and ### sec"
//$formats2{2}:="dimensions are ### mm height and ### mm width"
//$formats2{3}:="mixing requires ### sec at ### rpm"
//$formats2{4}:="temperature rises from ### to ### celcius"
//$formats2{5}:="cycle runs for ### hours and ### minutes"
//$formats2{6}:="pressure varies between ### and ### bar"

//ALL RECORDS([LotStep])

//// Loop through each record
//For ($i; 1; Records in selection([LotStep]))
//GOTO RECORD([LotStep]; $i)
//// Pick random formats
//$format1:=$formats1{Random%10+1}
//$format2:=$formats2{Random%6+1}

//[LotStep]commentFormat1:=$format1
//[LotStep]commentFormat2:=$format2

//// Generate random values
//$v1:=Random%898+100
//$v2:=Random%899998+100000

//// Replace placeholders
//$comment1:=Replace string($format1; "###"; String($v1))

//$comment2:=Replace string($format2; "###"; String($v1))
//$comment2:=Replace string($comment2; "###"; String($v2))

//// Assign comments
////[LotStep]commentFormat1:=$format1
////[LotStep]commentFormat2:=$format2
//[LotStep]comment1:=String($v1)
//[LotStep]comment2:=String($v2)

//SAVE RECORD([LotStep])

//End for 

//C_OBJECT($bomMap)

//// Step 1: Build map (Bom_Part_Num → UUID)
//ALL RECORDS([BOM])
//While (Not(End selection([BOM])))
//OB SET($bomMap; [BOM]Bom_Part_Num; [BOM]UUID)
//NEXT RECORD([BOM])
//End while 

//// Step 2: Loop BomItem once
//ALL RECORDS([BomItem])
//While (Not(End selection([BomItem])))

//$uuid:=OB Get($bomMap; [BomItem]Bom_Part_Num)

//If ($uuid#Null)
//[BomItem]UUID_Bom:=$uuid
//SAVE RECORD([BomItem])  // 🔥 THIS WAS MISSING
//End if 

//NEXT RECORD([BomItem])
//End while 

//ALERT("Done")




























