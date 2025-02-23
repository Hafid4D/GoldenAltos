property title : Object
property areaSize : Object
property font : Object
property gutter : Integer
property refSvg : Text

Class constructor
	
	This.margin:=New object
	This.margin.left:=40
	This.margin.top:=20
	This.margin.right:=10
	This.margin.bottom:=50
	
	This.title:=New object
	This.title.height:=100
	This.title.text:=""
	This.title.subtext:=""
	This.title.font:=New object
	This.title.font.family:="Arial"
	This.title.font.size:=12
	
	This.font:=New object
	This.font.size:=10
	This.font.family:="Arial"
	
	This.gutter:=20
	This.areaSize:=New object
	
	This._series:=New collection
	
	
	//MARK:-management of area & graph size
Function setAreaSize($width : Integer; $height : Integer)
	
	This.areaSize.width:=$width
	This.areaSize.height:=$height
	
	This.areaSize.graphWidth:=This.areaSize.width-This.margin.left-This.margin.right
	If ((This.legend)#Null) & (This.legend.labels#Null)
		This.areaSize.graphWidth-=300
	End if 
	This.areaSize.graphHeight:=This.areaSize.height-This.margin.top-This.margin.bottom-This.title.height
	
	This.areaSize.graphLeft:=This.margin.left
	This.areaSize.graphRight:=This.areaSize.graphLeft+This.areaSize.graphWidth
	This.areaSize.graphTop:=This.margin.top+This.title.height
	This.areaSize.graphBottom:=This.areaSize.graphTop+This.areaSize.graphHeight
	
	//MARK:-management of data
Function set values($data : Collection)
	
	This._series:=$data
	This._nbSeries:=This._series.length
	
Function get values()->$data : Collection
	
	$data:=This._series
	
	
	//MARK:-management of the colors
Function _loadShades($parameters : Variant)->$colors : Collection  // Text : "blueShades", "redShades", etc. or or Collection = colors list 
	$max:=This._nbSeries
	
	$colors:=[]
	If (Count parameters=0)
		$parameters:=""
	End if 
	
	If (Value type($parameters)=Is text)
		
		Case of 
			: ($parameters="BlueShades")
				$colors.push("Orange")
				$colors.push("OrangeRed")
				$colors.push("DarkOrange")
				$colors.push("Tomato")
				$colors.push("Coral")
				$colors.push("Gold")
				$colors.push("Goldenrod")
				$colors.push("DarkGoldenrod")
				$colors.push("GreenYellow")
				$colors.push("Goldenrod")
				$colors.push("Peru")
				
			: ($parameters="RedShades")
				
			: ($parameters="OrangeShades")
				$shades.push("Orange")
				$shades.push("OrangeRed")
				$shades.push("DarkOrange")
				$shades.push("Tomato")
				$shades.push("Coral")
				$shades.push("Gold")
				$shades.push("Goldenrod")
				$shades.push("DarkGoldenrod")
				$shades.push("GreenYellow")
				$shades.push("Goldenrod")
				$shades.push("Peru")
				
			: ($parameters="YellowShades")
				$colors.push("Gold")
				$colors.push("PeachPuff")
				$colors.push("Yellow")
				$colors.push("LightYellow")
				$colors.push("DarkKhaki")
				$colors.push("LemonChiffon")
				$colors.push("PaleGoldenrod")
				$colors.push("LightGoldenrodYellow")
				$colors.push("Moccasin")
				$colors.push("PapayaWhip")
				$colors.push("Khaki")
				
			: ($parameters="ContrastingColors")
				
				$colors.push("Gold")
				$colors.push("PeachPuff")
				$colors.push("Yellow")
				$colors.push("LightYellow")
				$colors.push("DarkKhaki")
				$colors.push("LemonChiffon")
				$colors.push("PaleGoldenrod")
				$colors.push("LightGoldenrodYellow")
				$colors.push("Moccasin")
				$colors.push("PapayaWhip")
				$colors.push("Khaki")
				
			: ($parameters#"")
				$colors:=Split string($parameters; ";")
				
			Else 
				$colors:=Split string("darkred;red;orangered;darkgreen;green;olive;darkorange;orange;gold;yellow;saddiebrown"; ";")
		End case 
		
	Else 
		$colors:=$parameters
	End if 
	
	$nb:=($max\$colors.length)+1
	For ($i; 2; $nb)
		$colors:=$colors.combine($colors)
	End for 
	
	// MARK:-Drawing some common elements
Function _drawTitle
	
	If (This.title.text#Null)
		$label:=This.title.text
		$x:=0
		$y:=0
		$refTexte:=SVG_New_text(This.refSvg; $label; $x; $y; This.title.font.family; This.title.font.size; Plain; Align left)
	End if 
	If (This.title.subtext#Null)
		$label:=This.title.subtext
		$x:=0
		$y:=15
		$refTexte:=SVG_New_text(This.refSvg; $label; $x; $y; This.title.font.family; This.title.font.size; Plain; Align left)
	End if 