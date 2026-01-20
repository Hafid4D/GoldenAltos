//%attributes = {}
// Fonction utilitaire (méthode projet ou #DECLARE)
#DECLARE($byte : Integer) : Text
C_TEXT:C284($hexTable)
$hexTable:="0123456789abcdef"

$0:=Substring:C12($hexTable; (($byte >> 4) & 0x000F)+1; 1)+\
Substring:C12($hexTable; ($byte & 0x000F)+1; 1)