 
%--------------------------------------------------------------------------
%------- JUEGO PDI ----------------------------------------------
%------- Coceptos básicos de PDI-------------------------------------------
%------- Por: Melissa Barba Bolivar    gloria.barba@udea.edu.co -----------
%------- CC 1045519955 ----------------------------------------------------
%------- Por:  Jefferson Jimenez Molina   jefferson.jimenez@udea.edu.co ----
%------- CC 1017254573 ----------------------------------------------------
%------- Estudiantes de Ingenieria de Sistemas UdeA -----------------------
%-------      -------------------------------------------------------------
%-------        PROFESOR DEL CURSO ----------------------------------------
%-------      David Fernández    david.fernandez@udea.edu.co --------------
%-------      Profesor Facultad de Ingenieria BLQ 21-409  -----------------
%-------      CC 71629489, Tel 2198528,  Wpp 3007106588 -------------------
%------- Curso Básico de Procesamiento de Imágenes y Visión Artificial-----
%------- Septiembre 2017--------------------------------------------------
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
%--1. Inicializo el sistema -----------------------------------------------
%--------------------------------------------------------------------------


clear all   % Inicializa todas las variables
close all   % Cierra todas las ventanas, archivos y procesos abiertos
clc         % Limpia la ventana de comandos
objects = imaqfind %find video input objects in memory
delete(objects) %delete a video input object from memory

%--------------------------------------------------------------------------
%-- 2. Configuracion de la captura de video -------------------------------
%--------------------------------------------------------------------------


vid=videoinput('winvideo',1,'YUY2_640x480');% Se captura un stream de video usando videoinput, con argumento
% Se configura las opciones de adquision de video
set(vid,'ReturnedColorSpace','rgb');%la imagen del video se va a tomar en modo RGB
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);


%--------------------------------------------------------------------------
%-- 3. Definición de variables --------------------------------------------
%--------------------------------------------------------------------------

%Los bloques con los que se interactuará a lo largo del juego, son
%RECTANGULOS

%Caracteristicas de los bloques
alto=65;%Propiedad que denota la altura de los bloques, la cual es la misma para los 8 ejemplares
ancho1=270;%Propiedad que denota la anchura de un bloque
ancho2=350;%Propiedad que denota la anchura de un bloque
ancho3=160;%Propiedad que denota la anchura de un bloque 
ancho4=460;%Propiedad que denota la anchura de un bloque 
ancho5=80;%Propiedad que denota la anchura de un bloque

%Inicializar las posiciones (coordenadas) de los bloques
x1=0;%Coordenada en X para el bloque 1
y1=0;%Coordenada en Y para el bloque 1
x2=640-ancho1;%Coordenada en X para el bloque 1
y2=5;%Coordenada en Y para el bloque 2
x3=0;%Coordenada en X para el bloque 2
y3=120;%Coordenada en Y para el bloque 3 
x4=640-ancho3;%Coordenada en X para el bloque 4
y4=125;%Coordenada en Y para el bloque 4
x5=0;%Coordenada en X para el bloque 5
y5=240;%Coordenada en Y para el bloque 5 
x6=640-ancho1;%Coordenada en X para el bloque 6
y6=250;%Coordenada en Y para el bloque 6 
x7=0;%Coordenada en X para el bloque 7
y7=360;%Coordenada en Y para el bloque 7 
x8=640-ancho5;%Coordenada en X para el bloque 8
y8=365;%Coordenada en Y para el bloque 8

vel=6;%Velocidad inicial con la que caerán los bloques, la cual se irá modificando
start(vid);%Inicialización del capturador de video

%--------------------------------------------------------------------------
%-- 4. Inicio del Juego --------------------------------------------
%--------------------------------------------------------------------------

%Creamos un ciclo WHILE, el cual estará condicionado por la cantidad de
%Frames adquiridos a lo largo del juego, en este caso, mientras esa
%cantidad sea menor o igual que 10000

while( vid.FramesAcquired <= 10000)
    
        
%--------------------------------------------------------------------------
%-- 5. Captura de Imagen del video --------------------------------------------
%--------------------------------------------------------------------------

    cdt0 = getsnapshot(vid);%Capturamos la imagen de la cámara
    cdt = flip(cdt0,2);%Aplicamos la función flip, que nos permite rotar la imagen y así evitar el efecto de espejo
    cdt2 = cdt;%Realizamos una copia de la imagen
    
%--------------------------------------------------------------------------
%-- 6. Reconociendo el color VERDE en la imagen ----------------
%--------------------------------------------------------------------------
    
    r = cdt(:,:,1);%Obtenemos la capa que contiene el color rojo de la imagen
    g = cdt(:,:,2);%Obtenemos la capa que contiene el color verde de la imagen
    b = cdt(:,:,3);%Obtenemos la capa que contiene el color azul de la imagen
    justGreen = g - b/2 - r/2;%A la capa verde le restamos las capas roja y azul
    %dividas entre 2 cada una, esto con la finalidad de obtener de la
    %imagen el color verde presente en la misma.
    bw = justGreen > 33;%Binarizamos la imagen, obteniendo así los objetos
    %donde el color verde se encuentre presente
    cdt = bwareaopen(bw, 20);%La Funcion bwareaopen elimina todos los 
    %componentes conectados (objetos) que tienen menos de Ppíxeles de la 
    %imagen binaria BW, así obtenemos todos los objetos que cumplan con la
    %mascara
    
%--------------------------------------------------------------------------
%-- 7. Vizualizar los bloques en Pantalla ----------------
%--------------------------------------------------------------------------

    figure(2);imshow(cdt2);%Mostramos la imagen
    
    % Bloques coordenadas y dimensiones
    %Vector posición se compone de Xinicial, Yinicial, Ancho y Alto
    p1 = [x1, y1, ancho1, alto];%Creación del vector posición para el bloque 1
    p2 = [x2, y2, ancho1, alto];%Creación del vector posición para el bloque 2
    
    p3 = [x3, y3, ancho2, alto];%Creación del vector posición para el bloque 3
    p4 = [x4, y4, ancho3, alto];%Creación del vector posición para el bloque 4
    
    p5 = [x5, y5, ancho1, alto];%Creación del vector posición para el bloque 5
    p6 = [x6, y6, ancho1, alto];%Creación del vector posición para el bloque 6
    
    p7 = [x7, y7, ancho4, alto];%Creación del vector posición para el bloque 7
    p8 = [x8, y8, ancho5, alto];%Creación del vector posición para el bloque 8
    
    %Dibujar bloques
    b1 = rectangle('Position',p1,'LineWidth',1,'FaceColor',[0 0.8 1],'EdgeColor',[0 0.8 1]);%Se dibuja el bloque 1
    b2 = rectangle('Position',p2,'LineWidth',1,'FaceColor',[0 0.8 1],'EdgeColor',[0 0.8 1]);%Se dibuja el bloque 2
    b3 = rectangle('Position',p3,'LineWidth',1,'FaceColor',[0 0.8 1],'EdgeColor',[0 0.8 1]);%Se dibuja el bloque 3
    b4 = rectangle('Position',p4,'LineWidth',1,'FaceColor',[0 0.8 1],'EdgeColor',[0 0.8 1]);%Se dibuja el bloque 4
    b5 = rectangle('Position',p5,'LineWidth',1,'FaceColor',[0 0.8 1],'EdgeColor',[0 0.8 1]);%Se dibuja el bloque 5
    b6 = rectangle('Position',p6,'LineWidth',1,'FaceColor',[0 0.8 1],'EdgeColor',[0 0.8 1]);%Se dibuja el bloque 6
    b7 = rectangle('Position',p7,'LineWidth',1,'FaceColor',[0 0.8 1],'EdgeColor',[0 0.8 1]);%Se dibuja el bloque 7
    b8 = rectangle('Position',p8,'LineWidth',1,'FaceColor',[0 0.8 1],'EdgeColor',[0 0.8 1]);%Se dibuja el bloque 8
    
%--------------------------------------------------------------------------
%-- 8. Reconocimiento del objeto interactuante ----------------
%--------------------------------------------------------------------------

    %Centroide del objeto Verde
    s  = regionprops(cdt, {'centroid','area'});%Obtenemos las propiedades 'centroide' y 'área' de cada objeto que este blanco en BW
    if isempty(s)%Condicional que se encargará de reconocer si el vector con objetos 
        %que cumplen con la mascara de reconocimiento, se encuentra vacio.
        
    else
        
        [~, id] = max([s.Area]);  %Obtenemos el ID del objeto cuya área sea la mayor en el vector de objetos
        hold on%comando para sobre escribir imagenes en pantalla
        
%--------------------------------------------------------------------------
%-- 9. Visualización del objeto y los marcadores ----------------
%--------------------------------------------------------------------------


        txt = ['NIVEL: ',num2str(vel)];%Marcador encargado del NIVEL en el que se
        %encuentra el participante (Es igual a la velocidad que lleve el
        %juego)
        text(0,20,txt,'Color','b','FontSize', 14);%Se definen carecteristicas del
        %texto encargado del NIVEL
        txt2 = ['PUNTOS: ',num2str(vid.FramesAcquired)];%Marcador encargado del 
        %PUNTAJE que lleve el participante (Es igual a la ca ntidad de
        %frames que han sido capturados hasta el momento
        text(0,40,txt2,'Color','r','FontSize', 14);%Se definen carecteristicas del
        %texto encargado del PUNTOS
        
        % Rectangulo.
        x = s(id).Centroid(1) - 5;%Coordenada en X para el CUADRO que identificará al jugador
        y = s(id).Centroid(2) - 5;%Coordenada en Y para el CUADRO que identificará al jugador
        p = [x, y, 13, 13];%Creación del vector posición para el jugador
        
        %Dibujar rectangulo
        r = rectangle('Position',p,'EdgeColor','b','LineWidth',2);%Se dibuja el
        %Cuadrado correspondiente al objeto del jugador
        
%--------------------------------------------------------------------------
%-- 10. Control de choques ----------------
%--------------------------------------------------------------------------
        
    
        %¿Chocan?
        area1 = bboxOverlapRatio(p,p1);%La función bboxOverlapRatio retorna 1 
        %en caso de que el bloque 1 y e ljugador se encuentren superpuestos
        %lo cual en nuestro caso consideramos una colisión entre ambos
        area2 = bboxOverlapRatio(p,p2);%La función bboxOverlapRatio retorna 1 
        %en caso de que el bloque 2 y e ljugador se encuentren superpuestos
        %lo cual en nuestro caso consideramos una colisión entre ambos
        area3 = bboxOverlapRatio(p,p3);%La función bboxOverlapRatio retorna 1 
        %en caso de que el bloque 3 y e ljugador se encuentren superpuestos
        %lo cual en nuestro caso consideramos una colisión entre ambos
        area4 = bboxOverlapRatio(p,p4);%La función bboxOverlapRatio retorna 1 
        %en caso de que el bloque 4 y e ljugador se encuentren superpuestos
        %lo cual en nuestro caso consideramos una colisión entre ambos
        area5 = bboxOverlapRatio(p,p5);%La función bboxOverlapRatio retorna 1 
        %en caso de que el bloque 5 y e ljugador se encuentren superpuestos
        %lo cual en nuestro caso consideramos una colisión entre ambos
        area6 = bboxOverlapRatio(p,p6);%La función bboxOverlapRatio retorna 1 
        %en caso de que el bloque 6 y e ljugador se encuentren superpuestos
        %lo cual en nuestro caso consideramos una colisión entre ambos
        area7 = bboxOverlapRatio(p,p7);%La función bboxOverlapRatio retorna 1 
        %en caso de que el bloque 7 y e ljugador se encuentren superpuestos
        %lo cual en nuestro caso consideramos una colisión entre ambos
        area8 = bboxOverlapRatio(p,p8);%La función bboxOverlapRatio retorna 1 
        %en caso de que el bloque 8 y e ljugador se encuentren superpuestos
        %lo cual en nuestro caso consideramos una colisión entre ambos
        
%--------------------------------------------------------------------------
%-- 11. Condición para perder ----------------
%--------------------------------------------------------------------------        
        
        %Para el juego si toca algún bloque DESPUÉS DE 25 FRAMES
        if  vid.FramesAcquired > 25%Pausa inicial para que el usuario tome posición
              text(x-5,y,'O','Color','g','FontSize', 20);
            if area1 > 0 ||  area2 > 0 || area3 > 0 || area4 > 0 || area5 > 0 || area6 > 0 || area7 > 0 || area8 > 0 %Si en alguna
                %de las 8 áreas de cada uno de los bloques, hubo almenos 1
                %colisión (area != 0), se mostrará el mensaje
                %correspondiente a la derrota
                text(190,210,'GAME OVER','Color','b','FontSize', 40);%Texto que se mostrará cuando el jugador pierda
                text(250,250,txt2,'Color','r','FontSize', 20);%Se definen carecteristicas del
                %texto encargado del GAME OVER
                break
            end
        end
    end
    
    hold off%Se cierra la superposición en la imagen de pantalla
    
%--------------------------------------------------------------------------
%-- 12. Control Velocidad ----------------
%--------------------------------------------------------------------------    
    
    
    
    %Cambio velocidad
    if (mod(vid.FramesAcquired,20)) ==0%Si la cantidad de frames adquiridos
        %es multiplo de 20, se dará inicio al incremento en la velocidad
        %del juego
        vel=vel+0.5;%Aumento de la velocidad
    end
    
%--------------------------------------------------------------------------
%-- 13. Control Movimiento de los Bloques ----------------
%--------------------------------------------------------------------------    
    
    %Movimiento de bloques
    if y1>475%Si la Coordenada en Y es mayor que 475 (teniendo en cuenta que la
        %pantalla es de 480), se reiniciará el bloque 1, haciendo que este
        %aparezca nuevamente en su posición inicial
        y1=0;
        
    else
        y1=y1+vel;%De lo contrario, se procederá a sumar en la Coordenada Y la velocidad
        %actual del juego, lo que permitirá el movimiento en caida libre
        %del bloque 1
    end
    %%%
    if y2>475%Si la Coordenada en Y es mayor que 475 (teniendo en cuenta que la
        %pantalla es de 480), se reiniciará el bloque 2, haciendo que este
        %aparezca nuevamente en su posición inicial
        y2=0;
        
    else%De lo contrario, se procederá a sumar en la Coordenada Y la velocidad
        %actual del juego, lo que permitirá el movimiento en caida libre
        %del bloque 2
        y2=y2+vel;
    end
    %
    if y3>470%Si la Coordenada en Y es mayor que 475 (teniendo en cuenta que la
        %pantalla es de 480), se reiniciará el bloque 3, haciendo que este
        %aparezca nuevamente en su posición inicial
        y3=0;
        
    else
        y3=y3+vel;%De lo contrario, se procederá a sumar en la Coordenada Y la velocidad
        %actual del juego, lo que permitirá el movimiento en caida libre
        %del bloque 3
    end
    %
    if y4>480%Si la Coordenada en Y es mayor que 475 (teniendo en cuenta que la
        %pantalla es de 480), se reiniciará el bloque 4, haciendo que este
        %aparezca nuevamente en su posición inicial
        y4=0;
    else
        y4=y4+vel;%De lo contrario, se procederá a sumar en la Coordenada Y la velocidad
        %actual del juego, lo que permitirá el movimiento en caida libre
        %del bloque 4
    end
    %
    if y5>470%Si la Coordenada en Y es mayor que 475 (teniendo en cuenta que la
        %pantalla es de 480), se reiniciará el bloque 5, haciendo que este
        %aparezca nuevamente en su posición inicial
        y5=0;
        
    else
        y5=y5+vel;%De lo contrario, se procederá a sumar en la Coordenada Y la velocidad
        %actual del juego, lo que permitirá el movimiento en caida libre
        %del bloque 5
    end
    
    if y6>475%Si la Coordenada en Y es mayor que 475 (teniendo en cuenta que la
        %pantalla es de 480), se reiniciará el bloque 6, haciendo que este
        %aparezca nuevamente en su posición inicial
        y6=0;
    else
        y6=y6+vel;%De lo contrario, se procederá a sumar en la Coordenada Y la velocidad
        %actual del juego, lo que permitirá el movimiento en caida libre
        %del bloque 6
    end
    
    if y7>475%Si la Coordenada en Y es mayor que 475 (teniendo en cuenta que la
        %pantalla es de 480), se reiniciará el bloque 7, haciendo que este
        %aparezca nuevamente en su posición inicial
        y7=0;
    else
        y7=y7+vel;%De lo contrario, se procederá a sumar en la Coordenada Y la velocidad
        %actual del juego, lo que permitirá el movimiento en caida libre
        %del bloque 7
    end
    
    if y8>470%Si la Coordenada en Y es mayor que 475 (teniendo en cuenta que la
        %pantalla es de 480), se reiniciará el bloque 8, haciendo que este
        %aparezca nuevamente en su posición inicial
        y8=0;
    else
        y8=y8+vel;%De lo contrario, se procederá a sumar en la Coordenada Y la velocidad
        %actual del juego, lo que permitirá el movimiento en caida libre
        %del bloque 8
    end
    
end


%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA ----------------------------
%--------------------------------------------------------------------------
