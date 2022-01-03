clc;
clear all;
close all;

sl_A = im2gray(imread('PIVlab_gen_01.tif'));
sl_B = im2gray(imread('PIVlab_gen_02.tif'));

prozIspit = [32, 32]; %%velicina prozora ispitivanja [x, y]
odmak = 33; %%odmak od pocetka i kraja mreze

%%Generiranje mreze
x_mreza = odmak:prozIspit(1)/2:size(sl_A, 1)-odmak;
y_mreza = odmak:prozIspit(2)/2:size(sl_A, 2)-odmak;

%%Broj prozora ispitivanja
N_x = length(x_mreza);
N_y = length(y_mreza);

%Za svaki prozor ispitivanja, prvo se moraju kreirati testne matrice na
%Slici 1. Nakon toga na Slici 2 potrebno je korelirati taj kreirani testni
%prozor oko svoje originalne pozicije na Slici 1, raspon je vec prije
%odredjen. Pixel koji daje najvecu vrijednost korelacije odgovara finalnom
%prosjecnom pomaku toga prozora ispitivanja
test_sl_A(prozIspit(2), prozIspit(1)) = 0;
test_sl_B(2*prozIspit(2) ,2*prozIspit(1)) = 0; % zelim da mi je slika po kojoj ce se template ispitivati 2 put veca od samog templeta
dpy(N_x, N_y) = 0;
dpx(N_x, N_y) = 0;
xVrh = 0;
yVrh = 0;


for i=1:N_x
    for j=1:N_y
        %variranje prozora ispitivanja
        xmin = x_mreza(i) - prozIspit(2)/2;
        xmax = x_mreza(i) + prozIspit(2)/2;
        ymin = y_mreza(j) - prozIspit(1)/2;
        ymax = y_mreza(j) + prozIspit(1)/2;
        
        %definiranje trenutnog prozora ispitivanja i dijela slike koja ce se pretrazivati
        temp = sl_A(xmin:xmax, ymin:ymax);
        slika = sl_B((1+xmin-prozIspit(1)/2):(xmax+prozIspit(1)/2), (1+ymin-prozIspit(2)/2):(ymax+prozIspit(2)/2));
        
        %racunanje kroskorelacijske matrice
        korMatr = normxcorr2(temp, slika);
        
        %pronalazak koordinata unutar kroskorelacijske matrice gdje imamo najvisi vrh
        [xVrh, yVrh] = find(korMatr==max(korMatr(:)));
        
        %re-skaliranje
        xVrh1 = xmin + xVrh - prozIspit(1);
        yVrh1 = xmin + yVrh - prozIspit(2);
        
        dpx(i, j) = xVrh1 - x_mreza(i);
        dpy(i, j) = yVrh1 - y_mreza(i);
        dp(i, j) = sqrt(dpx(i, j)^2+dpy(i, j)^2);
    end
end

f1 = figure('Name', 'PIV', 'NumberTitle', 'off');
imshow(sl_A);
hold on;
faktSkal = 3;
quiver(y_mreza, x_mreza, dpy*faktSkal, dpx*faktSkal, 'g', 'LineWidth', 1, 'AutoScale', 'off') %%x i y idu na suprotna mjesta zbog toga sto je koordinatni sustav u matrici slike izokrenut redci su x-os, a stupci su y-os 
