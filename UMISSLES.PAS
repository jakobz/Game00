unit umissles;

interface

procedure initmissle;
procedure fizmissle;
procedure drawmissle(sx,sy:word);
implementation
uses ugamedta,ugen,uinit,keyboard,jgraph,graph;

procedure initmissle;
var i:word;
begin
 for i:=0 to maxmiss do
 with missles[i] do
  if life>0 then
  begin
   x:=300;y:=400;a:=0;xv:=0;yv:=0;v:=0;a:=0;life:=0;daddy:=100;
  end;
end;

procedure fizmissle;
var i,j:word;
    a1:single;
begin
 for i:=0 to maxmiss do
 with missles[i] do
  if life>0 then
  begin
   life:=life+1;
   case ftype of
   rocket:
     begin
      x:=x+xv+v*cos(a);y:=y+yv+v*sin(a);v:=v+0.2;
      //Самонаведение
      if sn>0 then
       begin
        if player[target].x+20-x>0 then a1:=arctan((player[target].y+20-y)/(player[target].x+20-x));
        if player[target].x+20-x<0 then a1:=3.1416-arctan((player[target].y+20-y)/(x-player[target].x-20));
        if abs(adist(a,a1))<sn then a:=a+adist(a,a1)/snv;
       end;
      for j:=0 to 2 do particle(x,y,cos(a-3.1416)*10+xv+random*6-3,sin(a-3.1416)*10+yv+random*6-3,rgbcolor(0,0,180),random(5)+5);
     end;//rocket
   lrocket: begin x:=x+xv-5*cos(a+3.1416/2);y:=y+yv-5*sin(a+3.1416/2);
                  if life>8 then begin ftype:=rocket;
                                       for j:=0 to 30 do particle(x,y,cos(a-3.1416)*15+xv+random*10-5,sin(a-3.1416)*15+yv+random*10-5,rgbcolor(0,0,255),random(5)+5);
                                       life:=1;
                                 end;
            end;//lrocket
   rrocket: begin x:=x+xv+5*cos(a+3.1416/2);y:=y+yv+5*sin(a+3.1416/2);
                  if life>8 then begin ftype:=rocket;
                                       for j:=0 to 30 do particle(x,y,cos(a-3.1416)*15+xv+random*10-5,sin(a-3.1416)*15+yv+random*10-5,rgbcolor(0,0,255),random(5)+5);
                                       life:=1;
                                 end;
            end;//rrocket
   end;//case
   if getsprpixel(trunc(x),trunc(y),level)<>0 then life:=0;
   if life=0 then explosion(x,y,50,$F800,20);
  end;//if life>0
end;//FizMissle

procedure drawmissle(sx,sy:word);
var i:word;
begin
 for i:=0 to maxmiss do
 with missles[i] do
  if life>0 then
  begin
   an^.faze:=trunc((a+3.1416*0.5)*5.7+1)mod 36;
   an^.draw(trunc(x-sx-15),trunc(y-sy-15));
  end;
end;

begin
end.