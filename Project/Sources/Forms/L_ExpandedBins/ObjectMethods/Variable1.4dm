// Purpose: Legacy object method disabled for GoldenAltos (device table / Template_definitions / GetPictureFormDeviceTable). The form widget no longer references this file.
// modified by 4D/PS [2026-april-27]
// Case of 
// 	: (Form event code:C388=On Load:K2:1)
// 		Case of 
// 			: (IsDeviceTableLinked=True:C214) & (([Template_definitions:49]MiscellaneousControl:42 & 0x0200)=0x0200)
// 			Else 
// 				OBJECT SET VISIBLE:C603(Markpict; False:C215)
// 				OBJECT SET VISIBLE:C603(*; "MarkPicture"; False:C215)
// 		End case 
// 		
// 	: (Form event code:C388=On Printing Detail:K2:18)
// 		Case of 
// 			: (IsDeviceTableLinked=True:C214) & (([Template_definitions:49]MiscellaneousControl:42 & 0x0200)=0x0200)
// 				READ ONLY:C145([DeviceTable:85])
// 				QUERY:C277([DeviceTable:85]; [DeviceTable:85]UniqueDeviceID:1=[Lotinfo:12]LinkToDeviceTable:170)
// 				GetPictureFormDeviceTable(260; 130)
// 			Else 
// 				OBJECT SET VISIBLE:C603(Markpict; False:C215)
// 				OBJECT SET VISIBLE:C603(*; "MarkPicture"; False:C215)
// 				
// 		End case 
// 		
// 		
// End case 
