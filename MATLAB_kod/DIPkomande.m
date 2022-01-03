clc; clear all; close all;

%% Ucitavanje foto
slika = imread('kraljDenari.jpg');
predlozak = imread('kraljDenariPredlozak.jpg');

%% Prebacivanje u sivi ton
slikaCB = im2gray(slika);
predlozakCB = im2gray(predlozak);

%% Grafika, racunanje kroskorelacije, te pronalazak vrh
f1 = figure('Name', 'Kros-korelacijska ravnina', 'NumberTitle', 'off');
f2 = figure('Name', 'Pronadjeno', 'NumberTitle', 'off');
figure(f1);
krosKor = normxcorr2(predlozakCB, slikaCB); %racunanje kros-korelacije
surf(krosKor);
shading flat;
[yVrh, xVrh] = find(krosKor==max(krosKor(:))); %pronalazak najvece vrijednosti
yoffset = yVrh - size(predlozakCB, 1);
xoffset = xVrh - size(predlozakCB, 2);
figure(f2);
imshow(slika)
drawrectangle(gca, 'Position', [xoffset, yoffset, size(predlozak, 2), size(predlozak, 1)], 'FaceAlpha', 0);




