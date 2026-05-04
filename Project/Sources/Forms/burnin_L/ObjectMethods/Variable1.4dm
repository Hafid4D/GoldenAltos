// Purpose: Legacy object method disabled for GoldenAltos (format_date_time / legacy Lotsteps date display). The form widget no longer references this file.
// modified by 4D/PS [2026-april-27]
// format_date_time
// Case of 
// : (During)
// If ([Lotsteps]DateIn#!00/00/00!)
// sdatein:=String([Lotsteps]DateIn)+"   "+String([Lotsteps]Timein;2)
// Else 
// sdatein:=""
// End if 
// End case 
