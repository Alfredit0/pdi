//Operaciones puntuales
unit uFiltros;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,uVarios,Math;

const
  Lam = 255;

  procedure FPCoseno(var M1 : Mat3D; var M2 : Mat3D; mc,nr : integer);
  procedure FPExpfuerte(var M1 : Mat3D; var M2 : Mat3D; mc,nr, alpha : integer);
  procedure escaladegrises(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);
  procedure FPLogarit(var M1 : Mat3D; var M2 : Mat3D; mc,nr,alpha : integer);
  procedure FPNegativo(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);
  procedure FPGamma(var M1 : Mat3D; var M2 : Mat3D; mc,nr : integer; g:real);
  procedure FPExpo(var M1 : Mat3D; var M2 : Mat3D; mc,nr,alpha : integer);
  procedure FPSeno(var M1 : Mat3D; var M2 : Mat3D; mc,nr: integer);
  procedure AplicaLUT(var M1 : Mat3D; var M2 : Mat3D; mc,nr : integer;T : ArrLam);
  procedure reflecHorizontal(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);
  procedure reflecVert(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);
  procedure reflecVert(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);

implementation
var
  Tabla : ArrLam;

//Aplica función exponencial fuerte
  procedure FPExpfuerte(var M1 : Mat3D; var M2 : Mat3D; mc,nr, alpha : integer);
  var
    k : integer;
  begin
     SetLength(M2,mc,nr,3);
     for k := 1 to Lam do
        Tabla[k] := round((Lam/(exp(alpha)-1))*(exp(alpha*k/Lam)-1));
     AplicaLUT(M1,M2,mc,nr,Tabla);
  end;

//Aplica función coseno
    procedure FPCoseno(var M1 : Mat3D; var M2 : Mat3D; mc,nr : integer);
    var
      k : integer;
    begin
       SetLength(M2,mc,nr,3);
       for k := 1 to Lam do
          Tabla[k] := round(Lam*(1-cos((pi*k)/(2*Lam))));
       AplicaLUT(M1,M2,mc,nr,Tabla);
    end;

//Se desarrolla la obtención del filtro escala de grises
  procedure escaladegrises(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);
  var
    i, j, k, suma : integer;
  begin
    SetLength(M2,mc,nr,3);
    for j := 0 to nr-1 do      //filas
       for i := 0 to mc-1 do   //columnas
         for k := 0 to 2 do    //canales RGB
           begin
                suma := M1[i][j][0] + M1[i][j][1] + M1[i][j][2];
                M2[i][j][k] := suma div 3; //tono gris
           end;
  end;


//Se desarrolla la obtención del filtro de negativo
  procedure FPNegativo(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);
  var
    i, j, k : integer;
  begin
    SetLength(M2,mc,nr,3);
    for j := 0 to nr-1 do
       for i := 0 to mc-1 do
         for k := 0 to 2 do
            M2[i][j][k] := NOT M1[i][j][k];   // se pasa a negacions
  end;

// Corrección Gamma
  procedure FPGamma(var M1 : Mat3D; var M2 : Mat3D; mc,nr : integer; g:real);
  var
    k : integer;
  begin
     SetLength(M2,mc,nr,3);
     for k := 1 to Lam do
        //Obtiene para cada uno de los tonos
        Tabla[k] := round(Lam * power(k/Lam,g));
     AplicaLUT(M1,M2,mc,nr,Tabla);
  end;

//Aplica función logaritmica = rango dinamico
procedure FPLogarit(var M1 : Mat3D; var M2 : Mat3D; mc,nr, alpha : integer);
var
  k : integer;
begin
   SetLength(M2,mc,nr,3);
   for k := 1 to Lam do
      Tabla[k] := round((Lam/ln(alpha*Lam+1))*ln(alpha*k+1));
   AplicaLUT(M1,M2,mc,nr,Tabla);
end;

//Aplica función exponencial
procedure FPExpo(var M1 : Mat3D; var M2 : Mat3D; mc,nr, alpha : integer);
var
  k : integer;
begin
   SetLength(M2,mc,nr,3);
   for k := 1 to Lam do
      Tabla[k] := round((Lam/(1-exp(-alpha)))*(1-exp((-alpha*k)/Lam)));
   AplicaLUT(M1,M2,mc,nr,Tabla);
end;

//Aplica función seno
procedure FPSeno(var M1 : Mat3D; var M2 : Mat3D; mc,nr : integer);
var
  k : integer;
begin
   SetLength(M2,mc,nr,3);
   for k := 1 to Lam do
      Tabla[k] := round(Lam*sin(pi*k/(2*Lam)));
   AplicaLUT(M1,M2,mc,nr,Tabla);
end;


//Aplica Tabla con los resultados
procedure AplicaLUT(var M1 : Mat3D; var M2 : Mat3D; mc,nr : integer;T : ArrLam);
var
  i, j, k, z : integer;
begin
  for j := 0 to nr-1 do
     for i := 0 to mc-1 do
       for k := 0 to 2 do
       begin
         z  := M1[i][j][k];
         M2[i][j][k] := Tabla[z];
       end;
end;

//Se desarrolla la obtención del filtro de reflexion
  procedure reflecHorizontal(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);
  var
    i, j, k : integer;
  begin
    SetLength(M2,mc,nr,3);
    for j := 0 to nr-1 do      //filas
       for i := 0 to mc-1 do   //columnas
         for k := 0 to 2 do    //canales RGB
           begin
                M2[(mc-1)-i][j][k] := M1[i][j][k]; //tono gris
           end;
  end;

  //Se desarrolla la obtención del filtro de reflexion
  procedure reflecVert(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);
  var
    i, j, k, suma : integer;
  begin
    SetLength(M2,mc,nr,3);
    for j := 0 to nr-1 do      //filas
       for i := 0 to mc-1 do   //columnas
         for k := 0 to 2 do    //canales RGB
           begin
                M2[i][j][k] := M1[i][(nr-1)-j][k]; //tono gris
           end;
  end;

    //Se desarrolla la obtención del filtro de reflexion
  procedure reflecDoble(var M1 : Mat3D;var M2 : Mat3D; mc,nr : integer);
  var
    i, j, k, suma : integer;
  begin
    SetLength(M2,mc,nr,3);
    for j := 0 to nr-1 do      //filas
       for i := 0 to mc-1 do   //columnas
         for k := 0 to 2 do    //canales RGB
           begin
                M2[i][j][k] := M1[(mc-1)-i][(nr-1)-j][k]; //tono gris
           end;
  end;
end.

