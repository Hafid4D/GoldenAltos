//%attributes = {}
/*
_ga_createUsers

default password :  pSzjGX!Ey9P1c~p
hash : $2b$10$1KIfSf/DkyivGUKEeHHPDulQ51F9LSOuyFmHy6X9TvAXi1K79E4ri

*/
TRACE:C157
//TODO :change temporary to True
var $newUser : Object:=$1
var $user : cs:C1710.sfw_UserEntity
var $staff : cs:C1710.StaffEntity

$user:=ds:C1482.sfw_User.new()
$user.firstName:=$newUser.firstName
$user.lastName:=$newUser.lastName
$user.login:=$newUser.firstName+" "+$newUser.lastName

$password:="pSzjGX!Ey9P1c~p"
$user.accesses:=($user.accesses=Null:C1517) ? New object:C1471 : $user.accesses
$user.accesses.password:=(This:C1470.accesses.password=Null:C1517) ? New object:C1471 : This:C1470.accesses.password
$user.accesses.password.temporary:=True:C214
$user.accesses.password.sendTemporaryByMail:=True:C214
$user.accesses.password.temporaryPassword:=$password

$user.accesses.password.lastReset:=cs:C1710.sfw_stmp.me.now()

$user.accesses.password.hash:=Generate password hash:C1533($password; cs:C1710.sfw_passwordManager.me.hashOptions)

$res:=$user.save()

If (Not:C34($res.success))
	TRACE:C157
	
Else 
	
	//TODO : ADD Profiles
	
	//$UUIDProfile:=ds.sfw_UserProfile.query().extract("UUID")
	//$eInscription:=ds.sfw_UserInscription.new()
	//$eInscription.UUID:=Generate UUID
	//$eInscription.UUID_User:=Form.current_item.UUID
	//$eInscription.UUID_UserProfile:=$UUIDProfile
	//$eInscription.UUID_whoHasGiven:=cs.sfw_userManager.me.info.UUID
	//$eInscription.stmp_given:=cs.sfw_stmp.me.now()
	//$eInscription.moreData:=New object
	//$info:=$eInscription.save()
	//If ($info.success)
	//This.load_hl_permissions()
	//Form.current_item.UUID:=Form.current_item.UUID
	//End if 
	
	
End if 


$staff:=ds:C1482.Staff.new()
$staff.UUID_User:=$user.UUID
$staff.firstName:=$newUser.firstName
$staff.lastName:=$newUser.lastName
$staff.code:=String:C10($newUser.codeID; "00000#")

$staff.contactDetails:=New object:C1471(\
"addresses"; New collection:C1472(); \
"communications"; New collection:C1472()\
)

$staff.moreData:=New object:C1471(\
"retrainNotified"; False:C215\
)

$res:=$staff.save()

If (Not:C34($res.success))
	TRACE:C157
End if 