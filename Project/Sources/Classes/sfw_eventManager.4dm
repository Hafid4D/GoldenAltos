shared singleton Class constructor
	This:C1470.longtext:="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce volutpat auctor faucibus. Donec nec consectetur nunc. Sed pharetra a enim ac dignissim. Maecenas lacinia ligula vitae diam feugiat, a elementum nisl commodo. Suspendisse non eros at nunc f"+"eugiat facilisis at eget risus. Cras scelerisque nisl tellus, sit amet tempor mi semper non. Integer diam metus, finibus ac est vel, ultricies tempus nibh. Sed eget sagittis tortor. Integer ante odio, porta semper ex et, molestie aliquet quam. Phasell"+"us tincidunt, odio a congue placerat, nisl sem volutpat enim, eu pharetra leo nunc non nisl. Donec eu sagittis ipsum. Integer lacinia accumsan tempor. Vivamus mattis nisl ut dui pellentesque tincidunt. Orci varius natoque penatibus et magnis dis partu"+"rient montes, nascetur ridiculus mus. Quisque sollicitudin hendrerit diam ac posuere.\n\nDuis mattis, massa non consequat malesuada, lorem velit tincidunt nunc, nec ultricies nunc sapien vel nunc. Cras sed rhoncus metus, vitae lobortis libero. Fusce vol"+"utpat quis nunc in tincidunt. Aenean consectetur nibh et metus placerat tempus et vitae augue. Vestibulum eu elit ut sem euismod maximus eget rhoncus lacus. Nulla venenatis, dui id pretium consequat, libero ex dapibus neque, in hendrerit arcu odio id "+"est. Mauris eu magna ut est imperdiet hendrerit ac vitae ante. Nulla facilisi. Praesent euismod cursus facilisis. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nulla ullamcorper vitae turpis sit amet elementum"+"."
	
	This:C1470.window:=0
	This:C1470.events:=New shared object:C1526
	This:C1470._init()
	This:C1470.collapsedYears:=New shared collection:C1527
	This:C1470.collapsedMonths:=New shared collection:C1527
	This:C1470.expandedEvents:=New shared collection:C1527
	
shared Function createIfNotExist($ident : Text; $label : Text)
	var $eEventType : cs:C1710.sfw_EventTypeEntity
	If (This:C1470.events[$ident]=Null:C1517)
		$eEventType:=ds:C1482.sfw_EventType.query("ident = :1"; $ident).first()
		If ($eEventType=Null:C1517)
			CALL WORKER:C1389("sfw_event_worker"; Formula:C1597(cs:C1710.sfw_eventManager.me._createEventType($1; $2)); $ident; $label)
		Else 
			This:C1470.events[$ident]:=OB Copy:C1225($eEventType.toObject(); ck shared:K85:29)
		End if 
	End if 
	
	
shared Function _init()
	
	This:C1470.createIfNotExist("createRecord"; "Create the record")
	This:C1470.createIfNotExist("modifRecord"; "Modify the record")
	This:C1470.createIfNotExist("duplicateRecord"; "Duplicate the record")
	
	
shared Function _createEventType($ident : Text; $label : Text)
	var $eEventType : cs:C1710.sfw_EventTypeEntity
	$eEventType:=ds:C1482.sfw_EventType.new()
	$eEventType.ident:=$ident
	$eEventType.label:=$label
	$info:=$eEventType.save()
	If ($info.success)
		This:C1470.events[$ident]:=OB Copy:C1225($eEventType.toObject(); ck shared:K85:29)
	End if 
	
	
	
shared Function getEventType($ident : Text)->$eventType : Object
	var $eEventType : cs:C1710.sfw_EventTypeEntity
	If (This:C1470.events[$ident]=Null:C1517)
		$eEventType:=ds:C1482.sfw_EventType.query("ident = :1"; $ident).first()
		If ($eEventType=Null:C1517)
		Else 
			This:C1470.events[$ident]:=OB Copy:C1225($eEventType.toObject(); ck shared:K85:29)
		End if 
	End if 
	$eventType:=This:C1470.events[$ident]
	
shared Function getEventTypeByUUID($uuid : Text)->$eventType : Object
	var $eEventType : cs:C1710.sfw_EventTypeEntity
	If (This:C1470.events[$uuid]=Null:C1517)
		$eEventType:=ds:C1482.sfw_EventType.get($uuid)
		If ($eEventType=Null:C1517)
		Else 
			This:C1470.events[$uuid]:=OB Copy:C1225($eEventType.toObject(); ck shared:K85:29)
		End if 
	End if 
	$eventType:=This:C1470.events[$uuid]
	
	
shared Function getEvent($entry : cs:C1710.sfw_definitionEntry; $ident : Text; $uuid : Text)->$eEvent : 4D:C1709.Entity
	If ($entry.event.dataclass#Null:C1517) && ($entry.event.linkedAttribute#Null:C1517)
		$eventTypeUUID:=This:C1470.events[$ident].UUID
		$eEvent:=ds:C1482[$entry.event.dataclass].query("UUID_EventType = :1 AND "+$entry.event.linkedAttribute+" = :2"; $eventTypeUUID; $uuid).first()
	End if 
	
shared Function addEvent($entry : cs:C1710.sfw_definitionEntry; $ident : Text; $uuid : Text; $moreData : Object; $stmp : Integer)
	
	If ($entry.event.dataclass#Null:C1517)
		
		$eEvent:=ds:C1482[$entry.event.dataclass].new()
		$eEvent.UUID_EventType:=This:C1470.events[$ident].UUID
		$eEvent.UUID_User:=cs:C1710.sfw_userManager.me.info.UUID
		
		
		For each ($attribute; ds:C1482[$entry.event.dataclass])
			If (ds:C1482[$entry.event.dataclass][$attribute].kind="storage") && (ds:C1482[$entry.event.dataclass][$attribute].name=("UUID_"+$entry.dataclass))
				$eEvent[$attribute]:=$uuid
				break
			End if 
		End for each 
		
		If (Count parameters:C259>3)
			$eEvent.moreData:=$moreData
		End if 
		If (Count parameters:C259>4)
			$eEvent.stmp:=$stmp
		Else 
			$eEvent.stmp:=cs:C1710.sfw_stmp.me.now()
		End if 
		$info:=$eEvent.save()
		
	End if 
	
	
Function launch()
	
	CALL WORKER:C1389("eventManager"; Formula:C1597(cs:C1710.sfw_eventManager.me._launchWorker()))
	
	
shared Function _launchWorker()
	WINDOW LIST:C442($_refWindows; *)
	If (This:C1470.window=0) || (Find in array:C230($_refWindows; This:C1470.window)<0)
		$ref:=Open form window:C675("sfw_eventPalette"; Palette form window:K39:9; On the right:K39:3; At the bottom:K39:6)
		This:C1470.window:=$ref
		DIALOG:C40("sfw_eventPalette"; *)
	End if 
	
	
	
	
shared Function _formMethod()
	
	Case of 
		: (FORM Event:C1606.code=On Load:K2:1)
			
			Form:C1466.levelFilter:=0
			This:C1470._drawEventContainer()
			
			
		: (FORM Event:C1606.code=On Close Box:K2:21)
			CANCEL:C270
			This:C1470.window:=0
			
	End case 
	
	
Function _displayHeaderTabEvent()
	If (Form:C1466.current_item#Null:C1517) && (Form:C1466.sfw.entry.event#Null:C1517)
		$nb:=ds:C1482.sfw_getNbEvents(Form:C1466.current_item.UUID; Form:C1466.sfw.entry)
		Case of 
			: ($nb=0)
				$title:=Form:C1466.sfw.entry.event.unit0 || "no event"
			: ($nb=1)
				$title:=Form:C1466.sfw.entry.event.unit1 || "one event"
			Else 
				$title:=String:C10($nb)+" "+(Form:C1466.sfw.entry.event.unitN || "events")
		End case 
		OBJECT SET VALUE:C1742("headerTabEvent_title"; $title)
	End if 
	$eventTabVisible:=(Form:C1466.current_item#Null:C1517) && (Form:C1466.sfw.entry.event#Null:C1517)
	OBJECT SET VISIBLE:C603(*; "headerTabEvent@"; $eventTabVisible)
	Form:C1466.sfw.arrangeHeaderTabs()
	
	
Function clicOnHeader($uuid_target : Text; $entry : cs:C1710.sfw_definitionEntry)
	cs:C1710.sfw_tracker.me.internal("event clic on header : "+Get window title:C450)
	If (This:C1470.window#0)
		SHOW WINDOW:C435(This:C1470.window)
	End if 
	WINDOW LIST:C442($_refWindows; *)
	If (This:C1470.window=0) || (Find in array:C230($_refWindows; This:C1470.window)<0)
		This:C1470.launch()
	End if 
	DELAY PROCESS:C323(Current process:C322; 10)
	SHOW WINDOW:C435(This:C1470.window)
	CALL FORM:C1391(This:C1470.window; Formula:C1597(cs:C1710.sfw_eventManager.me._displayEvents($1; $2)); $uuid_target; $entry)
	
	
Function refresh($uuid_target : Text; $entry : cs:C1710.sfw_definitionEntry)
	cs:C1710.sfw_tracker.me.internal("events refresh : "+Get window title:C450)
	If (This:C1470.window#0)
		SHOW WINDOW:C435(This:C1470.window)
	End if 
	WINDOW LIST:C442($_refWindows; *)
	If (This:C1470.window#0) && (Find in array:C230($_refWindows; This:C1470.window)>0)
		SHOW WINDOW:C435(This:C1470.window)
		CALL FORM:C1391(This:C1470.window; Formula:C1597(cs:C1710.sfw_eventManager.me._displayEvents($1; $2)); $uuid_target; $entry)
	End if 
	
	
Function hide()
	cs:C1710.sfw_tracker.me.internal("events hide : "+Get window title:C450)
	WINDOW LIST:C442($_refWindows; *)
	If (This:C1470.window#0) && (Find in array:C230($_refWindows; This:C1470.window)>0)
		HIDE WINDOW:C436(This:C1470.window)
	End if 
	
	
Function _displayEvents($uuid_target : Text; $entry : cs:C1710.sfw_definition)
	var $esEvents : 4D:C1709.EntitySelection
	var $eEvent : 4D:C1709.Entity
	
	Form:C1466.UUID_target:=$uuid_target
	Form:C1466.events:=New collection:C1472
	If (ds:C1482[$entry.event.dataclass]#Null:C1517)
		$esEvents:=ds:C1482[$entry.event.dataclass].query($entry.event.linkedAttribute+" = :1 order by stmp desc"; $uuid_target)
		For each ($eEvent; $esEvents)
			$event:=New object:C1471
			$event.UUID:=$eEvent.UUID
			$event.stmp:=$eEvent.stmp
			$event.date:=cs:C1710.sfw_stmp.me.getDate($event.stmp)
			$event.time:=String:C10(cs:C1710.sfw_stmp.me.getTime($event.stmp); HH MM SS:K7:1)
			$event.year:=Year of:C25($event.date)
			$event.month:=Month of:C24($event.date)
			If ($eEvent.user#Null:C1517)
				If (cs:C1710.sfw_definition.me.globalParameters.linkedPathToNameFormUserEntity=Null:C1517)
					$event.user:=$eEvent.user.fullName
				Else 
					$source:=$eEvent.user
					$pathParts:=Split string:C1554(cs:C1710.sfw_definition.me.globalParameters.linkedPathToNameFormUserEntity; ".")
					$lastAttribute:=$pathParts.pop()
					For each ($pathPart; $pathParts)
						If ($pathPart="@()")
							$source:=$source[Substring:C12($pathPart; 1; Length:C16($pathPart)-2)]()
						Else 
							$source:=$source[$pathPart]
						End if 
					End for each 
					$event.user:=$source[$lastAttribute]
				End if 
			Else 
				$event.user:=""  //cs.sfw_userManager.me.info.login
			End if 
			$commentParts:=New collection:C1472
			If ($eEvent.moreData#Null:C1517)
				If ($eEvent.moreData.modifiedFields#Null:C1517)
					For each ($attributeName; $eEvent.moreData.modifiedFields)
						$commentParts.push($attributeName+": "+String:C10($eEvent.moreData.modifiedFields[$attributeName].old)+" -> "+String:C10($eEvent.moreData.modifiedFields[$attributeName].new))
					End for each 
				End if 
				If ($eEvent.moreData.comment#Null:C1517)
					$commentParts.push($eEvent.moreData.comment)
				End if 
			End if 
			$event.comment:=$commentParts.join("\r"; ck ignore null or empty:K85:5)
			
			$event.eventTypeTitle:=This:C1470.getEventTypeByUUID($eEvent.UUID_EventType).label
			Form:C1466.events.push($event)
		End for each 
	End if 
	This:C1470._drawEventContainer()
	
	
	
Function _drawEventContainer()
	var $file : 4D:C1709.File
	var $formDefinition : Object
	cs:C1710.sfw_tracker.me.internal("draw event container : "+Get window title:C450)
	
	OBJECT SET VISIBLE:C603(*; "subFormEventList"; Form:C1466.events.length>0)
	OBJECT SET VISIBLE:C603(*; "noEvent_@"; Form:C1466.events.length=0)
	If (Form:C1466.events.length>0)
		
		$file:=Folder:C1567(fk resources folder:K87:11).file("sfw/dynform/container.json")
		$formDefinition:=JSON Parse:C1218($file.getText())
		$file:=Folder:C1567(fk resources folder:K87:11).file("sfw/dynform/eventListYear.json")
		$formEventListYearJson:=$file.getText()
		$file:=Folder:C1567(fk resources folder:K87:11).file("sfw/dynform/eventListMonth.json")
		$formEventListMonthJson:=$file.getText()
		$file:=Folder:C1567(fk resources folder:K87:11).file("sfw/dynform/eventListItem.json")
		$formEventListItemJson:=$file.getText()
		
		$pageObjects:=$formDefinition.pages[1].objects
		$lineNum:=-1
		$vOffset:=0
		
		$years:=Form:C1466.events.distinct("year")
		Form:C1466.years:=New collection:C1472
		$y:=-1
		Form:C1466.months:=New collection:C1472
		$m:=-1
		For each ($yearNum; $years)
			$year:=New object:C1471
			$year.year:=$yearNum
			$year.expand:=(This:C1470.collapsedYears.indexOf($yearNum)=-1) ? 1 : 0
			Form:C1466.years.push($year)
		End for each 
		Form:C1466.years:=Form:C1466.years.orderBy("year desc")
		For each ($year; Form:C1466.years)
			$y+=1
			$newLineDefinition:=Replace string:C233($formEventListYearJson; "##1##"; String:C10($y))
			$widgets:=JSON Parse:C1218($newLineDefinition).objects
			$widget:=$widgets["year_"+String:C10($y)]
			$widget.dataSource:=String:C10($year.year)
			$widget:=$widgets["bExpand_year_"+String:C10($y)]
			$widget.dataSource:="Form.years["+String:C10($y)+"].expand"
			$widget:=$widgets["header_bkgd_year_"+String:C10($y)]
			$maxBottom:=$widget.top+$widget.height
			For each ($widgetName; $widgets)
				$widget:=$widgets[$widgetName]
				$widget.top+=$vOffset
				$pageObjects[$widgetName]:=$widget
			End for each 
			$vOffset+=$maxBottom
			If ($year.expand=1)
				$months:=Form:C1466.events.query("year = :1"; $year.year).distinct("month").reverse()
				For each ($monthNum; $months)
					$month:=New object:C1471
					$month.year:=$year.year
					$month.month:=$monthNum
					$yearmonth:=String:C10($month.year)+"/"+String:C10($month.month)
					$month.expand:=(This:C1470.collapsedMonths.indexOf($yearmonth)=-1) ? 1 : 0
					Form:C1466.months.push($month)
					$m+=1
					$newLineDefinition:=Replace string:C233($formEventListMonthJson; "##1##"; String:C10($m))
					$widgets:=JSON Parse:C1218($newLineDefinition).objects
					$widget:=$widgets["month_"+String:C10($m)]
					$widget.dataSource:=String:C10($month.month)
					$widget.dataSource:="\""+cs:C1710.sfw_stmp.me.monthNames[$month.month-1]+" - "+String:C10($month.year)+"\""
					$widget:=$widgets["bExpand_month_"+String:C10($m)]
					$widget.dataSource:="Form.months["+String:C10($m)+"].expand"
					$widget:=$widgets["header_bkgd_month_"+String:C10($m)]
					$maxBottom:=$widget.top+$widget.height
					For each ($widgetName; $widgets)
						$widget:=$widgets[$widgetName]
						$widget.top+=$vOffset
						$pageObjects[$widgetName]:=$widget
					End for each 
					$vOffset+=$maxBottom
					
					If ($month.expand=1)
						
						$events:=Form:C1466.events.query("year = :1 and month = :2"; $year.year; $month.month)
						For each ($event; $events)
							$lineNum+=1
							$newLineDefinition:=Replace string:C233($formEventListItemJson; "##1##"; String:C10($lineNum))
							$event.expand:=(This:C1470.expandedEvents.indexOf($event.UUID)=-1) ? 0 : 1
							
							
							$widgets:=JSON Parse:C1218($newLineDefinition).objects
							$widget:=$widgets["bCollapse_event_"+String:C10($lineNum)]
							$widget.dataSource:="Form.events["+String:C10($lineNum)+"].expand"
							
							
							Case of 
								: ($event.expand=0)
									$widget:=$widgets["header_bkgd_"+String:C10($lineNum)]
									$maxBottom:=$widget.top+$widget.height
								: ($event.comment="")
									$widget:=$widgets["time_"+String:C10($lineNum)]
									$maxBottom:=$widget.top+$widget.height+3
									$height:=$widget.height
									$widget:=$widgets["body_bkgd_"+String:C10($lineNum)]
									$widget.height:=$height+3+3
								Else 
									Form:C1466.text_calculator:=$event.comment
									OBJECT GET BEST SIZE:C717(*; "text_calculator"; $bestWidth; $bestHeight; 321)
									$widget:=$widgets["comment_"+String:C10($lineNum)]
									$widget.height:=$bestHeight
									$widget:=$widgets["body_bkgd_"+String:C10($lineNum)]
									$widget.height:=$bestHeight+17+3+3+3
									$maxBottom:=$widget.top+$widget.height
							End case 
							
							
							For each ($widgetName; $widgets)
								$widget:=$widgets[$widgetName]
								If ((Bool:C1537($widget._expand)=True:C214) && ($event.expand=1)) || (Bool:C1537($widget._expand)=False:C215)
									$widget.top+=$vOffset
									If ($widgetName#("comment_"+String:C10($lineNum)))
										$pageObjects[$widgetName]:=$widget
									Else 
										If ($event.comment#"")
											$pageObjects[$widgetName]:=$widget
										End if 
									End if 
								End if 
							End for each 
							$vOffset+=$maxBottom
							
						End for each 
						
					End if 
					
					
				End for each 
				
			End if 
			
		End for each 
		$formDefinition.method:="sfw_eventManager_sfm"
		
		Form:C1466.subFormEventList:=New object:C1471
		Form:C1466.subFormEventList.events:=Form:C1466.events.orderBy("stmp desc")
		Form:C1466.subFormEventList.years:=Form:C1466.years
		Form:C1466.subFormEventList.months:=Form:C1466.months
		OBJECT SET SUBFORM:C1138(*; "subFormEventList"; $formDefinition)
	End if 
	
	
	
Function subFormMethod()
	Case of 
		: (FORM Event:C1606.code=On Load:K2:1)
			
			
		: (FORM Event:C1606.code=On Clicked:K2:4) & (FORM Event:C1606.objectName="bExpand_year_@")
			$year:=Form:C1466.years[Num:C11(Split string:C1554(FORM Event:C1606.objectName; "_").pop())]
			Case of 
				: ($year.expand=0)
					Use (This:C1470.collapsedYears)
						This:C1470.collapsedYears.push($year.year).distinct()
					End use 
				: ($year.expand=1)
					Use (This:C1470.collapsedYears)
						$index:=This:C1470.collapsedYears.indexOf($year.year)
						This:C1470.collapsedYears.remove($index)
					End use 
			End case 
			CALL SUBFORM CONTAINER:C1086(-2000)
			
		: (FORM Event:C1606.code=On Clicked:K2:4) & (FORM Event:C1606.objectName="bExpand_month_@")
			$month:=Form:C1466.months[Num:C11(Split string:C1554(FORM Event:C1606.objectName; "_").pop())]
			$yearmonth:=String:C10($month.year)+"/"+String:C10($month.month)
			Case of 
				: ($month.expand=0)
					Use (This:C1470.collapsedMonths)
						This:C1470.collapsedMonths.push($yearmonth).distinct()
					End use 
				: ($month.expand=1)
					Use (This:C1470.collapsedMonths)
						$index:=This:C1470.collapsedMonths.indexOf($yearmonth)
						This:C1470.collapsedMonths.remove($index)
					End use 
			End case 
			CALL SUBFORM CONTAINER:C1086(-2000)
			
		: (FORM Event:C1606.code=On Clicked:K2:4) & (FORM Event:C1606.objectName="bCollapse_event_@")
			$event:=Form:C1466.events[Num:C11(Split string:C1554(FORM Event:C1606.objectName; "_").pop())]
			Case of 
				: ($event.expand=0)
					Use (This:C1470.expandedEvents)
						$index:=This:C1470.expandedEvents.indexOf($event.UUID)
						This:C1470.expandedEvents.remove($index)
					End use 
				: ($event.expand=1)
					Use (This:C1470.expandedEvents)
						This:C1470.expandedEvents.push($event.UUID).distinct()
					End use 
					
			End case 
			CALL SUBFORM CONTAINER:C1086(-2000)
			
	End case 
	