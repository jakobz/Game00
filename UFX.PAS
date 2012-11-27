unit ufx;
interface

procedure initstars;
procedure drawstars(sx,sy:integer);

procedure initparticles;
procedure drawparticles(sx,sy:integer);
procedure fizparticles;
implementation
uses ugamedta,uinit,jgraph;

procedure initstars;
var i:integer;
begin
 for i:=0 to maxstars do
  with stars[i] do
   begin
    x:=random(sxsize);
    y:=random(sysize);
    z:=((random*random))/2+0.1;
    c:=rgbcolor(trunc(z*2*$FF),trunc(z*2*$FF),trunc(z*2*$FF));
   end;
end;

procedure drawstars(sx,sy:integer);
var i:integer;
    c:word;
    xx,yy:word;
begin
 for i:=0 to maxstars do
  with stars[i] do
   begin
    xx:=trunc(x-sx*z+10000) mod sxsize;
    yy:=trunc(y-sy*z+10000) mod sysize;
    if getpixel(xx,yy)=0 then putpixel(xx,yy,c);
   end;
end;

procedure initparticles;
var i:integer;
begin
 for i:=0 to maxpart do
  with particles[i] do
   begin
    x:=0;
    y:=0;
    xv:=0;
    yv:=0;
    life:=0;
    color:=rgbcolor(random($80)+$80,0,0);
   end;
end;

procedure drawparticles(sx,sy:integer);
var i:integer;
    c:word;
begin
 for i:=0 to maxpart do
  with particles[i] do
   if life>1 then
   begin
    putpixel(trunc(x-sx),trunc(y-sy),color div life);
   end
   else
   if life=1 then
    putpixel(trunc(x-sx),trunc(y-sy),$FFFF);
end;

procedure fizParticles;
var I:integer;
begin
 for i:=0 to maxpart do
  with particles[i] do
   if life>0 then
   begin
     x:=x+xv;y:=y+yv;
     life:=life-1;
   end;
end;

begin
end.