unit uinit;
interface
uses jgraph,graph;

const
 sxsize=640;
 sysize=480;
 transpcolor=$03E0;
 lxs=2000;
 lys=2000;

type tcbutton = (bup,bdown,bleft,bright,bweapon1,bweapon2,btabwp2,blstrafe,brstrafe);

var
 i:byte;
 testspr:pointer;
 misslespr:tAnimation;plazmaspr:Tanimation;
 pedoship,antipedo:tAnimation;
 pedo1:tanimation;
 llife0:tanimation;llife1:tanimation;
 level:pointer;
 lbar:pointer;
 rbar:pointer;
 cbutton:array [0..1,tcbutton] of boolean;

procedure InitData;

implementation

 procedure InitData;
 begin
   // ”правление
{
   cbutton[0,bup     ]:=up_scan;          cbutton[1,bup     ]:=AsciiToScan('r');
   cbutton[0,bdown   ]:=down_scan;        cbutton[1,bdown   ]:=AsciiToScan('f');
   cbutton[0,bleft   ]:=left_scan;        cbutton[1,bleft   ]:=AsciiToScan('d');
   cbutton[0,bright  ]:=right_scan;       cbutton[1,bright  ]:=AsciiToScan('g');
   cbutton[0,bweapon1]:=AsciiToScan('['); cbutton[1,bweapon1]:=AsciiToScan('q');
   cbutton[0,bweapon2]:=AsciiToScan('p'); cbutton[1,bweapon2]:=AsciiToScan('a');
   cbutton[0,btabwp2 ]:=AsciiToScan('o'); cbutton[1,btabwp2 ]:=tab_scan;
   cbutton[0,blstrafe]:=AsciiToScan(','); cbutton[1,blstrafe]:=AsciiToScan('z');
   cbutton[0,brstrafe]:=AsciiToScan('.'); cbutton[1,brstrafe]:=AsciiToScan('x');
}

   level:=loadsprite('sprites\level.tga');

   pedoship.load('pedoship');
   antipedo.load('antipedo');
   misslespr.load('missle');
   plazmaspr.load('plazma\pl1');
   llife0.load('panel\life');
   llife1.load('panel\life');
   for i := 0 to llife1.fcount do flipSpriteX(llife0.frames[i]);
   lbar:=loadsprite('sprites\panel\main.tga');
   rbar:=loadsprite('sprites\panel\main.tga');
   flipSpriteX(rbar);
 end;
Begin
End.