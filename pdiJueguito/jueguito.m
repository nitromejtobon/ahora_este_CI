%---------------------------------------------------------------------------
%------- Guitar Hero en matlab --------------------------------------------
%------- Coceptos básicos de PDI-------------------------------------------
%------- Por: Daniel Felipe Rivera daniel.riveraa@udea.edu.co--------------
%------------ Juan Pablo Jaramillo Tobon juan.jaramillo62@udea.edu.co------
%--------Estudiantes ingenieria de sistemas -------------------------------
%------- Curso Básico de Procesamiento de Imágenes y Visión Artificial----
%-------        PROFESOR DEL CURSO ----------------------------------------
%-------David Fernandez    david.fernandez@udea.edu.co -------------------
%-------Profesor Facultad de Ingenieria BLQ 21-409  -----------------------
%-------CC 71629489, Tel 2198528,  Wpp 3007106588 -------------------------
%------- Curso Bï¿½sico de Procesamiento de Imágenes y Visión Artificial---
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
start(vid);%Comienza a capturar el video

%--------------------------------------------------------------------------
%-- 3. InicializaciÃ³n de variables-----------------------------------------
%--------------------------------------------------------------------------
%-------Carga de imÃ¡genes y canciones para el juego------------------------
[guitarraRead,map0,guitarraTrans]=imread('Imagenes/Guitarra.png');%Carga la guitarra de interfaz
[redNoteRead,map1,redTrans]=imread('Imagenes/rojo.png');%Carga imagen de la nota roja
[greenNoteRead,map2,greenTrans]=imread('Imagenes/verde.png');%Carga imagen de la nota verde
[blueNoteRead,map3,blueTrans]=imread('Imagenes/azul.png');%Carga imagen de la nota azul
[manoRead,map4,manoTrans]=imread('Imagenes/mano.png');%Carga imagen de la mano
song=input('Ingrese\n1 Dejavu-Initial D\n2 El paso del gigante-Grupo soÃ±ador\n3 Raining blood-Slayer\n4 Scar tissue-RHCP\n');%Espera lectura del usuario
switch song %Selector de canciÃ³n
    case 1
        [cancion,hz] = audioread('Canciones/Dejavu.mp3');%Carga la canciÃ³n Dejavu
    case 2
        [cancion,hz] = audioread('Canciones/ElPasoDelGigante.mp3');%Carga la canciÃ³n El paso del gigante
    case 3
        [cancion,hz] = audioread('Canciones/RainingBlood.mp3');%Carga la canciÃ³n Raining blood
    case 4
        [cancion,hz] = audioread('Canciones/ScarTissue.mp3');%Carga la canciÃ³n Scar tissue
    otherwise
        disp('Selección no valida,se jugará con la primera canción por bobs@');%Mensaje en pantalla
        [cancion,hz] = audioread('Canciones/Dejavu.mp3');%Carga la canciÃ³n Dejavu como por defecto.
end
%------Posiciones random iniciales de las notas musicales.--------------
yr=randi(1000)*-1;%Posición random en y para la primera nota roja
yr1=randi(1000)*-1;%Posición random para en y la segunda nota roja
yg=randi(1000)*-1;%Posición random para en yla primera nota verde
yg1=randi(1000)*-1;%Posición random para en y la segunda nota verde
yb=randi(1000)*-1;%Posición random para en y la primera nota azul
yb1=randi(1000)*-1;%Posición random en y para la segunda nota azul
%-------Otras variables ----------------------------------------------
alto=50;ancho=50;x=100;desplazamiento = 10;puntos=20;%Inicializa los valores de las
%--------------------------------------------------------------------------
%---4. Inicio del juego----------------------------------------------------
%--------------------------------------------------------------------------
player = audioplayer(cancion, hz);%--Guarda la matriz de música en la variable player
play(player);%Comienza a reproducir la canción
while(1) %Ciclo de juegoo
    %---------Obtener captura para procesar-------------------------------
    snap = getsnapshot(vid);%Se hace snapshot al video para procesarlo
    snap = flip(snap,2);%Aplicamos el modo espejo-------------------------
    snap2 = snap;%Realizamos una copia de la imagen
    %--------------------IdentificaciÃ³n de objeto para jugar---------------
    r = snap(:,:,1);%Obtenemos la capa que contiene el color rojo de la imagen
    g = snap(:,:,2);%Obtenemos la capa que contiene el color verde de la imagen
    b = snap(:,:,3);%Obtenemos la capa que contiene el color azul de la imagen
    capaVerde = g - b/2 - r/2;%A la capa verde le restamos las capas roja y azul
    bw = capaVerde > 33;%Obtenemos los objetos donde estÃ¡ presente el color verde
    snap = bwareaopen(bw, 20);%La Funcion bwareaopen elimina todos los
    %componentes conectados (objetos) que tienen menos de Ppï¿½xeles de la
    %imagen binaria BW, asï¿½ obtenemos todos los objetos que cumplan con la
    %mascara
    
    %--------------------Mostrar snapshot en figura-----------------------
    figure(1);imshow(snap2);%Abre una ventana con para mostrar la imagen del snapshot
    
    %--------------------Condicion de Pause/Resume------------------------
    s  = regionprops(snap, {'centroid','area'});%Obtenemos las propiedades 'centroide' y 'area' de cada objeto que este blanco en BW
    if isempty(s)%Condición que "pausa"
        pause(player);%Pausa la canción
        text(190,210,'No se detecta ningun objeto verde','Color','w','FontSize', 14);%Texto que solicita el objeto verde
    else
        resume(player);%Reanuda la canción en caso de que estuviese pausada
        [~, id] = max([s.Area]);  %Obtenemos el ID del objeto cuya ï¿½rea sea la mayor en el vector de objetos
        xc = s(id).Centroid(1) - 5;yc = s(id).Centroid(2) - 5;%Componentes para el vector posición de la mano
        p = [xc, ((40*xc)/240)+337, 13, 13];%Creación del vector posicionn de la mano
        
        
        %---------------------------Elementos para enseñar en pantalla-----------------------
        txt = ['Puntos: ',num2str(puntos)];
        text(0,20,txt,'Color','black','FontSize', 14);
        hold on%Hold on se usa para posicionar encima de la figura actual
        guitarra = image(0,0,guitarraRead);set(guitarra, 'AlphaData', guitarraTrans);%Superpone la guitarra y le aplica su transparencia
        redNote=image(x,yr,redNoteRead);set(redNote, 'AlphaData', redTrans);%Superpone la primera nota roja y le aplica su transparencia
        greenNote=image(x+120,yg,greenNoteRead);set(greenNote, 'AlphaData', greenTrans);%Superpone la primera nota verde y le aplica su transparencia
        blueNote=image(x+240,yb,blueNoteRead);set(blueNote, 'AlphaData', blueTrans);%Superpone la primera nota azul y le aplica su transparencia
        redNote1=image(x,yr1,redNoteRead);set(redNote1, 'AlphaData', redTrans);%Superpone la segunda nota roja y le aplica su transparencia
        greenNote1=image(x+120,yg1,greenNoteRead);set(greenNote1, 'AlphaData', greenTrans);%Superpone la segunda nota verde y le aplica su transparencia
        blueNote1=image(x+240,yb1,blueNoteRead);set(blueNote1, 'AlphaData', blueTrans);%Superpone la segunda nota azul y le aplica su transparencia
        mano = image(xc-100,((40*xc)/240)+270,manoRead);set(mano, 'AlphaData', manoTrans);%Superpone la mano y aplica su transparencia
        hold off%Desactiva la superposición
        
        %--------------------------------------------------------------------------
        %---5. Hitbox--------------------------------------------------------------
        %--------------------------------------------------------------------------
        %---Establece la vectores que identificar el hitbox de cada nota---
        hitBoxR=[x+14,yr+14,ancho,alto];%Vector para la primera nota roja---
        hitBoxR1=[x+14,yr1+14,ancho,alto];%Vector para la segunda nota roja-
        hitBoxG=[x+134,yg+14,ancho,alto];%Vector para la primera nota verde-
        hitBoxG1=[x+134,yg1+14,ancho,alto];%Vector para la segunda nota verde
        hitBoxB=[x+254,yb+14,ancho,alto];%Vector para la primera nota azul
        hitBoxB1=[x+254,yb1+14,ancho,alto];%Vector para la segunda nota azul
        
        %------Colision de notas con mano-----------------
        %bboxOverlapRatio retorna el porcentaje de la colision
        if bboxOverlapRatio(p,hitBoxR)>0%Condición en caso de colision de la nota, con la mano
            yr = randi(100)*-1;%Redirecciona la nota a una posición random arriba
            puntos=puntos +10;%Aumenta los puntos del juego
        end
        if bboxOverlapRatio(p,hitBoxR1)>0%Condición en caso de colision de la nota, con la mano
            yr1 = randi(500)*-1;%Redirecciona la nota a una posición random arriba
            puntos=puntos +10;%Aumenta los puntos del juego
        end
        if bboxOverlapRatio(p,hitBoxG)>0%Condición en caso de colision de la nota, con la mano
            yg = randi(100)*-1;%Redirecciona la nota a una posición random arriba
            puntos=puntos +10;%Aumenta los puntos del juego
        end
        if bboxOverlapRatio(p,hitBoxG1)>0%Condición en caso de colision de la nota, con la mano
            yg1 = randi(500)*-1;%Redirecciona la nota a una posición random arriba
            puntos=puntos +10;%Aumenta los puntos del juego
        end
        
        if bboxOverlapRatio(p,hitBoxB)>0%Condición en caso de colision de la nota, con la mano
            yb = randi(100)*-1;%Redirecciona la nota a una posición random arriba
            puntos=puntos +10;%Aumenta los puntos del juego
        end
        if bboxOverlapRatio(p,hitBoxB1)>0%Condición en caso de colision de la nota, con la mano
            yb1 = randi(500)*-1;%Redirecciona la nota a una posición random arriba
            puntos=puntos +10;%Aumenta los puntos del juego
        end
        
        yr=yr+desplazamiento;yr1=yr1+desplazamiento;%Desplaza hacia abajo las notas rojas
        yg=yg+desplazamiento;yg1=yg1+desplazamiento;%Desplaza hacia abajo las notas verdes
        yb=yb+desplazamiento;yb1=yb1+desplazamiento;%Desplaza hacia abajo las notas azules
        
        %----------Colision de notas con ventana---------------------------
        if(yr>481)%Condición que evalua si la nota se salió de la ventana
            yr=randi(150)*-1;%Redirecciona la nota a una posición random arriba
            puntos = puntos-0.5*puntos;%Reduce los puntos del jugador
        end
        if(yg>481)%Condición que evalua si la nota se salió de la ventana
            yg=randi(150)*-1;%Redirecciona la nota a una posición random arriba
            puntos = puntos-0.5*puntos;%Reduce los puntos del jugador
        end
        if(yb>481)%Condición que evalua si la nota se salió de la ventana
            yb=randi(150)*-1;%Redirecciona la nota a una posición random arriba
            puntos = puntos-0.5*puntos;%Reduce los puntos del jugador
        end
        if(yr1>481)%Condición que evalua si la nota se salió de la ventana
            yr1=randi(150)*-1;%Redirecciona la nota a una posición random arriba
            puntos = puntos-0.5*puntos;%Reduce los puntos del jugador
        end
        if(yg1>481)%Condición que evalua si la nota se salió de la ventana
            yg1=randi(150)*-1;%Redirecciona la nota a una posición random arriba
            puntos = puntos-0.5*puntos;%Reduce los puntos del jugador
        end
        if(yb1>481)%Condición que evalua si la nota se salió de la ventana
            yb1=randi(150)*-1;%Redirecciona la nota a una posición random arriba
            puntos = puntos- 0.5*puntos;%Reduce los puntos del jugador
        end
           
    end %Fin de ejecución si detecta el objeto verde

    if puntos < 1 %Evalua si el puntaje es menor a 1
        text(190,210,'GAME OVER','Color','y','FontSize', 40);%Texto que se mostra cuando el jugador pierda     
        break %Interrumpe el ciclo que  captura snapshots
    end
    if (mod(vid.FramesAcquired,20)) ==0%Aumenta la dificultad a medida que avanza el juego
        desplazamiento=desplazamiento+0.5;%Aumenta el desplazamiento por snapshot
    end
    flushdata(vid,'triggers');%Limpia el buffer
end
%------Cierre del juego-----------------------
clear sound;%Termina la reproducción de la canción
stop(vid);%Finaliza la grabación
%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA ----------------------------
%--------------------------------------------------------------------------