// Purpose: Profile idents allowed to edit Quality Assurance records (aligned with Staff.setAllowedProfiles).
// Returns: Collection of Text — qs (Quality Supervisor), qi (Quality Inspector), qm (Quality Manager)
// created by 4D/PS [2026-may-21]
#DECLARE->$profiles : Collection

$profiles:=New collection:C1472("qs"; "qi"; "qm")
