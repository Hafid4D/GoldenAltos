//%attributes = {}
// Usage: $pattern_string:=GENERATE_CODE39_PATTERN ("AB")
#DECLARE($data : Text)->$barcodePattern : Text

var $code39_map : Object
var $char; $pattern : Text
var $i : Integer

// 1. Create the mapping object (full 43 characters)
$code39_map:=New object:C1471()
$code39_map["0"]:="nnswnwnnn"
$code39_map["1"]:="wnsnnwnsn"
$code39_map["2"]:="nwsnnwnsn"
$code39_map["3"]:="wwsnnnsnn"
$code39_map["4"]:="nnswnwsnn"
$code39_map["5"]:="wnswnwsnn"
$code39_map["6"]:="nwswnwsnn"
$code39_map["7"]:="nnsnwnwsn"
$code39_map["8"]:="wnsnwnwsn"
$code39_map["9"]:="nwsnwnwsn"
$code39_map["A"]:="wnnnsnwsn"
$code39_map["B"]:="nwnnsnwsn"
$code39_map["C"]:="wwnnsnsnn"
$code39_map["D"]:="nnwnsnwsn"
$code39_map["E"]:="wnwnsnsnn"
$code39_map["F"]:="nwwnsnsnn"
$code39_map["G"]:="nnnswwnsn"
$code39_map["H"]:="wnnswwnsn"
$code39_map["I"]:="nwnswwnsn"
$code39_map["J"]:="nnwswwnsn"
$code39_map["K"]:="wnnnnswsn"
$code39_map["L"]:="nwnnnswns"
$code39_map["M"]:="wwnnnsnns"
$code39_map["N"]:="nnwnnswsn"
$code39_map["O"]:="wnwnnnsns"
$code39_map["P"]:="nwwnnssnn"
$code39_map["Q"]:="nnnswwnsn"
$code39_map["R"]:="wnnswwnsn"
$code39_map["S"]:="nwnswwnsn"
$code39_map["T"]:="nnwswwnsn"
$code39_map["U"]:="wnnnnswss"
$code39_map["V"]:="nwnnnsnss"
$code39_map["W"]:="wwnnnsnss"
$code39_map["X"]:="nnwnnswss"
$code39_map["Y"]:="wnwnnnsns"
$code39_map["Z"]:="nwwnnssns"
$code39_map["-"]:="nnnswwnss"
$code39_map["."]:="wnnsnwnss"
$code39_map[" "]:="wnnsnswsn"
$code39_map["*"]:="nnswnwwns"  // The required Start/Stop signal
$code39_map["$"]:="nsnsnsnn"
$code39_map["/"]:="nsnsnnsn"
$code39_map["+"]:="nsnnsnsn"
$code39_map["%"]:="nnsnsnsn"

// 2. Add start/stop characters and force uppercase
$data:=Uppercase:C13($data)
var $full_data : Text
$full_data:="*"+$data+"*"

// 3. Loop and build the full pattern string with inter-character gaps ('n')
$barcodePattern:=""

For ($i; 1; Length:C16($full_data))
	$char:=$full_data[[$i]]
	$pattern:=$code39_map[$char]
	
	If ($pattern#Null:C1517)
		// Append character pattern + a narrow gap, as required by standard
		$barcodePattern:=$barcodePattern+$pattern+"n"
	End if 
End for 

$0:=$barcodePattern
