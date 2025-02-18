Class extends Entity


local Function isDeletable()->$isDeletable : Boolean
	// This callback must return false to inactivate the deletion mode for the current item.
	$isDeletable:=(ds:C1482.TrainingTime.query("UUID_Trainee = :1"; This:C1470.UUID).length=0)
	