//%attributes = {}

//TRACE

$e:=ds:C1482.Quote.query("code == :1"; "Q294").first()

WParea:=WP New:C1317($e.optionalPreliminaryTxt_wr)
DIALOG:C40("__test")