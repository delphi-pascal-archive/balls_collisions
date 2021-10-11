unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, UVect, math;

type
  TForm1 = class(TForm)
    Image2: TImage;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

type
 TBalle=record
         v,p,nv:TVect;
         m,r:Currency;
        end;
 TMur=record
       p1,p2:tvect;
       p1i,p2i:tpoint;
       dv : tvect;
       u,v : tvect;
       nv : Currency;
       a,b,c:Currency;
       a2b2:Currency;
      end;

const
 maxballes=600;
var
  Form1: TForm1;
  balles:array[0..maxballes] of TBalle;
  gravis:array[0..maxballes] of tvect;
  murs:array of TMur;
  gravi:tvect;
  nballes:integer=200;
  rebond:boolean=false;
  typeattra:byte;
  perte:Currency=1;
  mousepos:tvect;

implementation

uses {Unit2, }Uintro;

{$R *.dfm}

// complete la structure TMur
function CreateMur(x1,y1,x2,y2:integer):tmur;
begin
 with result do
  begin
   // coef de l'équation de la droite passant par les deux points
   a:=Y2-y1;
   b:=x1-X2;
   c:=y1*x2-x1*Y2;
   // sauve les deux points (tpoint et tvect)
   p1i:=point(x1,y1);
   p2i:=point(x2,y2);
   p1:=vect(x1,y1,0);
   p2:=vect(x2,y2,0);
   // vecteur suivant P1P2
   dv:=subvect(p2,p1);
   v:=normalize(dv);
   // norme et vecteur normal
   nv:=norme(dv);
   u:=vect(v.y,-v.x,0);
   // précalcul sqrt(a²+b²)
   a2b2:=sqrt(a*a+b*b);
  end;
end;

// effectue la collision entre B1 et B2
procedure Collision(var b1,b2:tballe);
var
 u,v:tvect;
 u1,u2,v1,v2,ug:Currency  ;
begin
 // calcul les vecteurs normal et tangent à la collision
 u:=subvect(b1.p,b2.p);
 u:=normalize(u);
 v.x := -u.y;
 v.y := +u.x;

 // calcul les composantes dans (u,v)
 u1 := ProduitScal(B1.v,u);
 u2 := ProduitScal(B2.v,u);
 v1 := ProduitScal(B1.v,v);
 v2 := ProduitScal(B2.v,v);

 // les vitesses s'échangent en fonction de la masse suivant le vecteur u
 uG := (B1.m*u1 + B2.m*u2)/(B1.m + B2.m);
 u1 := 2*uG - u1;
 u2 := 2*uG - u2;

 // recalcul les composantes dans (i,j) et non (u,v)
 b1.v:=LinCombinVect2D(u,v,u1*perte,v1*perte);
 b2.v:=LinCombinVect2D(u,v,u2*perte,v2*perte);

 // reduit la vitesse à 0 si elle est négligeable
 if norme2(b1.v)<1e-4 then b1.v:=vectnul;
 if norme2(b2.v)<1e-4 then b2.v:=vectnul;
end;


// collision entre b1 et b2 ?
function iscollision(b1,b2:tballe):boolean;
var
 a,b:tvect;
 dist:Currency;
begin
 //distance entre b1 et b2 < somme des rayons
 a:= AddVect(b1.p,b1.v);
 b:= AddVect(b2.p,b2.v);
 dist:=distance2(a,b);
 result:=dist<sqr(b1.r+b2.r);
end;


// Collision avec un mur ?
function iscollisionmur(b:tballe;mur:tmur):boolean;
var
 a:tvect;
 dist:Currency;
begin
 //distance entre b et le mur < rayon
 a:=AddVect(b.p,b.v);
 dist:=abs(mur.a*a.x+mur.b*a.y+mur.c)/mur.a2b2;
 result:=dist<b.r;
end;

// effectue la collision avec le mur
procedure collisionmur(var b:tballe;mur:TMur);
var
 u,v:tvect;
 u1,v1:Currency;
begin
 // vecteur normal et tangent à la droite
 v:=mur.v;
 u:=mur.u;
 // rebond (invertion de la vitesse suivant u
 u1 := -ProduitScal(B.v,u);
 v1 := ProduitScal(B.v,v);
 // rebascule dans le repère (i,j)
 b.v:=LinCombinVect2D(u,v,u1*perte,v1*perte);
 // reduit la vitesse à 0 si elle est négligeable
 if norme2(b.v)<1e-4 then b.v:=vectnul;
end;  

procedure TForm1.Timer1Timer(Sender: TObject);
var
 i,j:integer;
 x,y,r:integer;
 dist:Currency;
 angle:extended;
 a:tvect;
 ok:boolean;
 colli,rebo:integer;
begin

 //calcul de la gravite
 for i:=0 to nballes-1 do
  case typeattra of
  //aucune gravité
   0:gravis[i]:=vect(0,0,0);
  //gravité rectiligne
   1:gravis[i]:=gravi;
  // attraction vers mousepos
   2:
    begin
     dist:=distance2(balles[i].p,mousepos)/1000;
     // trop près, sa risque de pas marcher... division par zéro
     if dist<2 then dist:=2;
     a:=subvect(balles[i].p,mousepos);
     angle:=arctan2(a.y,a.x);
     gravis[i]:=vect(-cos(angle)/dist,-sin(angle)/dist,0);
    end;
  // répulsion depuis mousepos
   3:
    begin
     dist:=distance2(balles[i].p,mousepos)/1000;
     if dist<1e-4 then dist:=0.001;
     a:=subvect(balles[i].p,mousepos);
     angle:=arctan2(a.y,a.x);
     gravis[i]:=vect( cos(angle)/dist, sin(angle)/dist,0);
    end;
  end;

  colli:=0;
  rebo:=0;
 ok:=true;
 //test de toute les collisions
 while ok do
  begin
   ok:=false;
   for j:=0 to nballes-2 do
    for i:=j+1 to nballes-1 do
     if iscollision(balles[i],balles[j]) then
      begin
       collision(balles[i],balles[j]);
       inc(colli);
       ok:=true;
      end;

  // et de tout les rebonds
   if rebond then
    for i:=0 to nballes-1 do
     for j:=0 to high(murs) do
     if iscollisionmur(balles[i],murs[j]) then
       begin
        collisionmur(balles[i],murs[j]);
        ok:=true;
        inc(rebo);
       end;
 end;

 caption:='Balls Collisions: '+inttostr(colli)+' step back: '+inttostr(rebo);

 // deplacements
 for i:=0 to nballes-1 do
    begin
     balles[i].p:=addvect(balles[i].p,balles[i].v);
     balles[i].v:=addvect(balles[i].v,gravis[i]);
    end;

 //affichage des balles
 image2.canvas.FillRect(image2.ClientRect);
 for i:=0 to nballes-1 do
  begin
   x:=round(balles[i].p.x);
   y:=round(balles[i].p.y);
   r:=round(balles[i].r);
   image2.Canvas.Ellipse(x-r,y-r,x+r,y+r);
  end;

 // affichage des murs
 for i:=0 to high(murs) do
  begin
   image2.Canvas.MoveTo(murs[i].p1i.X,murs[i].p1i.y);
   image2.Canvas.LineTo(murs[i].p2i.X,murs[i].p2i.y);
  end;

 //affiche le sens de la gravite dans le type 2
 if typeattra=1 then
  begin
   image2.canvas.MoveTo(clientwidth div 2,clientheight div 2);
   image2.canvas.LineTo(clientwidth div 2+round(gravi.x*10000),clientheight div 2+round(gravi.y*10000));
  end;
end;


procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
 a:Currency;
begin
 case typeattra of
 0: gravi:=vect(0,0,0);
 1:begin
   x:=x-clientWidth div 2;
   y:=y-clientHeight div 2;
   a:=arctan2(y,x);
   gravi:=vect(cos(a)/100,sin(a)/100,0);
  end;
 2,3:mousepos:=vect(x,y,0);
 end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 form2.Close;
end;

procedure TForm1.FormShow(Sender: TObject);
var
 i,j:integer;
 ok:boolean;
 temp:tvect;
 tentative:integer;
begin
 randomize;

 // cree 5 murs
 setlength(murs,5);
 murs[0]:=createmur(0,0,clientwidth,0);
 murs[1]:=createmur(clientwidth,0,clientwidth,clientheight);
 murs[2]:=createmur(clientwidth,clientheight,0,clientheight);
 murs[3]:=createmur(0,clientheight,0,0);
 murs[4]:=createmur(clientwidth-300,0,clientwidth,300);

 i:=0;
 balles[0].r:=20;
 temp.x:=random(round(500-2*balles[i].r))+balles[i].r;
 temp.y:=random(round(image2.Height-2*balles[i].r))+balles[i].r;
 temp.z:=0;
 balles[0].p:=temp;

 balles[0].v.x:=(random(10)-5)*1;
 balles[0].v.y:=(random(10)-5)*1;
 balles[0].m:=sqr(balles[0].r)*3.14159;

 for i:=1 to nballes-1 do
  begin
   balles[i].r:=5;
   tentative:=0;
   repeat
    ok:=true;
    temp.x:=random(round(500-2*balles[i].r))+balles[i].r;
    temp.y:=random(round(image2.Height-2*balles[i].r))+balles[i].r;
    temp.z:=0;
    for j:=0 to i-1 do if distance(balles[j].p,temp)<balles[j].r+balles[i].r then ok:=false;
    inc(tentative);
   until ok and (tentative<500);
   if tentative=500 then
    begin
     nballes:=i-1;
     break;
    end;

   balles[i].p:=temp;
   balles[i].v:=vectnul;
   balles[i].m:=sqr(balles[i].r)*3.14159;
  end;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
 timer1.Enabled:=false;
 hide;
 form2.Show;
end;

end.

