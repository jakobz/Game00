unit ugen;
interface
uses graph;
 procedure particle(px,py,pxv,pyv:single;pcolor:word;plife:word);
 procedure explosion(x,y:single;c:word;cl:word;l:word);
 procedure missle  (px,py,pxv,pyv,pa:single;l:boolean;parent:byte);
 procedure plazma  (px,py,pxv,pyv,pa:single;parent:byte);
implementation
uses ugamedta,jgraph,uinit;
var mf:byte;

 procedure particle(px,py,pxv,pyv:single;pcolor:word;plife:word);
  var i:word;
  begin
   for i:=0 to maxpart do
    with particles[i] do
     if life=0 then
      begin
       x:=px;y:=py;xv:=pxv;yv:=pyv;color:=pcolor;life:=plife;
       break;
      end;
  end;

 procedure explosion(x,y:single;c:word;cl:word;l:word);
  var i:byte;
   begin
    for i:=0 to c do
     particle(x,y,random*5-2,random*5-2,cl,random(10)+l);
   end;

 procedure missle  (px,py,pxv,pyv,pa:single;l:boolean;parent:byte);
  var i:word;
  begin
   for i:=0 to maxmiss do
    with missles[i] do
     if life=0 then
      begin
       x:=px;y:=py;a:=pa;
       xv:=pxv;yv:=pyv;
       v:=10;
       if l then ftype:=rrocket else ftype:=lrocket;
       damage:=10;
       sn:=3.1416/3;snv:=20;
       life:=1;
       daddy:=parent;
       if parent=0 then target:=1 else target:=0;
       an:=@misslespr;
       break;
      end;
  end;

  procedure plazma  (px,py,pxv,pyv,pa:single;parent:byte);
  var i:word;
  begin
   for i:=0 to maxmiss do
    with missles[i] do
     if life=0 then
      begin
       x:=px;y:=py;a:=pa;
       xv:=pxv;yv:=pyv;
       v:=20;
       damage:=1;
       sn:=0;
       life:=1;
       ftype:=rocket;
       daddy:=parent;
       if parent=0 then target:=1 else target:=0;
       an:=@plazmaspr;
       break;
      end;
  end;

begin
end.