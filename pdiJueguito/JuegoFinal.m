clear all;close all;clc         % Limpia la ventana de comandos
objects = imaqfind;delete(objects9; %delete a video input object from memory
%--------------------------------------------------------------------------
%-- 2. Configuracion de la captura de video -------------------------------
%-------------------------------------------------------------------------
vid=videoinput('winvideo',1,'YUY2_640x480');% Se captura un stream de video usando videoinput, con argumento
% Se configura las opciones de adquision de video
set(vid,'ReturnedColorSpace','rgb');%la imagen del video se va a tomar en modo RGB
set(vid,'FramesPerTrigger',1);
set(vid,'TriggerRepeat',Inf);
start(vid);
while( vid.FramesAcquired <= 10000)
snapshot = getsnapshot(vid);%Capturamos la imagen de la cámara
cdt = flip(snapshot,2);%Aplicamos la función flip, que nos permite rotar la imagen y así evitar el efecto de espejo
cdt2 = cdt;[fill,col,cap]=size(cdt2);%Realizamos una copia de la imagen



guitarra=imread('Guitarra.png');guitarra=imresize(guitarra,[fill,col]);
guitarra = (guitarra*1.5)+(cdt2*0.8); 
end
