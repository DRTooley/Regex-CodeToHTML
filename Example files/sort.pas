PROGRAM Sort(input, output);
	CONST
		(* Max array size. 
		This is a two line comment
		Actually it's three*)
		MaxElts = 100;
	TYPE
		IntArrType = ARRAY [1..MaxElts] OF Integer;
	VAR 
		{ Indexes, exchange temp, array size.*)
		i, j, tmp, size: integer;
		/* Array of ints */
		arr: IntArrType;
	(* Read in the integers.
	Multiline example }
	PROCEDURE ReadArr(VAR size: Integer; VAR a: IntArrType);
		BEGIN
			size :=1;
			while NOT eof DO BEGIN
				readln(a[size]);
				IF NOT eof THEN
					size := size + 1
			END
		END;
	BEGIN
		ReadArr(size, arr);
		/* Sort using bubble sort.
		Multiline */
		FOR i := size -1 DOWNTO 1 DO
			FOR j := 1 TO i DO
				IF arr[j] > arr[j+1] THEN BEGIN
					tmp := arr[j];
					arr[j] := arr[j+1];
					arr[j+1] := tmp;
				END;
		(* Print. }
		FOR i := 1 TO size DO
			writeln(arr[i])
	END.
