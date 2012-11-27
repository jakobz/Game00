USES sdl,crt,ugame,graph,uinit, jgraph;
VAR testEvent:pSDL_EVENT;
   spr: pSDL_Surface;
   time, newTime: longword;
   step: integer;
   stepsCnt: integer;   

procedure toggleKey(code: integer; down: boolean);
begin
  if code = 273 then cbutton[0,bup] := down;
  if code = 274 then cbutton[0,bdown] := down;
  if code = 276 then cbutton[0,bleft] := down;
  if code = 275 then cbutton[0,bright] := down;
  if code = 91 then cbutton[0,bweapon1] := down;
  if code = 112 then cbutton[0,bweapon2] := down;
  if code = 111 then cbutton[0,btabwp2] := down;
  if code = 44 then cbutton[0,blstrafe] := down;
  if code = 46 then cbutton[0,brstrafe] := down;

  if code = 114 then cbutton[1,bup] := down;
  if code = 102 then cbutton[1,bdown] := down;
  if code = 100 then cbutton[1,bleft] := down;
  if code = 103 then cbutton[1,bright] := down;
  if code = 113 then cbutton[1,bweapon1] := down;
  if code = 97 then cbutton[1,bweapon2] := down;
  if code = 9 then cbutton[1,btabwp2] := down;
  if code = 122 then cbutton[1,blstrafe] := down;
  if code = 120 then cbutton[1,brstrafe] := down;
end;


BEGIN
  SDL_Init(SDL_INIT_VIDEO); // Initialize the video SDL subsystem
  screen := SDL_SetVideoMode(sxsize, sysize, 16, SDL_HWSURFACE or SDL_FULLSCREEN); // Create a software window of 640x480x8 and assign to scr

  write('Loading... ');
  InitData;
  InitGame;
  writeln('done');

  time := SDL_GetTicks;

  REPEAT  

    new(testEvent);

    WHILE SDL_POLLEVENT(testEvent) = 1 DO
    BEGIN
      CASE testEvent^.type_ OF
        SDL_KEYDOWN: BEGIN
		       toggleKey(testEvent^.key.keysym.sym, true);
                       IF testEvent^.key.keysym.sym=27 THEN exit;
                   END;
        SDL_KEYUP: toggleKey(testEvent^.key.keysym.sym, false);
        SDL_QUITEV: exit;
      END;
    END;

    step := 20;
    stepsCnt := 0;

    newTime := SDL_GetTicks;
    while newTime - time > step do
    begin 
      move;
      time := time + step;
      stepsCnt := stepsCnt + 1;
      if stepsCnt > 10 then break;                               
    end;

    draw;

    SDL_FLIP(screen);
    SDL_DELAY(10);
  UNTIL FAlSE;
END.
