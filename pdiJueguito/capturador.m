clear all ;close all;clc         % Limpia la ventana de comandos
objects = imaqfind %find video input objects in memory
delete(objects) %delete a video input object from memory

vid=videoinput('winvideo',1,'YUY2_640x480');% Se captura un stream de video usando videoinput, con argumento
% Se configura las opciones de adquision de video
set(vid,'ReturnedColorSpace','rgb');%la imagen del video se va a tomar en modo RGB
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);
start(vid);
while( vid.FramesAcquired <= 10000)       
    cdt0 = getsnapshot(vid);%Capturamos la imagen de la cámara
    cdt = flip(cdt0,2);%Aplicamos la función flip, que nos permite rotar la imagen y así evitar el efecto de espejo
    cdt2 = cdt;%Realizamos una copia de la imagen  
       
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
    figure(2);imshow(cdt2);
    s  = regionprops(cdt, {'centroid','area'});%Obtenemos las propiedades 'centroide' y 'área' de cada objeto que este blanco en BW
    if isempty(s)%Condicional que se encargará de reconocer si el vector con objetos 
        %que cumplen con la mascara de reconocimiento, se encuentra vacio.
        
    else
        
        [~, id] = max([s.Area]);  %Obtenemos el ID del objeto cuya área sea la mayor en el vector de objetos
        
        x = s(id).Centroid(1) - 5;%Coordenada en X para el CUADRO que identificará al jugador
        y = s(id).Centroid(2) - 5;%Coordenada en Y para el CUADRO que identificará al jugador
        p = [x, y, 13, 13];%Creación del vector posición para el jugador
        r = rectangle('Position',p,'EdgeColor','b','LineWidth',2) ;  
    end
end