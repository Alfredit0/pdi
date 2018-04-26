unit uRegional;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, uVarios;



procedure CopiaVaV(var M2 : Matdxd; op : integer);
procedure FRMedia(var M1 : Mat3D; var M2 : mat3D;mc,nr : integer; mconv : Matdxd;peso : real);
procedure FRGausiana(var M1 : Mat3D; var M2 : mat3D;mc,nr : integer; mconv : Matdxd;peso : real);
procedure FRMediana(var MT : Mat3D; var MR : mat3D; Ian, Ial, op : integer);

procedure CopiaVaVL1(var M2 : Matdxd);
procedure CopiaVaVL2(var M2 : Matdxd);
procedure CopiaVaVL3(var M2 : Matdxd);
procedure CopiaVaVL4(var M2 : Matdxd);
procedure CopiaVaVL5(var M2 : Matdxd);
procedure CopiaVaVL6(var M2 : Matdxd);
procedure FRLap4mas(var M1 : Mat3D; var M2 : mat3D;mc,nr : integer; mconv : Matdxd);

const
  mat_media  : M3x3 = ((1,1,1),
                       (1,1,1),
                       (1,1,1));

  mat_gausiana  : M3x3 = ((1,2,1),
                       (2,4,2),
                       (1,2,1));

  Lap4mas  : M3x3 = ((0,-1,0),
                     (-1,4,-1),
                     (0,-1,0));
  Lap4masNeg  : M3x3 = ((0,1,0),
                       (1,-4,1),
                       (0,1,0));
  Lap4por  : M3x3 = ((-1,0,-1),
                     (0,4,0),
                     (-1,0,-1));
  Lap4porNeg  : M3x3 = ((1,0,1),
                       (0,-4,0),
                       (1,0, 1));
  Lap8  : M3x3 = ((-1,-1,-1),
                     (-1,8,-1),
                     (-1,-1,-1));
  Lap8Neg  : M3x3 = ((1,1,1),
                     (1,-8,1),
                     (1,1,1));

implementation

//Obtiene la matriz de convolución en un entorno de vecindad de 3x3
procedure CopiaVaV(var M2 : Matdxd; op : integer);
var
  i,j,delta : integer;
begin
  delta := 1;
  for i := -delta to delta do
    for j := -delta  to delta do
      if op = 1 then
         begin
              M2[i][j] := mat_media[i][j];
         end
      else if op = 2 then
         M2[i][j] := mat_gausiana[i][j];
end;

//Filtro gausiana
procedure FRGausiana(var M1 : Mat3D; var M2 : mat3D;
                  mc,nr : integer; mconv : Matdxd;
                  peso : real);
var
  c,i,j,alf,bet,delta : integer;
  sum : real;
begin
  delta := 1;
  SetLength(M2,mc,nr,3);
  for c := 0 to 2 do
    for j := delta to nr - 1 - delta do
      for i := delta to mc - 1 - delta do
      begin
        sum := 0.0;
        for alf := -delta to delta do
          for bet := -delta to delta do
            sum := sum + M1[i+alf][j+bet][c]*mconv[alf][bet];
          M2[i][j][c] := round(peso*sum);
      end;

end;

//Filtro de la Media
procedure FRMedia(var M1 : Mat3D; var M2 : mat3D;
                  mc,nr : integer; mconv : Matdxd;
                  peso : real);
var
  c,i,j,alf,bet,delta : integer;
  sum : real;
begin
  delta := 1;
  SetLength(M2,mc,nr,3);
  for c := 0 to 2 do
    for j := delta to nr - 1 - delta do
      for i := delta to mc - 1 - delta do
      begin
        sum := 0.0;
        for alf := -delta to delta do
          for bet := -delta to delta do
            sum := sum + M1[i+alf][j+bet][c]*mconv[alf][bet];
          M2[i][j][c] := round(peso*sum);
      end;

end;

//Filtro de la Mediana  en 9 elementos
procedure FRMediana(var MT : Mat3D; var MR : mat3D; Ian, Ial, op : integer);
var
  x,y,c,p,q,i : integer;
  matmed : V9;
begin
  SetLength(MR,Ian,Ial,3);
  for c := 0 to 2 do      //los tres canales
     // seleccion de canal
     for y := 1 to Ial-2 do      //alto de la imagen
       for x := 1 to Ian-2 do    //ancho de la imagen
       begin
          i:=0;
           for q := -1 to 1 do
           begin
             for p := -1 to 1 do
             begin
               matmed[i] := MT[x+p][y+q][c];
               i := i+1;
             end;
           end;
           MR[x][y][c] := OrdV9(matmed, 1);
       end;
    end;

end.

