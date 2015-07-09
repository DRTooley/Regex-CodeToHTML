(* Orignally found at
http://courses.washington.edu/css448/zander/Code/set.p *)
program SetStuff(input, output);

{ Demo set abilities}

type
	Digit = set of 0..9;
var odds, evens, stuff1, stuff2, morestuff, empty: Digit;
begin
	odds := [1, 3, 5, 7, 9];
	evens := [0, 2, 4, 6, 8];
	empty = [];
	stuff1 := odds + [2, 4]; {union of two sets}
	stuff2 := evens * [2,4]; {intersection of two sets}
	morestuff := stuff1 - stuff2;  (*difference of two sets*)
	if 3 in stuff1 then
		writeln( "3 in the set" )
	else
		writeln( "3 not in the set" );
	if 4 in stuff2 then
		writeln( "4 in the set" )
	else
		writeln( "4 not in the set" );
	if stuff2 <= stuff1 then
		writeln( "is contained in" )
	else
		writeln( "is not contained in" );


end.
