// Purpose: Legacy object method disabled for GoldenAltos; inverted yield on print detail for PDA form. The form widget no longer references this file. Re-enable by binding ObjectMethods/Field6.4dm on the widget and uncommenting below after validating LotStep.moreData.yield semantics.
// modified by 4D/PS [2026-april-27]
// Case of 
// 	: (Form event code:C388=On Printing Detail:K2:18)
// 		[LotStep:5]moreData.yield:=100-[LotStep:5]moreData.yield
// End case 
