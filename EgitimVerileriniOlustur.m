clc, clear all, close all;

% Dizini matlab ortam�na import edildi
dizin = dir('EgitimGoruntuleri\');

% Dosya adlar�
dosyaAdlari = {dizin.name};

% G�r�nt�leri al�yoruz (3 den baslayarak)
dosyaAdlari = dosyaAdlari(3:end);

% 2 sat�r, 62(dosya say�s� kadar) s�tunlu bir cell veri tipi olu�turuldu
goruntuler = cell(2, length(dosyaAdlari));

for i=1:length(dosyaAdlari)
    
    %G�r�nt�ler cell tipinde 1.sat�r�n t�m s�tunlar�na ekleniyor     
    goruntuler(1, i) = {imread(['EgitimGoruntuleri', '\', cell2mat(dosyaAdlari(i))])};
    
    temp = cell2mat(dosyaAdlari(i));
    goruntuler(2, i) = {temp(1)};
    
end
save('imgfiledata.mat', 'goruntuler')
clear;