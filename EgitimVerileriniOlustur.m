clc, clear all, close all;

% Dizin matlab ortamina import edildi
dizin = dir('EgitimGoruntuleri\');

% Dosya adlari
dosyaAdlari = {dizin.name};

% Goruntuleri aliyoruz (3 den baslayarak)
dosyaAdlari = dosyaAdlari(3:end);

% 2 satir, 62(dosya sayisi kadar) sütunlu bir cell veri tipi olusturuldu
goruntuler = cell(2, length(dosyaAdlari));

for i=1:length(dosyaAdlari)
    
    %Görüntüler cell tipinde 1.satirin tüm sütunlarina ekleniyor     
    goruntuler(1, i) = {imread(['EgitimGoruntuleri', '\', cell2mat(dosyaAdlari(i))])};
    
    temp = cell2mat(dosyaAdlari(i));
    goruntuler(2, i) = {temp(1)};
    
end
save('imgfiledata.mat', 'goruntuler')