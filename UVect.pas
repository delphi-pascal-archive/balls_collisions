unit UVect;

interface 

type
 TVect=record x,y,z:Currency  ; end;

const
 vectnul:tvect=(x:0;y:0;z:0);

function distance(a,b:tvect):Currency;
function distance2(a,b:tvect):Currency;
function SubVect(a,b:TVect):TVect;
function AddVect(a,b:TVect):TVect;
function ProduitVect(a,b:TVect):TVect;
function ProduitScal(a,b:TVect):Currency  ;
function Normalize(var v:tvect  ):TVect;
function norme2(v:tvect):Currency;
function norme(v:tvect):Currency;
function VectMulti(a:TVect;n:Currency  ):TVect;
function VectDiv(a:TVect;n:Currency  ):TVect;
function LinCombinVect2D(u,v:tvect; uCoeff, vCoeff:Currency):tvect;
function vect(x,y,z:Currency):tvect;

implementation

function vect(x,y,z:Currency):tvect;
begin
 result.x:=x;
 result.y:=y;
 result.z:=z;
end;

function distance2(a,b:tvect):Currency;
begin
 a:=subvect(a,b);
 result:=a.x*a.x+a.y*a.y+a.z*a.z;
end;

function distance(a,b:tvect):Currency;
begin
 a:=subvect(a,b);
 result:=sqrt(a.x*a.x+a.y*a.y+a.z*a.z);
end;

function SubVect(a,b:TVect):TVect;
begin
 result.x:=a.x-b.x;
 result.y:=a.y-b.y;
 result.z:=a.z-b.z;
end;

function AddVect(a,b:TVect):TVect;
begin
 result.x:=a.x+b.x;
 result.y:=a.y+b.y;
 result.z:=a.z+b.z;
end;

function ProduitVect(a,b:TVect):TVect;
begin
 result.x:=a.y*b.z-a.z*b.y;
 result.y:=a.z*b.x-a.x*b.z;
 result.z:=a.x*b.y-a.y*b.x;
end;

function ProduitScal(a,b:TVect):Currency  ;
begin
 result:=a.x*b.x+a.y*b.y+a.z*b.z;
end;

function Normalize(var v:tvect):tvect;
var
 l:extended;
begin
 l:=sqrt(v.x*v.x+v.y*v.y+v.z*v.z);
 if l<>0 then
  begin
   result.x:=v.x / l;
   result.y:=v.y / l;
   result.z:=v.z / l;
  end
 else
  result:=v;
end;

function VectMulti(a:TVect;n:Currency  ):TVect;
begin
 result.x:=a.x * n;
 result.y:=a.y * n;
 result.z:=a.z * n;
end;

function VectDiv(a:TVect;n:Currency  ):TVect;
begin
 result.x:=a.x / n;
 result.y:=a.y / n;
 result.z:=a.z / n;
end;

function LinCombinVect2D(u,v:tvect; uCoeff, vCoeff:Currency):tvect;
begin
 result.x := (uCoeff * u.x) + (vCoeff * v.x);
 result.y := (uCoeff * u.y) + (vCoeff * v.y);
end;

function norme2(v:tvect):Currency;
begin
 result:=v.x*v.x+v.y*v.y+v.z*v.z;
end;

function norme(v:tvect):Currency;
begin
 result:=sqrt(v.x*v.x+v.y*v.y+v.z*v.z);
end;

end.
