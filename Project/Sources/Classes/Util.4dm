singleton Class constructor
	
Function trim($text : Text; $chars : Collection)->$result : Text
	$result:=$text
	For each ($char; $chars)
		$items:=Split string:C1554($result; $char; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
		$result:=$items.join($char)
	End for each 
	