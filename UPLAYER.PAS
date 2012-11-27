unit uplayer;

interface

procedure initplayer;
procedure fizplayer;
procedure drawplayer(sx,sy:word);
procedure controlplayer;
implementation
uses ugamedta,ugen,uinit,jgraph;

procedure initplayer;
var i:integer;
begin
 for i:=0 to maxplay do
 with player[i] do
  begin
   if i=0 then x:=100 else x:=1800;
   y:=100;a:=0;xv:=0;yv:=0;v:=0;a:=1.578;reload:=0;hitpoint:=100;frags:=0;alive:=true;av:=0;
  end;
end;

procedure fizplayer;
var i,j:byte;dx,dy,r,ra,cx,cy,mx,my,ma,x1,x2,y1,y2:single;c:boolean;cc:word;
begin
 for i:=0 to maxplay do
 if player[i].alive then
 with player[i] do
  begin
   a:=a+av;
   xv:=xv/1.02;yv:=yv/1.02;av:=av/1.1;
   xv:=xv+v*cos(a);yv:=yv+v*sin(a);
   x:=x+xv;y:=y+yv;
   if v>0 then for j:=0 to 5 do particle(x,y,cos(a-3.1416)*5+xv+random-0.5,sin(a-3.1416)*5+yv+random-0.5,$FF00,20+random(10))
          else particle(x,y,cos(a-3.1416)*1+xv+random-0.5,sin(a-3.1416)*1+yv+random-0.5,$F000,10+random(10));
   v:=0;
//  Столкновение кораблей
   for j:=0 to maxplay do
   if (i<>j) and player[j].alive then
    begin
     dx:=x-player[j].x;
     dy:=y-player[j].y;
     r:=sqrt(dx*dx+dy*dy);
     ra:=arctan(dy/dx);

     if dx<0 then ra:=ra+3.1416;
     if xv=0 then if yv<0 then ma:=-1.578 else ma:=1.578
             else ma:=arctan(yv/xv);
     if xv<0 then ma:=ma+3.1416;
     ma:=ma+3.1416;
     if r<50 then
      begin

       xv:=xv+cos(ra);
       yv:=yv+sin(ra);
       av:=adist(a,ma)/20;
       explosion(x+dx*cos(ra)/2,y+dy*sin(ra)/2,10,$00FF,20);
      end;
    end;  
//Столкновение со стенами
    ma:=0;c:=false;cc:=0;mx:=0;my:=0;
    while ma<(2*3.1416+0.1) do
     begin
      cx:=-20*cos(ma)+x;
      cy:=-20*sin(ma)+y;
      if getsprpixel(trunc(cx),trunc(cy),level)<>0
      then begin mx:=mx+cos(ma);my:=my+sin(ma);cc:=cc+1; c:=true; end;
      ma:=ma+3.1416/10;
     end;
     if c then
     begin
      if mx>0 then ra:=arctan(my/mx) else ra:=3.1416+arctan(my/(mx-0.00001));
      xv:=xv+cos(ra)*cc/3;
      yv:=yv+sin(ra)*cc/3;
      x:=x+cos(ra)*cc*cc/2;
      y:=y+sin(ra)*cc*cc/2;
      explosion(x-20*cos(ra),y-20*sin(ra),10,$00FF,3);
     end;  
//Столкновение с ракетами 
    x1:=x-30;x2:=x+30;
    y1:=y-30;y2:=y+30;
    for j:=0 to maxmiss do
     if (missles[j].ftype>=rocket) and (missles[j].life>3) then
      if (missles[j].x<x2) and (missles[j].x>x1)
         and (missles[j].y<y2) and (missles[j].y>y1) then
          begin
           explosion(x,y,60,$F600,10);
           dec(player[i].hitpoint,missles[j].damage);
           xv:=xv+cos(missles[j].a);
           yv:=yv+sin(missles[j].a);
           if player[i].HitPoint<1 then
            begin
             explosion(x,y,200,$FFF0,30);
             if missles[j].daddy<>i then inc(player[missles[j].daddy].frags)
              else dec(player[missles[j].daddy].frags);
             alive:=false;
            end;
           missles[j].life:=0;
          end;                
  end;
end;

procedure drawplayer(sx,sy:word);
var i:byte;
begin
 if player[0].alive then
 with player[0] do
  begin
   if a<0 then a:=a+3.1416*2;
   if a>(3.1416*2) then a:=a-3.1416*2;
   pedoship.faze:=trunc((a+3.1416*0.5)*5.7+1)mod 36;
   pedoship.draw(trunc(x-sx-35),trunc(y-sy-35));
  end;
 if player[1].alive then
 with player[1] do
  begin
   if a<0 then a:=a+3.1416*2;
   if a>(3.1416*2) then a:=a-3.1416*2;
   antipedo.faze:=trunc((a+3.1416*0.5)*5.7+1)mod 36;
   antipedo.draw(trunc(x-sx-35),trunc(y-sy-35));
  end;
end;

procedure controlplayer;
var i:word;
begin
 for i:=0 to maxplay do
  begin
   with player[i] do
    begin
     if alive then
      begin
       if cbutton[i,bup] then v:=0.2;
       if cbutton[i,bdown] then  v:=-0.1;
       if cbutton[i,bleft] then a:=a-3.14/36;
       if cbutton[i,bright] then a:=a+3.14/36;
       if cbutton[i,blstrafe] then begin    xv:=xv+0.5*cos(a-3.1416/2);yv:=yv+0.5*sin(a-3.1416/2);end;
       if cbutton[i,brstrafe] then begin    xv:=xv+0.5*cos(a+3.1416/2);yv:=yv+0.5*sin(a+3.1416/2);end;
       if cbutton[i,bweapon1] then plazma(x,y,xv,yv,a+random*0.1-0.05,i);
       if cbutton[i,bweapon2] and (reload>10) then
        begin missle(x,y,xv,yv,a,left,i); reload:=0; left:=not(left);end;
       if cbutton[i,btabwp2] then ;
       inc(reload);
      end
      else if cbutton[i,bweapon1] then begin alive:=true;y:=100;hitpoint:=100;
                                                 if i=1 then x:=1800 else x:=100;
                                                end;
    end;
  end;
end;

begin
end.