
clear all;  % Inicializa todas las variables
close all;   % Cierra todas las ventanas, archivos y procesos abiertos
clc         % Limpia la ventana de comandos
objects = imaqfind; %find video input objects in memory
delete(objects) %delete a video input object from memory
%--------------------------------------------------------------------------
%-- 2. Configuracion de la captura de video -------------------------------
%-------------------------------------------------------------------------
vid=videoinput('winvideo',1,'YUY2_640x480');% Se captura un stream de video usando videoinput, con argumento
set(vid,'ReturnedColorSpace','rgb');%la imagen del video se va a tomar en modo RGB
set(vid,'TriggerRepeat',Inf);
start(vid);
x=100;
velocidad = 10;
%------Posiciones random iniciales de las notas musicales.
yr=randi(1000)*-1;
yr1=randi(1000)*-1;
yg=randi(1000)*-1;
yg1=randi(1000)*-1;
yb=randi(1000)*-1;
yb1=randi(1000)*-1;
%-------
alto=50;ancho=50;

[guitarraRead,map0,guitarraTrans]=imread('Imagenes/Guitarra.png');
[redNoteRead,map1,redTrans]=imread('Imagenes/rojo.png');
[greenNoteRead,map2,greenTrans]=imread('Imagenes/verde.png');
[blueNoteRead,map3,blueTrans]=imread('Imagenes/azul.png');

song=input('Ingrese\n1 Dejavu-Initial D\n2 El paso del gigante-Grupo soñador\n3 Raining blood-Slayer\n4 Scar tissue-RHCP');

switch song
case 1
    [cancion,hz] = audioread('Canciones/Dejavu.mp3');
case 2
    [cancion,hz] = audioread('Canciones/ElPasoDelGigante.mp3');
case 3
    [cancion,hz] = audioread('Canciones/RainingBlood.mp3');
case 4
    [cancion,hz] = audioread('Canciones/ScarTissue.mp3');
otherwise
    disp('Selección no valida,se jugará con la primera canción por bob@');
    [cancion,hz] = audioread('Canciones/Dejavu.mp3');       
end

sound(cancion*0.07,hz)   
puntos=20;
while( vid.FramesAcquired <= 10000)   
    
    
    cdt0 = getsnapshot(vid);%Capturamos la imagen de la c�mara
    cdt = flip(cdt0,2);%Aplicamos la funci�n flip, que nos permite rotar la imagen y as� evitar el efecto de espejo
    cdt2 = cdt;%Realizamos una copia de la imagen  
    
    
    txt = ['puntos: ',num2str(puntos)];
    text(0,20,txt,'Color','b','FontSize', 14);
    
    %--------------------get Pajuela
    
    r = cdt(:,:,1);%Obtenemos la capa que contiene el color rojo de la imagen
    g = cdt(:,:,2);%Obtenemos la capa que contiene el color verde de la imagen
    b = cdt(:,:,3);%Obtenemos la capa que contiene el color azul de la imagen
    justGreen = g - b/2 - r/2;%A la capa verde le restamos las capas roja y azul
    %dividas entre 2 cada una, esto con la finalidad de obtener de la
    %imagen el color verde presente en la misma.
    bw = justGreen > 33;%Binarizamos la imagen, obteniendo as� los objetos
    %donde el color verde se encuentre presente
    cdt = bwareaopen(bw, 20);%La Funcion bwareaopen elimina todos los 
    %componentes conectados (objetos) que tienen menos de Pp�xeles de la 
    %imagen binaria BW, as� obtenemos todos los objetos que cumplan con la
    %mascara
    
    %-------------------------------------- 
   
    figure(1);imshow(cdt2);
    
    
    hitBoxR=[x+14,yr+14,ancho,alto];
    hitBoxR1=[x+14,yr1+14,ancho,alto];
    hitBoxG=[x+134,yg+14,ancho,alto];
    hitBoxG1=[x+134,yg1+14,ancho,alto];
    hitBoxB=[x+254,yb+14,ancho,alto];
    hitBoxB1=[x+254,yb1+14,ancho,alto];
    
    
 
    hold on
    guitarra = image(0,0,guitarraRead);set(guitarra, 'AlphaData', guitarraTrans);
    
    redNote=image(x,yr,redNoteRead);set(redNote, 'AlphaData', redTrans);
    greenNote=image(x+120,yg,greenNoteRead);set(greenNote, 'AlphaData', greenTrans);
    blueNote=image(x+240,yb,blueNoteRead);set(blueNote, 'AlphaData', blueTrans);
    
    redNote1=image(x,yr1,redNoteRead);set(redNote1, 'AlphaData', redTrans);
    greenNote1=image(x+120,yg1,greenNoteRead);set(greenNote1, 'AlphaData', greenTrans);
    blueNote1=image(x+240,yb1,blueNoteRead);set(blueNote1, 'AlphaData', blueTrans);
    
    
 
    hold off
    s  = regionprops(cdt, {'centroid','area'});%Obtenemos las propiedades 'centroide' y '�rea' de cada objeto que este blanco en BW
    if isempty(s)%Condicional que se encargar� de reconocer si el vector con objetos 
        %que cumplen con la mascara de reconocimiento, se encuentra vacio.
        
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