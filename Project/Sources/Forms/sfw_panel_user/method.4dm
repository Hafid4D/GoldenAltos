cs:C1710.sfw_panel_user.me.formMethod()


//If (Form.current_item#Null)
//Form.canValidate:=(Form.current_item.firstName#"") && (Form.current_item.lastName#"")
//If (Form.current_item.login="") & (Form.canValidate)
//Form.current_item.setLogin()
//End if 

//End if 

//OBJECT SET ENABLED(*; "cb_asDesigner"; sfw_checkIsInModification)
//OBJECT SET ENABLED(*; "cb_isInactive"; sfw_checkIsInModification)
//OBJECT SET ENABLED(*; "btn_reset"; sfw_checkIsInModification && Not(Form.situation.mode="add") && (Not(Form.current_item.isInactive)))
//Form.sfw.redrawButtons()

