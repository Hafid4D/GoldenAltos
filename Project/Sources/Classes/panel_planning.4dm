singleton Class constructor
	// It's a singleton class
	
Function formMethod()
	Form:C1466.sfw.panelFormMethod()
	If (Form:C1466.sfw.updateOfPanelNeeded())
		This:C1470.drawPup_customer()
		This:C1470.loadLotSteps()
	End if 
	If (Form:C1466.sfw.recalculationOfPanelPageNeeded())
		Case of 
			: ((FORM Get current page:C276(*)=2) | (FORM Get current page:C276(*)=3))
				This:C1470.loadLotSteps()
		End case 
	End if 
	If (Form:C1466.sfw.redrawAndSetVisibleInPanelNeeded())
		This:C1470.redrawAndSetVisible()
	End if 
	
Function redrawAndSetVisible()
	OBJECT SET ENTERABLE:C238(*; "entryField_jobNumber"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "entryField_lotNumber"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "entryField_deviceNumber"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "entryField_customerLotNumber"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "pup_customer"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET ENABLED:C1123(*; "pup_customer"; Form:C1466.sfw.checkIsInModification())
	
	This:C1470.refreshStepTabLabel()
	Form:C1466.sfw.drawHTab()
	This:C1470.drawPup_customer()
	
	Case of 
		: ((FORM Get current page:C276(*)=2) | (FORM Get current page:C276(*)=3))
			OBJECT GET SUBFORM CONTAINER SIZE:C1148($widthSubform; $heightSubform)
			OBJECT GET COORDINATES:C663(*; "rec_bkgd"; $left; $top; $right; $bottom)
			OBJECT GET COORDINATES:C663(*; "lb_steps"; $left_lb; $top_lb; $right_lb; $bottom_lb)
			OBJECT GET COORDINATES:C663(*; "bActionSteps"; $left_bAc; $top_bAc; $right_bAc; $bottom_bAc)
			OBJECT GET COORDINATES:C663(*; "btnMoveTop"; $left_mt; $top_mt; $right_mt; $bottom_mt)
			OBJECT GET COORDINATES:C663(*; "btnMoveUp"; $left_mu; $top_mu; $right_mu; $bottom_mu)
			OBJECT GET COORDINATES:C663(*; "btnMoveDown"; $left_md; $top_md; $right_md; $bottom_md)
			OBJECT GET COORDINATES:C663(*; "btnMoveBottom"; $left_mb; $top_mb; $right_mb; $bottom_mb)
			OBJECT GET COORDINATES:C663(*; "btnDeleteRow"; $left_dr; $top_dr; $right_dr; $bottom_dr)
			
			$offset:=4
			$offset_btns_r:=15
			$offset_bAc:=10
			$height_bAc:=$bottom_bAc-$top_bAc
			$width_mt:=$right_mt-$left_mt
			$width_mu:=$right_mu-$left_mu
			$width_md:=$right_md-$left_md
			$width_mb:=$right_mb-$left_mb
			$width_dr:=$right_dr-$left_dr
			$marginR:=12
			$editorColW:=352
			$btnBand:=52
			$rowH:=30
			$labW:=86
			$rowGap:=8
			$descH:=108
			
			$split:=$widthSubform-$marginR-$editorColW
			If ($split<($left_lb+340))
				$split:=$left_lb+340
			End if 
			$listRight:=$split-$btnBand
			If ($listRight<($left_lb+180))
				$listRight:=$left_lb+180
			End if 
			$bottomBoth:=$heightSubform-8
			$ctrlL:=$split+$labW+14
			$ctrlR:=$widthSubform-$marginR-8
			
			OBJECT SET COORDINATES:C1248(*; "rec_bkgd"; $left; $top; $right; $heightSubform-$offset)
			OBJECT SET COORDINATES:C1248(*; "lb_steps"; $left_lb; $top_lb; $listRight; $bottomBoth)
			OBJECT SET COORDINATES:C1248(*; "bActionSteps"; $left_bAc; $heightSubform-$offset_bAc-$height_bAc; $right_bAc; $heightSubform-$offset_bAc)
			
			$yt:=$top_lb+8
			OBJECT SET COORDINATES:C1248(*; "btnMoveTop"; $listRight+6; $yt; $listRight+6+$width_mt; $yt+26)
			$yt:=$yt+32
			OBJECT SET COORDINATES:C1248(*; "btnMoveUp"; $listRight+6; $yt; $listRight+6+$width_mu; $yt+26)
			$yt:=$yt+32
			OBJECT SET COORDINATES:C1248(*; "btnMoveDown"; $listRight+6; $yt; $listRight+6+$width_md; $yt+26)
			$yt:=$yt+32
			OBJECT SET COORDINATES:C1248(*; "btnMoveBottom"; $listRight+6; $yt; $listRight+6+$width_mb; $yt+26)
			$yt:=$yt+32
			OBJECT SET COORDINATES:C1248(*; "btnDeleteRow"; $listRight+6; $yt; $listRight+6+$width_dr; $yt+26)
			
			OBJECT SET COORDINATES:C1248(*; "rec_sd_editor"; $split; $top_lb; $widthSubform-$marginR; $bottomBoth)
			$y:=$top_lb+10
			OBJECT SET COORDINATES:C1248(*; "sd_lbl_stepEditor"; $split+8; $y; $ctrlR; $y+16)
			$y:=$y+24
			
			OBJECT SET COORDINATES:C1248(*; "sd_lab_description"; $split+8; $y+4; $split+8+$labW; $y+18)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_description"; $ctrlL; $y; $ctrlR; $y+$descH)
			$y:=$y+$descH+$rowGap
			OBJECT SET COORDINATES:C1248(*; "sd_lab_area"; $split+8; $y+4; $split+8+$labW; $y+18)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_areas"; $ctrlL; $y; $ctrlR; $y+18)
			$y:=$y+$rowH
			
			$pairGap:=8
			$pairBaseL:=$split+8
			$pairW:=($ctrlR-$pairBaseL-$pairGap)/2
			$leftValL:=$pairBaseL+$labW+4
			$leftValR:=$pairBaseL+$pairW
			$rightBase:=$pairBaseL+$pairW+$pairGap
			$rightValL:=$rightBase+$labW+4
			
			OBJECT SET COORDINATES:C1248(*; "sd_lab_qtyIn"; $pairBaseL; $y+2; $pairBaseL+$labW; $y+16)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_qtyIn"; $leftValL; $y; $leftValR; $y+18)
			OBJECT SET COORDINATES:C1248(*; "sd_lab_qtyOut"; $rightBase; $y+2; $rightBase+$labW; $y+16)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_qtyOut"; $rightValL; $y; $ctrlR; $y+18)
			$y:=$y+$rowH
			
			OBJECT SET COORDINATES:C1248(*; "sd_lab_dateIn"; $pairBaseL; $y+2; $pairBaseL+$labW; $y+16)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_dateIn"; $leftValL; $y; $leftValR; $y+18)
			OBJECT SET COORDINATES:C1248(*; "sd_lab_dateOut"; $rightBase; $y+2; $rightBase+$labW; $y+16)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_dateOut"; $rightValL; $y; $ctrlR; $y+18)
			$y:=$y+$rowH
			
			OBJECT SET COORDINATES:C1248(*; "sd_lab_minYield"; $pairBaseL; $y+2; $pairBaseL+$labW; $y+16)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_minYield"; $leftValL; $y; $leftValR; $y+18)
			OBJECT SET COORDINATES:C1248(*; "sd_lab_yield"; $rightBase; $y+2; $rightBase+$labW; $y+16)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_yield"; $rightValL; $y; $ctrlR; $y+18)
			$y:=$y+$rowH
			
			OBJECT SET COORDINATES:C1248(*; "sd_lab_plannedHours"; $pairBaseL; $y+2; $pairBaseL+$labW; $y+16)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_plannedHours"; $leftValL; $y; $leftValR; $y+18)
			OBJECT SET COORDINATES:C1248(*; "sd_lab_actualHours"; $rightBase; $y+2; $rightBase+$labW; $y+16)
			OBJECT SET COORDINATES:C1248(*; "sd_inp_actualHours"; $rightValL; $y; $ctrlR; $y+18)
	End case 
	This:C1470.manageReOrderBtns()
	This:C1470.manageStepDetailPanel()
	
Function loadLotSteps()
	Form:C1466.step:=Null:C1517
	Form:C1466.stepPos:=0
	Form:C1466.lb_steps:=ds:C1482.LotStep.query("UUID_Lot = :1"; Form:C1466.current_item.UUID).orderBy("order asc")
	If (Form:C1466.lb_steps.length>0)
		Form:C1466.step:=Form:C1466.lb_steps[0]
		Form:C1466.stepPos:=1
		LISTBOX SELECT ROW:C912(*; "lb_steps"; 1)
	End if 
	This:C1470.refreshStepTabLabel()
	Form:C1466.sfw.drawHTab()
	This:C1470.manageReOrderBtns()
	This:C1470.manageStepDetailPanel()
	
Function refreshStepTabLabel()
	Use (Form:C1466.sfw.entry.panel.pages)
		If (Form:C1466.sfw.entry.panel.pages.length>1)
			Form:C1466.sfw.entry.panel.pages[1].label:="Steps ("+String:C10(Form:C1466.lb_steps.length)+")"
		End if 
	End use 
	
Function bActionSteps()
	$refMenu:=Create menu:C408
	APPEND MENU ITEM:C411($refMenu; "Add Step from Step File")
	SET MENU ITEM PARAMETER:C1004($refMenu; -1; "--create_from_stepfile")
	SET MENU ITEM ICON:C984($refMenu; -1; "Path:/RESOURCES/image/button/add.png")
	
	If (Not:C34(Form:C1466.sfw.checkIsInModification()))
		DISABLE MENU ITEM:C150($refMenu; -1)
	End if 
	
	$choose:=Dynamic pop up menu:C1006($refMenu)
	Case of 
		: ($choose="--create_from_stepfile")
			$form:=New object:C1471("lotInfo"; New object:C1471("customer"; Form:C1466.current_item.job.purchaseOrder.customer))
			
			$winRef:=Open form window:C675("createFromStepFile"; Controller form window:K39:17; Horizontally centered:K39:1; Vertically centered:K39:4)
			DIALOG:C40("createFromStepFile"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (OK=1)
				$length:=Form:C1466.lb_steps.length
				If (($form.stepFile.stepsDefinition#Null:C1517) & ($form.stepFile.stepsDefinition.items#Null:C1517) & ($form.stepFile.stepsDefinition.items.length>0))
					For each ($item; $form.stepFile.stepsDefinition.items)
						$hasStep:=False:C215
						
						// Preferred lookup from imported UUID link in step definition.
						If (cs:C1710.sfw_string.me.isAnEmptyUUID($item.UUID_Step)=False:C215)
							$step_e:=ds:C1482.Step.query("UUID = :1"; $item.UUID_Step).first()
							$hasStep:=($step_e#Null:C1517)
						End if 
						
						// Backward-compatible fallback for legacy rows with only step_template.
						If (Not:C34($hasStep))
							$stepTemplateNum:=Num:C11($item.step_template)
							If ($stepTemplateNum>0)
								$stepTemplate_e:=ds:C1482.StepTemplate.query("templateNumber = :1"; $stepTemplateNum).first()
								If ($stepTemplate_e#Null:C1517)
									$step_e:=ds:C1482.Step.query("UUID_StepTemplate = :1"; $stepTemplate_e.UUID).first()
									$hasStep:=($step_e#Null:C1517)
								End if 
							End if 
						End if 
						
						If ($hasStep)
							$step_new:=ds:C1482.LotStep.new()
							$step_new.description:=$step_e.description
							$step_new.alert:=$step_e.alert
							$step_new.UUID_Lot:=Form:C1466.current_item.UUID
							$step_new.order:=$length+1
							$length:=$length+1
							$res:=$step_new.save()
						End if 
					End for each 
				End if 
				This:C1470.loadLotSteps()
				Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
			End if 
	End case 
	
Function selectCustomer()
	var $job : cs:C1710.JobEntity
	var $form : Object
	
	If (Form:C1466.sfw.checkIsInModification())
		$job:=Form:C1466.current_item.job
		If ($job=Null:C1517)
			$job:=ds:C1482.Job.get(Form:C1466.current_item.UUID_Job)
		End if 
		If ($job#Null:C1517)
			$form:=New object:C1471()
			$form.lb_items:=ds:C1482.Customer.all().orderBy("name")
			$form.words:=""
			
			OBJECT GET COORDINATES:C663(*; "pup_customer"; $l; $t; $r; $b)
			CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
			
			$winRef:=Open form window:C675("selectCustomer"; Pop up form window:K39:11; $l; $b+1)
			DIALOG:C40("selectCustomer"; $form)
			CLOSE WINDOW:C154($winRef)
			
			If (OK=1) && ($form.item#Null:C1517)
				$job.UUID_Customer:=$form.item.UUID
				$job.customerName:=$form.item.name
				$res:=$job.save()
				If ($res.success)
					Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
					This:C1470.drawPup_customer()
				End if 
			End if 
		End if 
	End if 
	
Function selectJob()
	var $form : Object
	
	If (Form:C1466.sfw.checkIsInModification())
		OBJECT GET COORDINATES:C663(*; "pup_job"; $l; $t; $r; $b)
		CONVERT COORDINATES:C1365($l; $b; XY Current form:K27:5; XY Main window:K27:8)
		
		$form:=New object:C1471(\
			"colName"; "jobNumber"; \
			"lb_items"; ds:C1482.Job.all().orderBy("jobNumber"); \
			"allData"; ds:C1482.Job.all().orderBy("jobNumber"); \
			"dataclass"; "Job"\
			)
		
		$winRef:=Open form window:C675("selectNto1"; Pop up form window:K39:11; $l; $b+1)
		DIALOG:C40("selectNto1"; $form)
		CLOSE WINDOW:C154($winRef)
		
		If (OK=1) & ($form.item#Null:C1517)
			Form:C1466.current_item.UUID_Job:=$form.item.UUID
			Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
			This:C1470.drawPup_customer()
		End if 
	End if 
	
Function drawPup_customer()
	var $job : cs:C1710.JobEntity
	var $customerName : Text
	var $disabled : Boolean
	
	$customerName:=" "
	$disabled:=True:C214
	$job:=Form:C1466.current_item.job
	If ($job=Null:C1517)
		$job:=ds:C1482.Job.get(Form:C1466.current_item.UUID_Job)
	End if 
	If ($job#Null:C1517)
		$customerName:=$job.customer.name || " "
		$disabled:=Not:C34(Form:C1466.sfw.checkIsInModification())
	End if 
	Form:C1466.sfw.drawButtonPup("pup_customer"; $customerName; "sfw/image/skin/rainbow/icon/spacer-1x24.png"; $disabled)
	
Function manageReOrderBtns()
	OBJECT SET VISIBLE:C603(*; "btnMoveTop"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnMoveUp"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnMoveDown"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnMoveBottom"; Form:C1466.sfw.checkIsInModification())
	OBJECT SET VISIBLE:C603(*; "btnDeleteRow"; Form:C1466.sfw.checkIsInModification())
	
	OBJECT SET ENABLED:C1123(*; "btnMoveTop"; (Form:C1466.step#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnMoveUp"; (Form:C1466.step#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnMoveDown"; (Form:C1466.step#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnMoveBottom"; (Form:C1466.step#Null:C1517))
	OBJECT SET ENABLED:C1123(*; "btnDeleteRow"; (Form:C1466.step#Null:C1517))
	
	If (Form:C1466.sfw.checkIsInModification() & (Form:C1466.step#Null:C1517))
		Case of 
			: (Form:C1466.stepPos=1)
				OBJECT SET ENABLED:C1123(*; "btnMoveTop"; False:C215)
				OBJECT SET ENABLED:C1123(*; "btnMoveUp"; False:C215)
				
			: (Form:C1466.stepPos=Form:C1466.lb_steps.length)
				OBJECT SET ENABLED:C1123(*; "btnMoveBottom"; False:C215)
				OBJECT SET ENABLED:C1123(*; "btnMoveDown"; False:C215)
		End case 
	End if 
	
Function manageStepDetailPanel()
	$hasRow:=(Form:C1466.step#Null:C1517)
	$vis:=$hasRow
	
	OBJECT SET VISIBLE:C603(*; "rec_sd_editor"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lbl_stepEditor"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_description"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_description"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_area"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_areas"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_qtyIn"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_qtyIn"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_qtyOut"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_qtyOut"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_dateIn"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_dateIn"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_dateOut"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_dateOut"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_minYield"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_minYield"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_yield"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_yield"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_plannedHours"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_plannedHours"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_lab_actualHours"; $vis)
	OBJECT SET VISIBLE:C603(*; "sd_inp_actualHours"; $vis)
	
	OBJECT SET ENTERABLE:C238(*; "sd_inp_description"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "sd_inp_areas"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "sd_inp_qtyIn"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "sd_inp_qtyOut"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "sd_inp_dateIn"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "sd_inp_dateOut"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "sd_inp_minYield"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "sd_inp_yield"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "sd_inp_plannedHours"; False:C215)
	OBJECT SET ENTERABLE:C238(*; "sd_inp_actualHours"; False:C215)
	
Function btnReOrderSteps($from : Integer; $to : Integer)
	If (Not:C34(Form:C1466.sfw.checkIsInModification())) || (Form:C1466.step=Null:C1517)
		return 
	End if 
	If (($from=$to) | ($from<1) | ($to<1) | ($to>Form:C1466.lb_steps.length))
		return 
	End if 
	
	$coef:=1
	If (($to-$from)>0)
		$coef:=-1
	End if 
	
	If ($coef>0)
		$stepsToReOrder:=Form:C1466.lb_steps.query("order >= :1 AND order < :2"; Choose:C955(($from>$to); $to; $from); Choose:C955(($from>$to); $from; $to))
	Else 
		$stepsToReOrder:=Form:C1466.lb_steps.query("order > :1 AND order <= :2"; Choose:C955(($from>$to); $to; $from); Choose:C955(($from>$to); $from; $to))
	End if 
	
	For each ($lotStep; $stepsToReOrder)
		$lotStep.order:=$lotStep.order+$coef
		$res:=$lotStep.save()
	End for each 
	
	Form:C1466.step.order:=$to
	$res:=Form:C1466.step.save()
	
	This:C1470.loadLotSteps()
	Form:C1466.step:=Form:C1466.lb_steps.query("order = :1"; $to).first()
	Form:C1466.stepPos:=$to
	LISTBOX SELECT ROW:C912(*; "lb_steps"; $to)
	This:C1470.manageReOrderBtns()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	
Function deleteSelectedStep()
	If (Not:C34(Form:C1466.sfw.checkIsInModification())) || (Form:C1466.step=Null:C1517)
		return 
	End if 
	
	$deletedOrder:=Form:C1466.step.order
	$res:=Form:C1466.step.drop()
	If (Not:C34($res.success))
		return 
	End if 
	
	$stepsToReOrder:=ds:C1482.LotStep.query("UUID_Lot = :1 AND order > :2"; Form:C1466.current_item.UUID; $deletedOrder).orderBy("order asc")
	For each ($lotStep; $stepsToReOrder)
		$lotStep.order:=$lotStep.order-1
		$res:=$lotStep.save()
	End for each 
	
	This:C1470.loadLotSteps()
	Form:C1466.current_item.UUID:=Form:C1466.current_item.UUID
	