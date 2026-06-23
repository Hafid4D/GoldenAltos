//%attributes = {}

// Purpose: Configure a new Write Pro document for portrait A/R list reports on A4 with usable margins.
// Parameters:
// $wp : Object — Write Pro area returned by WP New()
// Returns: nothing
// created by 4D/PS [2026-june-08]

#DECLARE($wp : Object)

// Purpose: Default WP page margins are ~2.5 cm; reduce to 1 cm so ~16.5 cm tables fit on A4 portrait.
// modified by 4D/PS [2026-june-08]
WP SET ATTRIBUTES:C1342($wp; wk layout unit:K81:78; wk unit cm:K81:135)
WP SET ATTRIBUTES:C1342($wp; wk page width; "21cm"; wk page height; "29.7cm")
WP SET ATTRIBUTES:C1342($wp; wk margin left:K81:11; "1cm"; wk margin right; "1cm"; wk margin top:K81:13; "1cm"; wk margin bottom; "1cm")
