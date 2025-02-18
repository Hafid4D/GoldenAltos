//%attributes = {}
Form:C1466.sfw.panelFormMethod()

//var $resetWidgetDesign : Boolean
//var $runValidationRules : Boolean

//$resetWidgetDesign:=False
//$runValidationRules:=False
//Case of 
//: (FORM Event.code=On Load)
//$resetWidgetDesign:=True
//$runValidationRules:=True
//Form.canValidate:=True
//Form.validationRulesPassedWithSuccess:=True
//Form.validationRulesMessages:=New collection

//FORM GET OBJECTS($_objectNames)
//Form.useAddressSubSubForm:=(Find in array($_objectNames; "address_subsubform")>0)
//Form.useCommunicationSubSubForm:=(Find in array($_objectNames; "communication_subform")>0)
//Form.usePageTab:=(Find in array($_objectNames; "page_tab")>0)
//Form.useHeaderBkgd:=(Find in array($_objectNames; "header_bkgd")>0)
//Form.useTabBar:=(Find in array($_objectNames; "vTabBar_subform")>0)

//If (Form.useTabBar)
//If (Form.vTabBar=Null)
//Form.vTabBar:=New object
//End if 

//Form.vTabBar.buttons:=Form.sfw.entry.panel.pages
//Form.vTabBar.currentPage:=Form.sfw.entry.panel.currentPage
//End if 

//If (Form.calculation=Null)
//Form.calculation:=New object
//End if 


//: (FORM Event.code=On Bound Variable Change)
//$resetWidgetDesign:=True
//$runValidationRules:=True
//Form.canValidate:=True
//Form.validationRulesPassedWithSuccess:=True
//Form.validationRulesMessages:=New collection

//: (FORM Event.code=On Data Change)
//$runValidationRules:=True
//Form.canValidate:=True
//Form.validationRulesPassedWithSuccess:=True

//: (FORM Event.code=On Clicked)
//$runValidationRules:=Form.sfw.checkIsInModification()



//: (FORM Event.code=On Mouse Enter)
//OBJECT SET VISIBLE(*; "bEye_@"; False)
//Case of 
//: (FORM Event.objectName="label_@")
//OBJECT SET VISIBLE(*; "bEye_"+Substring(FORM Event.objectName; 7); True)
//: (FORM Event.objectName="bEye_@")
//OBJECT SET VISIBLE(*; FORM Event.objectName; True)
//End case 
//: (FORM Event.code=On Mouse Leave) && (FORM Event.objectName#"bEye_@")
//OBJECT SET VISIBLE(*; "bEye_@"; False)

//End case 


//If ($resetWidgetDesign)
//$isInModification:=sfw_checkIsInModification

//OBJECT SET ENTERABLE(*; "@entryField@"; $isInModification)
//If ($isInModification)
//$runValidationRules:=True
//OBJECT SET RGB COLORS(*; "@entryField@"; "black"; Background color)
//OBJECT SET BORDER STYLE(*; "@entryField@"; Border System)
//Else 
//$runValidationRules:=False
//OBJECT SET RGB COLORS(*; "@entryField@"; 0x00333333; Background color none)
//OBJECT SET BORDER STYLE(*; "@entryField@"; Border None)
//End if 
//End if 


//If ($runValidationRules) & (Form.current_item#Null)
//If (Form.sfw.entry.validationRules#Null)
//Form.canValidate:=True
//Form.validationRulesPassedWithSuccess:=True
//Form.validationRulesMessages:=New collection
//OBJECT SET RGB COLORS(*; "@entryField@"; "black"; Background color)
//For each ($rule; Form.sfw.entry.validationRules)
//$success:=True
//Case of 
//: ($rule.widget="") && ($rule.field="UUID_@")
//If ($rule.UUIDNotNull)
//Case of 
//: (Form.current_item[$rule.field]=Null)
//$success:=False
//: (Form.current_item[$rule.field]="")
//$success:=False
//: (Form.current_item[$rule.field]=("00"*16))
//$success:=False
//: (Form.current_item[$rule.field]=("20"*16))
//$success:=False
//End case 
//End if 

//Else 
//$type:=OB Get type(Form.current_item; $rule.field)
//If (Bool($rule.uppercase)) & ($type=Is text) & (FORM Event.code=On Data Change)
//Form.current_item[$rule.field]:=Uppercase(Form.current_item[$rule.field])
//End if 
//If (Bool($rule.lowercase)) & ($type=Is text) & (FORM Event.code=On Data Change)
//Form.current_item[$rule.field]:=Lowercase(Form.current_item[$rule.field])
//End if 
//If (Bool($rule.capitalize)) & ($type=Is text) & (FORM Event.code=On Data Change)
//Form.current_item[$rule.field]:=cs.sfw_string.me.stringCapitalize(Form.current_item[$rule.field])
//End if 

//If (Bool($rule.mandatory))
//Case of 
//: ($type=Is text)
//If (Form.current_item[$rule.field]="")
//$widget:=String($rule.widget)
//OBJECT SET RGB COLORS(*; $widget; "black"; 0x00FAA9AB)
//$success:=False
//End if 
//End case 
//End if 

//If (Bool($rule.unique))
//// Form.current_item[$rule.field]
//$isUnique:=ds.sfw_checkValidationRuleUnique(Form.sfw.entry.dataclass; $rule.field; Form.current_item[$rule.field]; Form.current_item.UUID)
//If ($isUnique=False)
//$widget:=String($rule.widget)
//OBJECT SET RGB COLORS(*; $widget; "black"; 0x00FAA9AB)
//$success:=False
//End if 
//End if 
//End case 
//Form.canValidate:=Form.canValidate && $success
//Form.validationRulesPassedWithSuccess:=Form.validationRulesPassedWithSuccess && $success
//If (Not($success)) && ($rule.message#Null)
//Form.validationRulesMessages.push($rule.message)
//End if 
//End for each 
//End if 
//End if 

//OBJECT GET SUBFORM CONTAINER SIZE($width_subform; $height_subform)

//If (Bool(Form.useAddressSubSubForm))
//If (FORM Event.code=On Load) | (FORM Event.code=On Bound Variable Change)
//If (Form.addressSubForm=Null)
//Form.addressSubForm:=New object
//End if 

//If (Form.current_item#Null)
//If (Form.current_item.contactDetails#Null)
//Form.addressSubForm.contactDetails:=Form.current_item.contactDetails
//End if 
//End if 
//Form.addressSubForm.situation:=Form.situation
//Form.addressSubForm:=Form.addressSubForm

//OBJECT GET COORDINATES(*; "address_subsubform"; $g; $h; $d; $b)
//OBJECT SET COORDINATES(*; "address_subsubform"; 5+(50*Num(Bool(Form.useTabBar))); $h; $width_subform-5; $h+180)

//End if 
//End if 

//If (Form.useCommunicationSubSubForm)

//OBJECT GET COORDINATES(*; "communication_subform"; $g; $h; $d; $b)
//OBJECT SET COORDINATES(*; "communication_subform"; 5+(50*Num(Bool(Form.useTabBar))); $h; $width_subform-5; $height_subform-5)


//End if 

//If (Bool(Form.usePageTab))
//OBJECT GET COORDINATES(*; "page_tab"; $g; $h; $d; $b)
//OBJECT SET COORDINATES(*; "page_tab"; 0; $h; $width_subform; $b)
//OBJECT SET COORDINATES(*; "line_tab"; 0; ($b+$h)/2; $width_subform; ($b+$h)/2)


//End if 

//If (Bool(Form.useHeaderBkgd))
//OBJECT GET COORDINATES(*; "header_bkgd"; $g; $h; $d; $b)
//OBJECT SET COORDINATES(*; "header_bkgd"; 0; 0; $width_subform; $b)

//End if 

//If (Bool(Form.useTabBar))
//OBJECT GET COORDINATES(*; "vTabBar_subform"; $g; $h; $d; $b)
//OBJECT SET COORDINATES(*; "vTabBar_subform"; 0; $h; $d; $height_subform)

//End if 

//Form.sfw.redrawButtons()

