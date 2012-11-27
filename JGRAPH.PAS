unit jgraph;
interface
uses graph, sdl;

var
 screen: PSDL_Surface;

type tanimation=object
 fcount:integer;
 play:boolean;
 frames:array[0..80] of pointer;
 faze:integer;
 procedure load(DirName:string);
 procedure draw(x,y:integer);
end;

function rgbcolor(r,g,b:byte):word;
function adist(a1,a2:single):single;
function loadsprite(fname:string):pSDL_SURFACE;
procedure putImg(x,y: integer; img: pSDL_SURFACE);
procedure putPixel(x,y: integer; color: word);
function getSprPixel(x,y: integer; surface: pSDL_SURFACE) : word;
function getPixel(x,y:word): word;
procedure setViewport(x,y,w,h: integer);
procedure flipSpriteX(surface: pSDL_SURFACE);

implementation
uses Dos, SDL_IMAGE, Strings;

var viewport: SDL_Rect;


function loadsprite(fname:string):pSDL_SURFACE;
var pname: array[0..255] of char;
begin
  strPCopy(@pname[0], fname);
  loadsprite := IMG_LOAD(@pname[0]);
  if (loadsprite = nil) then
  begin
   writeln('can''t load image: ' + fname);
   exit;
  end;
  SDL_SetColorKey(loadsprite, SDL_SRCCOLORKEY, $03E0);
end;

procedure putImg(x,y: integer; img: pSDL_SURFACE);
var rect: SDL_Rect;
begin
  rect.x := x + viewport.x;
  rect.y := y + viewport.y;
  rect.w := 0;
  rect.h := 0;
  SDL_BLITSURFACE(img,NIL,screen,@rect);
end;

procedure putPixel(x,y: integer; color: word);
var addr: ^word;
begin
   x := x + viewport.x;
   y := y + viewport.y;
   if (x >= viewport.x) and (x < viewport.w)
      and (y >= viewport.y) and (y < viewport.h) 
   then 
   begin
     addr := screen^.pixels + y * screen^.w * 2 + x * 2;
     addr^ := color;   
   end;
end;

function getSprPixel(x,y: integer; surface: pSDL_SURFACE) : word;
var addr: ^word;
begin
   if (x >= 0) and (x < surface^.w)
      and (y >= 0) and (y < surface^.h) 
   then 
   begin
     addr := surface^.pixels + y * surface^.w * 2 + x * 2;
     getSprPixel := addr^;   
   end 
   else getSprPixel := 0;
end;

function getPixel(x,y:word): word;
begin
  x := x + viewport.x;
  y := y + viewport.y;
  getPixel := getSprPixel(x,y,screen);
end;

procedure setViewport(x,y,w,h: integer);
var rect: SDL_Rect;
begin
  viewport.x := x;
  viewport.y := y;
  viewport.w := w;
  viewport.h := h;
  SDL_SetClipRect(screen, @viewport);
end;

function rgbcolor(r,g,b:byte):word;
begin
  rgbcolor:=(word(r) and $00F8)shl 7 + ((word(g) and $00F8) shl 2)+((word(b) and $00F8) shr 3);
end;

procedure putSprPixel(x,y: integer; surface: pSDL_SURFACE; color: word);
var addr: ^word;
begin
   if (x >= 0) and (x < surface^.w)
      and (y >= 0) and (y < surface^.h) 
   then 
   begin
     addr := surface^.pixels + y * surface^.w * 2 + x * 2;
     addr^ := color;   
   end;
end;


procedure flipSpriteX(surface: pSDL_SURFACE);
var x, y, rx: integer;
    left, right: word;
begin
  for x := 0 to surface^.w div 2 do
   for y := 0 to surface^.h do 
     begin 
       rx := surface^.w - x - 1;
       left := getSprPixel(x,y,surface);
       right := getSprPixel(rx, y, surface);
       putSprPixel(rx,y,surface,left);
       putSprPixel(x,y,surface, right);
     end
end;

procedure tanimation.draw(x,y:integer);
begin
 if faze>fcount then faze:=0;
 putImg(x,y,frames[faze]);
 if play then faze:=faze+1;
end;

function IntToStr(I: Longint): String;
var
  S: string[11];
begin
  Str(I:2, S);
  if s[1]=' ' then s[1]:='0';
  IntToStr := S;
end;

function fileexists(fn:string):boolean;
begin
end;
procedure tanimation.load(dirname:string);
var path:string[60];
    DirSearchRec: SearchRec;
    buf:string;
    i,j,k:integer;
    TotalFileCnt:Longint;
    FileList:array[1..100]of string;
begin
 TotalFileCnt:=0;
  path:='sprites\'+dirname;
  if (Path[Length(Path)] <> '\') then Path := Path + '\';
  FindFirst(Path + '*.tga', AnyFile, DirSearchRec);
  while DosError = 0 do
   begin
    if (DirSearchRec.Name <> '.') and (DirSearchRec.Name <> '..')
     then
      begin
       Inc(TotalFileCnt);
       FileList[TotalFileCnt]:=Path+DirSearchRec.Name;
      end;
    FindNext(DirSearchRec) ;
   end;

  for i:=1 to TotalFileCnt-1 do
   begin
    for j:=i+1 to TotalFileCnt do
     begin
      for k:=1 to length(FileList[i])do
       begin
        if byte(FileList[j,k])=byte(FileList[i,k]) then continue;
        if byte(FileList[j,k])<byte(FileList[i,k]) then
         begin buf:=FileList[i];FileList[i]:=FileList[j];FileList[j]:=buf;end;break;
       end;
     end;
   end;

 for i:=1 to TotalFileCnt do frames[i-1]:=loadsprite(FileList[i]);
 fcount:=TotalFileCnt-1;
 play:=false;faze:=0;
end;//Load

function Adist2(a1,a2:single):single;
 var cm0,cm1:single;
 begin

 end;

function adist(a1,a2:single):single;
begin
 while a1<0 do a1:=a1+3.1416*2;
 while a2<0 do a2:=a2+3.1416*2;
 while a1>3.1416*2 do a1:=a1-3.1416*2;
 while a2>3.1416*2 do a2:=a2-3.1416*2;
 if abs(a2-a1)<abs(a2-a1-3.1416*2) then adist:=a2-a1 else adist:=a2-a1-3.1416*2;
end;
begin
end.