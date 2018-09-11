%--------------------------------------------------------------------------
%------- Guitar Hero en matlab --------------------------------------------
%------- Coceptos básicos de PDI-------------------------------------------
%------- Por: Daniel Felipe Rivera daniel.riveraa@udea.edu.co--------------
%------------ Juan Pablo Jaramillo Tobon juan.jaramillo62@udea.edu.co------
%--------Estudiantes ingenieria de sistemas -------------------------------
%------- Curso Básico de Procesamiento de Imágenes y Visión Artificial-----
%-------        PROFESOR DEL CURSO ----------------------------------------
%-------David Fernandez    david.fernandez@udea.edu.co -------------------
%-------Profesor Facultad de Ingenieria BLQ 21-409  -----------------------
%-------CC 71629489, Tel 2198528,  Wpp 3007106588 -------------------------
%------- Curso B�sico de Procesamiento de Im�genes y Visi�n Artificial---
%------- septiembre 12 de 2018---------------------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%--1. Inicializo el sistema -----------------------------------------------
%--------------------------------------------------------------------------
clear all;  % Inicializa todas las variables
close all;   % Cierra todas las ventanas, archivos y procesos abiertos
clc         % Limpia la ventana de comandos
objects = imaqfind; %Busca objetos de entrada de video activos en memoria
delete(objects) %Limpia la memoria de objetos de captura de video
%--------------------------------------------------------------------------
%-- 2. Configuracion de la captura de video -------------------------------
%--------------------------------------------------------------------------
vid=videoinput('winvideo',1,'YUY2_640x480');% Se captura un stream de video usando videoinput con resolución predefinida
set(vid,'ReturnedColorSpace','rgb');%la imagen del video se va a tomar en modo RGB
set(vid,'TriggerRepeat',Inf);%Establece el triggerRepeat en "infinito"
start(vid);%Comienza a capturar el vídeo

%--------------------------------------------------------------------------
%-- 3. Inicializaci�n de variables-----------------------------------------
%--------------------------------------------------------------------------
%-------Carga de imágenes y canciones para el juego------------------------
[guitarraRead,map0,guitarraTrans]=imread('Imagenes/Guitarra.png');%Carga la guitarra de interfaz
[redNoteRead,map1,redTrans]=imread('Imagenes/rojo.png');%Carga imagen de la nota roja
[greenNoteRead,map2,greenTrans]=imread('Imagenes/verde.png');%Carga imagen de la nota verde
[blueNoteRead,map3,blueTrans]=imread('Imagenes/azul.png');%Carga imagen de la nota azul
song=input('Ingrese\n1 Dejavu-Initial D\n2 El paso del gigante-Grupo soñador\n3 Raining blood-Slayer\n4 Scar tissue-RHCP\n');%Espera lectura del usuario
switch song %Selector de canción
case 1
    [cancion,hz] = audioread('Canciones/Dejavu.mp3');%Carga la canción Dejavu
case 2
    [cancion,hz] = audioread('Canciones/ElPasoDelGigante.mp3');%Carga la canción El paso del gigante
case 3
    [cancion,hz] = audioread('Canciones/RainingBlood.mp3');%Carga la canción Raining blood
case 4
    [cancion,hz] = audioread('Canciones/ScarTissue.mp3');%Carga la canción Scar tissue
otherwise
    disp('Selección no valida,se jugará con la primera canción por bob@');%Mensaje en pantalla
    [cancion,hz] = audioread('Canciones/Dejavu.mp3');%Carga la canción Dejavu como por defecto.       
end
%------Posiciones random iniciales de las notas musicales.--------------
yr=randi(1000)*-1;%Posición random en y para la primera nota roja
yr1=randi(1000)*-1;%Posición random para en y la segunda nota roja
yg=randi(1000)*-1;%Posición random para en yla primera nota verde
yg1=randi(1000)*-1;%Posición random para en y la segunda nota verde
yb=randi(1000)*-1;%Posición random para en y la primera nota azul
yb1=randi(1000)*-1;%Posición random en y para la segunda nota azul
%-------Otras variables ----------------------------------------------
alto=50;ancho=50;x=100;velocidad = 10;puntos=20;%Inicializa los valores de las  
%--------------------------------------------------------------------------
%---4. Inicio del juego----------------------------------------------------
%--------------------------------------------------------------------------
sound(cancion*0.07,hz)%Reproduce la canción cargada   
while(1) %Ciclo de juegoo 
    %---------Obtener captura para procesar-------------------------------  
    snap = getsnapshot(vid);%Se hace snapshot al video para procesarlo
    snap = flip(snap,2);%Aplicamos el modo espejo-------------------------
    snap2 = snap;%Realizamos una copia de la imagen  
    %--------------------Identificación de objeto para jugar---------------
    r = snap(:,:,1);%Obtenemos la capa que contiene el color rojo de la imagen
    g = snap(:,:,2);%Obtenemos la capa que contiene el color verde de la imagen
    b = snap(:,:,3);%Obtenemos la capa que contiene el color azul de la imagen
    capaVerde = g - b/2 - r/2;%A la capa verde le restamos las capas roja y azul
    bw = capaVerde > 33;%Obtenemos los objetos donde está presente el color verde
    snap = bwareaopen(bw, 20);%La Funcion bwareaopen elimina todos los 
    %componentes conectados (objetos) que tienen menos de Pp�xeles de la 
    %imagen binaria BW, as� obtenemos todos los objetos que cumplan con la
    %mascara
    
    %--------------------Mostrar snapshot en figura-----------------------
    figure(1);imshow(snap2);%Abre una ventana con para mostrar la imagen del snapshot 
    %---------------------Establece la vectores que identificar el hitbox de cada nota----
    hitBoxR=[x+14,yr+14,ancho,alto];%----------Vector para la primera nota roja---
    hitBoxR1=[x+14,yr1+14,ancho,alto];%----------Vector para la segunda nota roja-
    hitBoxG=[x+134,yg+14,ancho,alto];%----------Vector para la primera nota verde-
    hitBoxG1=[x+134,yg1+14,ancho,alto];%----------Vector para la segunda nota verde
    hitBoxB=[x+254,yb+14,ancho,alto];%----------Vector para la primera nota azul---
    hitBoxB1=[x+254,yb1+14,ancho,alto];%----------Vector para la segunda nota azul-
    
    %----------------Elementos para enseñar en pantalla-----------------------
    txt = ['puntos: ',num2str(puntos)];
    text(0,20,txt,'Color','b','FontSize', 14);
    hold on%Hold on se usa para posicionar encima de la figura actual
    guitarra = image(0,0,guitarraRead);set(guitarra, 'AlphaData', guitarraTrans);%Superpone la guitarra y le aplica su transparencia
    redNote=image(x,yr,redNoteRead);set(redNote, 'AlphaData', redTrans);%
    greenNote=image(x+120,yg,greenNoteRead);set(greenNote, 'AlphaData', greenTrans);
    blueNote=image(x+240,yb,blueNoteRead);set(blueNote, 'AlphaData', blueTrans);
    redNote1=image(x,yr1,redNoteRead);set(redNote1, 'AlphaData', redTrans);
    greenNote1=image(x+120,yg1,greenNoteRead);set(greenNote1, 'AlphaData', greenTrans);
    blueNote1=image(x+240,yb1,blueNoteRead);set(blueNote1, 'AlphaData', blueTrans);
    hold off

    s  = regionprops(snap, {'centroid','area'});%Obtenemos las propiedades 'centroide' y '�rea' de cada objeto que este blanco en BW
    if isempty(s)%Condicional que se encargar� de reconocer si el vector con objetos 
        %que cumplen con la mascara de reconocimiento, se encuentra vacio.
        text(190,210,'No se detecta ning�n objeto verde','Color','b','FontSize', 14);
    else
        
        [~, id] = max([s.Area]);  %Obtenemos el ID del objeto cuya �rea sea la mayor en el vector de objetos 
        xc = s(id).Centroid(1) - 5;%Coordenada en X para el CUADRO que identificar� al jugador
        yc = s(id).Centroid(2) - 5;%Coordenada en Y para el CUADRO que identificar� al jugador
        p = [xc, ((40*xc)/240)+337, 13, 13];%Creaci�n del vector posici�n para el jugador
        r = rectangle('Position',p,'EdgeColor','b','LineWidth',2);   
        
     if bboxOverlapRatio(p,hitBoxR)>0
         yr = randi(100)*-1;
         puntos=puntos +10;
     end
     if bboxOverlapRatio(p,hitBoxR1)>0
         yr1 = randi(500)*-1;
         puntos=puntos +10;
     end
     if bboxOverlapRatio(p,hitBoxG)>0
         yg = randi(100)*-1;
         puntos=puntos +10;
     end
     if bboxOverlapRatio(p,hitBoxG1)>0
         yg1 = randi(500)*-1;
         puntos=puntos +10;
     end
     
     if bboxOverlapRatio(p,hitBoxB)>0
         yb = randi(100)*-1;
         puntos=puntos +10;
     end
     if bboxOverlapRatio(p,hitBoxB1)>0
         yb1 = randi(500)*-1;
         puntos=puntos +10;
     end
        
    end
    %Analizar colisiones
    %Actualizaci�n de posici�n en y de las notas musicales
    if(yr>481)
        yr=randi(150)*-1;
        puntos = puntos-0.5*puntos;
    end
    if(yg>481)
        yg=randi(150)*-1;
        puntos = puntos-0.5*puntos;
    end
    if(yb>481)
        yb=randi(150)*-1;
        puntos = puntos-0.5*puntos;
    end
    if(yr1>481)
        yr1=randi(150)*-1;
        puntos = puntos-0.5*puntos;
    end
    if(yg1>481)
        yg1=randi(150)*-1;
        puntos = puntos-0.5*puntos;
    end
    if(yb1>481)
        yb1=randi(150)*-1;
        puntos = puntos- 0.5*puntos;
    end
    yr=yr+velocidad;
    yg=yg+velocidad;
    yb=yb+velocidad;
    yr1=yr1+velocidad;
    yg1=yg1+velocidad;
    yb1=yb1+velocidad;
    
    if puntos < 1
        text(190,210,'GAME OVER','Color','b','FontSize', 40);%Texto que se mostrar� cuando el jugador pierda
        
        break
    end    
    flushdata(vid,'triggers');
    
    if (mod(vid.FramesAcquired,20)) ==0
        velocidad=velocidad+0.5;
    end
    
end
clear sound;
%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA ----------------------------
%--------------------------------------------------------------------------