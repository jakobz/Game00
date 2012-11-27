unit ugame;

interface
procedure InitGame;
procedure Move;
procedure Draw;

implementation
uses sdl,ugamedta,ufx,jgraph,uinit,uplayer,ugen,umissles,strings;
var sx,sy:integer;

procedure InitGame;
begin
// MultiKeysInit;
 InitData;
 initstars;
 initparticles;
 initplayer;
 initmissle;
 sx:=0;sy:=0;
end;

procedure keys;
begin
end;

procedure draw;
var i:integer;
    x,y:word;
    sdg:string[3];
    znk:byte;

 procedure dr;
 begin
  if sx<0 then sx:=0;
  if sy<0 then sy:=0;
  if sx>lxs-(sxsize div 2) then sx:=lxs-(sxsize div 2);
  if sy>lys-(sysize) then sy:=lys-(sysize);
  putImg(-sx, -sy, level);
  drawstars(sx,sy);
  drawparticles(sx,sy);
  drawmissle(sx,sy);
  drawplayer(sx,sy);
 end;

 procedure drawpanel;
 begin
  putImg(sxsize div 2 - 200,sysize-60,lbar);
  putImg(sxsize div 2 + 52,sysize-60,rbar);
  llife1.faze:=trunc(player[1].hitpoint/10);
  llife0.faze:=trunc(player[0].hitpoint/10);
  llife1.draw(sxsize div 2 - 200,sysize-60);
  llife0.draw(sxsize div 2 + 52,sysize-60);
 end;

begin //Draw
 SDL_FillRect(screen, nil, $FFFF); 

 setviewport(0,0,sxsize div 2 - 1,sysize-1);
 sx:=trunc(player[1].x-sxsize div 4+35);
 sy:=trunc(player[1].y-sysize div 2+35);
 dr;

 setviewport(sxsize div 2 + 1, 0, sxsize-1, sysize-1);
 sx:=trunc(player[0].x-sxsize div 4+35);
 sy:=trunc(player[0].y-sysize div 2+35);
 dr;

 setviewport(0,0,sxsize-1,sysize-1);
 drawpanel;

 //радар
 setviewport(sxsize div 2 - 50,sysize-100,sxsize div 2+50,sysize);
 for y:=0 to 100 do
  for x:=0 to 100 do
   if getsprpixel(x*20,y*20,level)<>0 then putpixel(x,y,$FFFF) else putpixel(x,y,rgbcolor(50,50,50));
 for x:=0 to maxplay do
  begin
   putpixel(trunc((player[x].x+35)/20)+1,trunc((player[x].y+35)/20),$D800);
   putpixel(trunc((player[x].x+35)/20)-1,trunc((player[x].y+35)/20),$D800);
   putpixel(trunc((player[x].x+35)/20),trunc((player[x].y+35)/20)+1,$D800);
   putpixel(trunc((player[x].x+35)/20),trunc((player[x].y+35)/20)-1,$D800);
   putpixel(trunc((player[x].x+35)/20),trunc((player[x].y+35)/20),$F800);
  end;
end;//Draw

procedure move;
begin
 fizparticles;
 controlplayer;
 fizmissle;
 fizplayer;
end;

begin
end.