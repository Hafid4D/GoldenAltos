//%attributes = {}
// Usage: $svgPicture:=GENERATE_CODE39_SVG("AB")
#DECLARE($data : Text)->$barcodeSvgPic : Picture

var $patternString : Text
var $x; $barWidth; $height : Integer
var $svgRef : Text
var $rectRef : Text

$patternString:=GENERATE_CODE39_PATTERN($data)
$x:=10  // Start after a small quiet zone
$height:=80
var $narrowWidth : Integer
$narrowWidth:=2  // Base unit width for 'n'

// 1. Create a new SVG canvas
$svgRef:=SVG_New(500; 100)

// 2. Loop through the pattern string and draw rectangles
For ($i; 1; Length:C16($patternString))
	$char:=$patternString[[$i]]
	
	// Determine if Wide or Narrow width
	If ($char="w")
		$barWidth:=$narrowWidth*3
	Else 
		$barWidth:=$narrowWidth
	End if 
	
	// In the full pattern string, bars and spaces alternate.
	// Odd indices are bars to be drawn black. Even are spaces (leave white).
	var $isBar : Boolean
	$isBar:=($i%2#0)
	
	If ($isBar)
		// Create a black rectangle using SVG_New_rect
		// The last parameter 'fill' can take a color name like "black"
		$rectRef:=SVG_New_rect($svgRef; $x; 0; $barWidth; $height; 0; 0; "black")
	End if 
	
	$x:=$x+$barWidth  // Move the X cursor for the next element
End for 

// 3. Export the SVG to a 4D Picture variable
$barcodeSvgPic:=SVG_Export_to_picture($svgRef)

// 4. Clean up the SVG reference from memory
SVG_CLEAR($svgRef)

$0:=$barcodeSvgPic




//// Usage: $svgPicture:=GENERATE_CODE39_SVG("AB")
////#DECLARE($data : Text)->$barcodeSvgPic : Picture

//var $patternString : Text
//var $x; $barWidth; $height : Integer
//var $svgRef : Text
//var $rectRef : Text
//$data:="AB"
//// Use the pattern generation method from the previous step
//$patternString:=GENERATE_CODE39_PATTERN($data)
//$x:=0
//$height:=80  // Bar height in user points
//var $narrowWidth : Integer
//$narrowWidth:=2  // Base unit width for 'n' (adjust this to change overall width)

//// 1. Create a new SVG document in memory
//$svgRef:=SVG_New(500; 100)  // Create an SVG canvas

//// 2. Loop through the pattern string (n, w, n, s, etc.) and draw rectangles
//For ($i; 1; Length($patternString))
//$char:=$patternString[[$i]]

//If ($char="w")  // Wide bar/space (3x narrow width)
//$barWidth:=$narrowWidth*3
//Else   // Narrow bar/space (1x narrow width)
//$barWidth:=$narrowWidth
//End if 

//// We only draw the black bars (odd indices in the full sequence are bars)
//// This logic needs to align with how the pattern string was built
//// A better approach is to assume the pattern string is just the widths:

//// --- Simplified drawing logic: ---
//// Instead of drawing only odd indices, check if the current element is a "bar" or a "space".
//// Since the pattern alternates bar/space:
//var $isBar : Boolean
//$isBar:=($i%2#0)

//If ($isBar)  // Draw a black rectangle
//$rectRef:=SVG_New_rect($svgRef; $x; 0; $barWidth; $height)
//SVG_SET_ATTRIBUTE($rectRef; "fill"; "black")
//End if 

//$x:=$x+$barWidth  // Move the starting X position for the next element
//End for 

//// 3. Export the SVG to a 4D Picture variable for display or saving
//$barcodeSvgPic:=SVG_Export_to_picture($svgRef)

//// 4. Clean up the SVG reference from memory
//SVG_CLEAR($svgRef)

//$0:=$barcodeSvgPic
