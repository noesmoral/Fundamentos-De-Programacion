program Burro;
//Creado por Pedro Barquin Ayuso//

const N=10; {Numero maximo de numeros de la baraja, desde el AS(1) hasta el REY(10), Dato no modificable}
      M=4; {Numero total de palos de la baraja, OROS, COPAS, ESPADAS y BASTOS, Dato no modificable}
      ron=15; {Numero maximo de rondas de la partida, esta dato es modificable}

type  tipo_datos=string[20];
      dimension_numeros=1..N;
      tipo_vector=array[dimension_numeros]of tipo_datos;
      dimension_palos=1..M;
      tipo_vector2=array[dimension_palos]of tipo_datos;
      tipo_pos=integer;
      tipo_matriz=array[dimension_numeros,dimension_palos] of tipo_datos;

var   numeros:tipo_vector;
      palos:tipo_vector2;
      mazo:tipo_matriz;
      jug:tipo_pos;

function seguir:boolean; {Funcion con la que el usuario elige si desea continuar}
var resp:char;
begin
 repeat
   writeln('Desea continuar. (S para continuar, N para saltarlo)');
   readln(resp);
 until (resp='S') or (resp='s') or (resp='N') or (resp='n');
 seguir:=(resp='S') or (resp='s')
end;

procedure jugadores (var jug:tipo_pos); {Por si el usuario decide no introducir un valor de tipo entero, que el programa no se bloque}
var error:tipo_datos;
begin
 Repeat
    writeln('La partida puede tener un minimo de 3 y un maximo de 10 jugadores');
    writeln('(Se debe introducir un numero del 3 al 10)');
    readln(error);
    case error of
    '3':jug:=3;
    '4':jug:=4;
    '5':jug:=5;
    '6':jug:=6;
    '7':jug:=7;
    '8':jug:=8;
    '9':jug:=9;
    '10':jug:=10;
    end;
  until (jug>=3) and (jug<=10);
end;

procedure leer_vector1(var vector:tipo_vector); {Crea los numeros de la baraja}
var i:tipo_pos;
begin
  for i:=1 to n do
  begin
    case i of
    1:vector[i]:='   AS   de ';
    2:vector[i]:='  DOS   de ';
    3:vector[i]:='  TRES  de ';
    4:vector[i]:=' CUATRO de ';
    5:vector[i]:=' CINCO  de ';
    6:vector[i]:='  SEIS  de ';
    7:vector[i]:=' SIETE  de ';
    8:vector[i]:='  SOTA  de ';
    9:vector[i]:='CABALLO de ';
    10:vector[i]:='  REY   de ';
    end;
  end;
end;

procedure leer_vector2(var vector:tipo_vector2); {Crea los palos de la baraja}
var i:tipo_pos;
begin
  for i:=1 to m do
  begin
    case i of
    1:vector[i]:='OROS';
    2:vector[i]:='COPAS';
    3:vector[i]:='ESPADAS';
    4:vector[i]:='BASTOS';
    end;
  end;
end;

procedure baraja (var matriz:tipo_matriz; var vector1:tipo_vector; vector2:tipo_vector2); {Crea la baraja dependiendo del numero de jugadores}
var i,j,fin_datos:tipo_pos;
begin
  writeln;
  writeln('La baraja para ',jug,' jugadores esta compuesta de:');
  fin_datos:=1;
  for i:=1 to jug do
  begin
    write('Los ',i,': ');
    for j:=1 to m do
    begin
      matriz[i,j]:=vector1[i]+vector2[j];
      write(matriz[i,j],'|');
      fin_datos:=fin_datos+1;
    end;
    writeln;
  end;
  writeln;
  writeln('Pulsa INTRO para barajar las cartas y repartirlas a los ',jug,' jugadores');
  readln;
end;

procedure mostrar_cartas (var matriz:tipo_matriz); {Muestra las cartas de todos los jugadores de la partida}
var i,j:tipo_pos;
begin
  for i:=1 to jug do
  begin
    writeln;
    writeln('El jugador ',i,' tiene: ');
    for j:=1 to m do
    begin
      write('|',matriz[i,j],'|');
      writeln;
    end;
    writeln;
  end;
  readln;
end;

procedure barajar (var matriz:tipo_matriz); {Baraja las cartas de los jugadores}
var i,p,q:tipo_pos;
    aux:tipo_datos;
begin
  randomize;
  for i:=1 to 10000 do
  begin
  p:=1+random(jug-1);
  q:=1+random(m-1);
  aux:=matriz[p,q];
  matriz[p,q]:=matriz[p+1,q+1];
  matriz[p+1,q+1]:=aux;
  p:=1+random(jug);
  q:=1+random(m-1);
  if p=1 then p:=p+1;
  aux:=matriz[p,q];
  matriz[p,q]:=matriz[p-1,q+1];
  matriz[p-1,q+1]:=aux;
  end;
  writeln;
  writeln('Ronda 1');
  mostrar_cartas(matriz);
  writeln('Para empezar a jugar pulsa intro');
end;

procedure carta_mas_repetida (matriz:tipo_matriz; i:tipo_pos; var carta:tipo_datos; var rep:tipo_pos; var pos:tipo_pos); {Averigua las cartas mas repetidas de cada jugador}
var cont:integer;
    j,k:tipo_pos;
    cadena1,cadena2:tipo_datos;
begin
  rep:=0;
  for j:=1 to m-1 do
  begin
  cont:=1;
  for k:=j+1 to m do
  begin
  cadena1:=matriz[i,j];
  cadena2:=matriz[i,k];
  if (cadena1[1..8]=cadena2[1..8]) then
  cont:=cont+1;
  if cont>rep then
  begin
     rep:=cont;
     pos:=j;
     carta:=matriz[i,pos];
  end;
  end;
  end;
end;

procedure carta_a_pasar (matriz:tipo_matriz; i:tipo_pos; var pos:tipo_pos); {Elige una carta que no sea util para el jugador}
var j:tipo_pos;
    cadena1,cadena2:tipo_datos;
begin
  j:=1;
  cadena1:=matriz[i,j];
  cadena2:=matriz[i,pos];
  while (j<=m) and (cadena1[1..8]=cadena2[1..8]) do
  begin
  j:=j+1;
  cadena1:=matriz[i,j];
  end;
  if j>m then pos:=0
  else pos:=j;
end;

procedure intercambio_cartas (var matriz:tipo_matriz; pos:tipo_pos; i:tipo_pos; var cont:tipo_pos; var aux2:tipo_datos); {Cada jugador pasa la carta que no le sirve y recibe las carta que no le sirve al otro jugador}
var aux1,carta:tipo_datos;
    rep:tipo_pos;
begin
 if matriz[i,pos]=matriz[1,pos] then cont:=0;
 aux1:=matriz[i,pos];
 cont:=cont+1;
 if cont=1 then aux2:=aux1;
 if cont=2 then
 begin
 matriz[i,pos]:=aux2;
 cont:=1;
 aux2:=aux1;
 end;
 if i=jug then
 begin
   i:=1;
   carta_mas_repetida(matriz,i,carta,rep,pos);
   carta_a_pasar(matriz,i,pos);
   matriz[i,pos]:=aux2;
 end;
end;

procedure a_jugar (var matriz:tipo_matriz); {Este procedimiento es el nucleo del juego, donde se averigua si el jugador ha ganado}
var i,pos,winner,rep,cont,ronda:tipo_pos;
    carta,aux2:tipo_datos;
begin
  winner:=0;
  ronda:=1;
  while (winner<>1) and (ronda<ron) do
  begin
  for i:=1 to jug do
  begin
  writeln;
  writeln('El jugador ',i,':');
  pos:=0;
  carta_mas_repetida (matriz,i,carta,rep,pos);
  if (rep>1) then
  begin
     writeln('La carta ', carta[1..8],' es la primera carta que mas se repite (',rep,' veces)');
     writeln('Y es la carta con la que este jugador se va a quedar para intentar ganar.');
     writeln;
     carta_a_pasar(matriz,i,pos);
     if (pos<>0) then
     begin
        if i=jug then
        begin
           writeln('La carta que va a pasar al jugador 1 es ',matriz[i,pos]);
           writeln('ya que es la primera carta distinta de la primera carta que mas se repite');
           writeln;
        end
        else
        begin
           writeln('La carta que va a pasar al jugador ', i+1,' es ',matriz[i,pos]);
           writeln('ya que es la primera carta distinta de la PRIMERA carta que mas se repite');
           writeln;
        end;
     end
     else
     begin
     writeln('Todas las cartas son iguales, el jugador ',i,' ha GANADO');
     winner:=1;
     writeln;
     end;
  end
  else
  begin
  writeln('No tiene ninguna carta repetida');
  writeln;
  carta_a_pasar(matriz,i,pos);
    if (pos<>0) then
    begin
       writeln('La carta que va a pasar al jugador ', i+1,' es ',matriz[i,pos]);
       writeln('ya que al no haber ninguna repetida pasa una cualquiera.');
       writeln;
    end
  end;
  readln;
  end;
  if winner=0 then
  begin
  for i:=1 to jug do
  begin
       pos:=0;
       carta_mas_repetida(matriz,i,carta,rep,pos);
       carta_a_pasar(matriz,i,pos);
       if (pos<>0) then
       begin
            intercambio_cartas (matriz,pos,i,cont,aux2);
       end;
  end;
  ronda:=ronda+1;
  writeln('Ronda ',ronda);
  mostrar_cartas(matriz);
  end
  else
  begin
       writeln('Despues de ',ronda,' rondas, el juego ya ha acabado, por lo que uno o');
       writeln('varios jugadores ya han conseguido tener 4 cartas iguales de distinto palo');
       writeln('Todos los jugadores muestran sus cartas para verificar el/los ganadores');
       mostrar_cartas(matriz);
  end;
  if ronda=ron then
  begin
       writeln('El juego se ha terminado ya que los jugadores no han sido capaces de conseguir');
       writeln('4 cartas iguales');
       writeln('LOS ',jug,' PIERDEN');
  end;
  end;
  end;

procedure burro; {Presentacion del programa}
begin
  writeln('8 888888888o   8 8888      88 8 888888888o.   8 888888888o.       ,o888888o.');
  writeln('8 8888    `88. 8 8888      88 8 8888    `88.  8 8888    `88.   . 8888     `88.');
  writeln('8 8888     `88 8 8888      88 8 8888     `88  8 8888     `88  ,8 8888       `8b');
  writeln('8 8888     ,88 8 8888      88 8 8888     ,88  8 8888     ,88  88 8888        `8');
  writeln('8 8888.   ,88  8 8888      88 8 8888.   ,88   8 8888.   ,88   88 8888         8');
  writeln('8 8888888888   8 8888      88 8 888888888P    8 888888888P    88 8888         8');
  writeln('8 8888    `88. 8 8888      88 8 8888`8b       8 8888`8b       88 8888        ,8');
  writeln('8 8888      88 ` 8888     ,8P 8 8888 `8b.     8 8888 `8b.     `8 8888       ,8P');
  writeln('8 8888    ,88    8888   ,d8P  8 8888   `8b.   8 8888   `8b.    ` 8888     ,88');
  writeln('8 888888888P      `Y88888P    8 8888     `88. 8 8888     `88.     `8888888P');
  writeln;
  writeln;
  writeln('Este programa esta dedicado especificamente para jugar al Burro');
  writeln('El Burro es un popular juego de cualquier piscina');
  writeln;
  writeln('Cuando el programa te de a elegir debes elegir una de las opciones mostradas');
  writeln('y en caso de que no aparecza nada pulsa INTRO para continuar');
  writeln;
end;

procedure burro_dibujo; {Gracioso dibujo para mostrarse al final del juego}
begin
  writeln('                     /\/\');
  writeln('                    / / /');
  writeln('                  _/,/ /');
  writeln('               _/` (/"/////,');
  writeln('               (          ````--.___');
  writeln('              /    _),      ,-      -.');
  writeln('             /,   /   \            (\  \,');
  writeln('             \_()/     \)   )` =_   ))  |');
  writeln('                       |    |     .// _/)');
  writeln('                       (   ( \_   //   /');
  writeln('                        \  >_,\  (/)= /');
  writeln('                         | | | \ #\| /');
  writeln('                         |=| |=|\ ( (');
  writeln('                         (=> ( >( >),)');
  writeln('                         | | |=| \ ( (');
  writeln('                         / / / /  ) |/');
  writeln('                \       /_( /_(   , || )/.,_');
  writeln('             ). /\\_(\,/, //- /  /_(_(     /');
  writeln('                   ,\.  - burro .-  - - -,)\/.');
  readln;
end;

procedure reglas; {Reglas del juego para el usuario}
begin
 writeln;
 writeln('OBJETIVO');
 writeln('El objetivo del juego es conseguir 4 cartas iguales del mismo numero, sin ');
 writeln('importar los palos de las cartas');
 writeln;
 writeln('REGLAS');
 writeln('1: Se repartiran 4 cartas a cada jugador (el numero de jugadores lo eligira el');
 writeln('   usuario y sera de 3 a 10 jugadores).');
 writeln;
 writeln('2: Una vez recibidas las cartas, el programa elegira la carta a pasar hacia el');
 writeln('   siguiente jugador siendo el ultimo el que se lo pase al primer jugador');
 writeln;
 writeln('3: Cada jugador recibira una carta del anterior jugador quedandose con 4 cada');
 writeln('   uno, ya que previamente habia pasado una');
 writeln;
 writeln('4: Cuando algun jugador consiga 4 cartas iguales o se concluyan las ',ron,' rondas');
 writeln('   la partida finalizara diciendo al usuario si el juego se ha terminado con ganadores');
 writeln('   o sin ellos.');
 writeln;
end;

begin {programa principal}
  burro;
  writeln('¿Quieres jugar al burro?');
  if seguir then
  begin
  writeln('¿Quieres ver las reglas del juego?');
  if seguir then
  begin
  reglas;
  end;
  leer_vector1(numeros);
  leer_vector2(palos);
  writeln('¿Cuantos jugadores va a tener la partida?');
  jugadores(jug);
  baraja(mazo,numeros,palos);
  writeln;
  writeln('Y una vez barajadas y repartidas quedan asi:');
  barajar(mazo);
  readln;
  a_jugar(mazo);
  readln;
  burro_dibujo;
  end;
end.
