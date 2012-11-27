unit ugamedta;
interface
uses uinit,jgraph;
const
maxpart=500;
maxstars=100;
maxmiss=100;
maxplay=1;
type tftype=(gavno,lrocket,rrocket,rocket);

var
particles:array [0..maxpart ] of record x,y:single;xv,yv:single;life:word;color:word; end;
stars    :array [0..maxstars] of record x,y,z:single; c:word end;
missles:array [0..maxmiss] of record
           x,y,v,xv,yv:single;a:double;life:word;
           target:byte;
           daddy:byte;
           sn,snv:single;
           ftype:tftype;
           an:^tAnimation;
           xs,ys:word;
           damage:word;
        end;
player   :array [0..1] of record
                                 x,y,v,xv,yv,av:single;a:double;
                                 HitPoint:integer;frags:integer;
                                 reload:word;left:boolean;
                                 ltlaz:byte;
                                 alive:boolean;
                                end;
implementation
begin
end.