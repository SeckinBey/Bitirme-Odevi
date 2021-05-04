clc, clear all, close all;

% Dizini matlab ortamýna import edildi
dizin = dir('EgitimGoruntuleri\');

% Dosya adlarý
dosyaAdlari = {dizin.name};

% Görüntüleri alýyoruz (3 den baslayarak)
dosyaAdlari = dosyaAdlari(3:end);

% 2 satýr, 62(dosya sayýsý kadar) sütunlu bir cell veri tipi oluþturuldu
goruntuler = cell(2, length(dosyaAdlari));

for i=1:length(dosyaAdlari)
    
    %Görüntüler cell tipinde 1.satýrýn tüm sütunlarýna ekleniyor     
    goruntuler(1, i) = {imread(['EgitimGoruntuleri', '\', cell2mat(dosyaAdlari(i))])};
    
    temp = cell2mat(dosyaAdlari(i));
    goruntuler(2, i) = {temp(1)};
    
end
save('imgfiledata.mat', 'goruntuler')
clear;