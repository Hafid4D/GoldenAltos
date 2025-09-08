

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		var $form : Object:=New object:C1471()
		$form.hour:=cs:C1710.sfw_stmp.me.getHour(Current time:C178())
		//$form.minute:=cs.sfw_stmp.me.getNbMinutes(Current time())%60
		If ($form.hour>12)
			$form.pm:=1
			$form.am:=0
		Else 
			$form.am:=1
			$form.pm:=0
		End if 
		
		$when:=$form.am=1 ? "AM" : $form.pm=1 ? "PM" : ""
		OBJECT SET TITLE:C194(Self:C308->; String:C10(Current time:C178())+"  "+$when)
		
	: (Form event code:C388=On Clicked:K2:4)
		
		$form:=New object:C1471
		
		$form.hour:=String:C10(cs:C1710.sfw_stmp.me.getHour($form.timeStamp))
		$form.minute:=String:C10(cs:C1710.sfw_stmp.me.getNbMinutes($form.timeStamp)%60)
		
		OBJECT GET COORDINATES:C663(Self:C308->; $left; $top; $rigth; $bottom)
		
		CONVERT COORDINATES:C1365($left; $bottom; XY Current form:K27:5; XY Main window:K27:8)
		Open window:C153($left; $bottom+30; $left+237; $bottom+206; Movable dialog box:K34:7; "Enter Time")
		DIALOG:C40("_ga_TimePicker"; $form)
		
		If (OK=1)
			$time:=Time string:C180($form.timeStamp)
			Form:C1466.pm:=$form.pm
			Form:C1466.am:=$form.am
			
			$when:=Form:C1466.am=1 ? "AM" : Form:C1466.am=1 ? "PM" : ""
			OBJECT SET TITLE:C194(Self:C308->; $time+"  "+$when)
			
			
		Else 
			//cs.sfw_dialog.me.info(ds.sfw_readXliff("Info"; "End date must be greater or eaual to Start date"))
		End if 
		
		
		
	Else 
		
		
End case 