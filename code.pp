program sudokuNEW;

type
	part3 = array[1..9,1..9,1..9] of integer;
	bool4 = array[1..9,1..9,1..9,1..9] of boolean;

var
	cells : part3;
	cellPoss : bool4;
	kill : boolean;
	//change1, change2, change3, change4 : boolean;

function boxPos(col,row:integer) : integer;
	begin
		if row in [1..3] then begin
			if col in [1..3] then boxPos := 1;
			if col in [4..6] then boxPos := 2;
			if col in [7..9] then boxPos := 3;
		end;

		if row in [4..6] then	begin
			if col in [1..3] then boxPos := 4;
			if col in [4..6] then boxPos := 5;
			if col in [7..9] then boxPos := 6;
		end;

		if row in [7..9] then	begin
			if col in [1..3] then boxPos := 7;
			if col in [4..6] then boxPos := 8;
			if col in [7..9] then boxPos := 9;
		end;
	end;

    
procedure readCells(var cells:part3);
	var
		rloop, cloop : integer;

	begin
		for rloop := 1 to 9 do begin
			for cloop := 1 to 9 do
				read(cells[cloop,rloop,boxPos(cloop,rloop)]);
				readln;
		end;
	end;

    
procedure writeCells(cells:part3);
	var
		cloop,rloop,bloop : integer;

	begin
		writeln;
		for rloop := 1 to 9 do begin
			for cloop := 1 to 9 do begin
				for bloop := 1 to 9 do begin
					if cells[cloop,rloop,bloop] < 10 then
						write(cells[cloop,rloop,bloop],' ');
				end;
			end;
			writeln;
		end;
	end;

    
procedure setTen(var cells:part3);
	var
		cloop,rloop,bloop : integer;

	begin
		for bloop := 1 to 9 do
			for rloop := 1 to 9 do
				for cloop := 1 to 9 do
					cells[cloop,rloop,bloop] := 10;
	end;

    
procedure setTrue(var bools:bool4);
	var
		cloop,rloop,bloop,nloop : integer;

	begin
		for bloop := 1 to 9 do
			for rloop := 1 to 9 do
				for cloop := 1 to 9 do
					for nloop := 1 to 9 do
						bools[cloop,rloop,bloop,nloop] := true;
	end;

    
function setPossFalse(row,col,box,num : integer; var cellPoss:bool4; cells:part3) : boolean;
	var
		cloop,rloop,bloop: integer;
		changed : boolean;

	begin
		changed := false;
		for rloop := 1 to 9 do
			for cloop := 1 to 9 do
				for bloop := 1 to 9 do
					if cells[cloop, rloop, bloop] < 10 then begin
						if((rloop = row) OR (cloop = col) OR (bloop = box)) then 
							if(cellPoss[cloop,rloop,bloop,num] = true) then begin
								cellPoss[cloop,rloop,bloop,num] := false;
								changed := true;
							end;
						end;
		setPossFalse := changed;
	end;

    
function setPoss(var cellPoss:bool4; cells:part3) : boolean;
	var
		cloop,rloop,bloop,num : integer;
		changed : boolean;

	begin
		changed := false;
		for rloop := 1 to 9 do
			for cloop := 1 to 9 do
				for bloop := 1 to 9 do
					if cells[cloop, rloop, bloop] < 10 then begin
						if cells[cloop,rloop,bloop] > 0 then begin
							num := cells[cloop,rloop,bloop];
							if(setPossFalse(rloop,cloop,bloop,num,cellPoss,cells)) then changed := true;
						end;
					end;
		setPoss := changed;
	end;

    
function onePoss(cellPoss:bool4; var cells:part3) : boolean;
	var
		cloop,rloop,bloop,nloop,numPoss,lastNum : integer;
		changed : boolean;

	begin
		changed := false;
		for rloop := 1 to 9 do
			for cloop := 1 to 9 do
				for bloop := 1 to 9 do
					if cells[cloop,rloop,bloop] = 0 then begin
						numPoss := 0;
						write('(',cloop,',',rloop,',',bloop,'): ');
						for nloop := 1 to 9 do
							if cellPoss[cloop,rloop,bloop,nloop] = true then begin
								write(nloop, ' ');
								numPoss := numPoss + 1;
								lastNum := nloop;
							end;
						writeln;
						if numPoss = 1 then begin
							writeln('[',cloop,',',rloop,',',bloop,']: ',lastNum);
							cells[cloop,rloop,bloop] := lastNum;
							changed := true;
						end;
					end;
		onePoss := changed;
	end;
    
    
function onlyPoss(cellPoss:bool4; var cells:part3) : boolean;
	var
		cloop,rloop,bloop,nloop: integer;
		cloop2,rloop2,bloop2 : integer;
		onlyr,onlyc,onlyb,changed : boolean;

	begin
		changed := false;
		for rloop := 1 to 9 do
			for cloop := 1 to 9 do
				for bloop := 1 to 9 do
					if cells[cloop,rloop,bloop] = 0 then
						for nloop := 1 to 9 do begin
							if cellPoss[cloop,rloop,bloop,nloop] = true then begin
								writeln('Entered only');
								onlyr := true;
								onlyc := true;
								onlyb := true;

								for rloop2 := 1 to 9 do
									for cloop2 := 1 to 9 do
										for bloop2 := 1 to 9 do
											if(not ((rloop2=rloop) and (cloop2=cloop) and (bloop2=bloop))
											and (cells[cloop2,rloop2,bloop2] = 0)
											and (cellPoss[cloop2,rloop2,bloop2,nloop]) ) then begin
												writeln('(',cloop,',',rloop,',',bloop,') (',cloop2,',',rloop2,',',bloop2,') ',
												nloop);
												if(rloop2=rloop) then begin
													onlyr := false; writeln('onlyr false'); END;
												if(cloop2=cloop) then begin
													onlyc := false; writeln('onlyc false'); END;
												if(bloop2=bloop) then begin
													onlyb := false; writeln('onlyb false'); END;
											end;
								
								if(onlyr or onlyc or onlyb) then begin
									writeln('[',cloop,',',rloop,',',bloop,']: ',nloop);
									cells[cloop,rloop,bloop] := nloop; 
									onlyPoss := true; 
									exit;
								end;
							end;
						end;
		onlyPoss := changed;
	end;

procedure checkFin(cells:part3; var kill : boolean);
	var
		cloop,rloop,bloop,count : integer;

	begin
		count := 0;

		for rloop := 1 to 9 do
			for cloop := 1 to 9 do
				for bloop := 1 to 9 do
					if cells[cloop,rloop,bloop] < 10 then
						if cells[cloop,rloop,bloop] = 0 then
							count:= count + 1;

		if count = 0 then kill := true;
	end;

procedure printPoss(cp:bool4);
	var   r,c,b,n : integer;
	begin
		for r := 1 to 9 do
			for c := 1 to 9 do begin
				for b := 1 to 9 do
					for n := 1 to 9 do
						if(b=boxPos(c,r)) then write(cp[c,r,b,n], ' ');
					writeln;
			end;
		writeln;
	end;

begin
	writeln('...: Sudoku Solver');
	writeln('by Charlie Seymour');
	writeln;
	writeln('Enter each number one at a time (blanks as 0s), leaving a space after each one and pressing enter at the end of a row.');
	writeln;

	setTen(cells);
	setTrue(cellPoss);

	readCells(cells);
	writeln;

	repeat
		setPoss(cellPoss,cells);
		onePoss(cellPoss,cells);
		setPoss(cellPoss,cells);
		//printPoss(cellPoss);
		onlyPoss(cellPoss,cells);
		//printPoss(cellPoss);
		writeCells(cells);
		checkFin(cells,kill);
	until kill = true;

	writeln('Done!');
	writeCells(cells);
	writeln;
	write('Press [Enter] to quit ');

	readln;
end.