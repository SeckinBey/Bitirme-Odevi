clc, clear all, close all;

load imgfiledata.mat;

% Kullaniciya dosya seçtirme islemi
[dosya, dosyaYolu] = uigetfile({'*.jpg; *.bmp; *.tif; *.png'}, 'Bir goruntu secin');

% Dosya adi tam  haliyle olusturuldu
dosya = [dosyaYolu, dosya];

goruntu = imread(dosya);

[, boyut] = size(goruntu);
goruntu = imresize(goruntu, [300, 500]);

% Eger goruntu renkli ise gri ye cevir.
if size(goruntu, 3) == 3
    
    goruntu = rgb2gray(goruntu);
    
end

% Grilik seviyesine gore goruntuyu binary e cevirdik
threshold = graythresh(goruntu);
goruntu = imbinarize(goruntu, threshold);

goruntuTersi = ~goruntu;
figure, imshow(goruntu), title("Orjinal Goruntu");
figure, imshow(goruntuTersi), title("Goruntunun Tersi");

% Gurultu temizleme islemleri
if boyut > 2000
    goruntu1 = bwareaopen(goruntuTersi, 3500);
else
    goruntu1 = bwareaopen(goruntuTersi, 3000);
end

figure, imshow(goruntu1), title("Temizlenmis Goruntu")

goruntu2 = goruntuTersi -  goruntu1;
figure, imshow(goruntu2), title("Cikarilmis Goruntu");


goruntu2 = bwareaopen(goruntu2, 200);
figure, imshow(goruntu2), title("Cikarilmis Goruntu 2");

[etiketler, Nesneler] = bwlabel(goruntu2);
nesneOzellikler = regionprops(etiketler, 'BoundingBox');

hold on 

pause(1);


for n=1: size(nesneOzellikler, 1)

rectangle('Position', nesneOzellikler(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2);

end
hold off

%Tum plaka degerlerini finalCikis degiskeninde sakliyoruz
finalCikis = [];
% Her nesnenin max korelasyon degerini tutar
t = [];
% Karakter sayisini bulduk
karakterSayisi = size(goruntuler, 2);

for n=1: Nesneler
% %   Etiketlenmis goruntude karakter ara
[r, c] = find(etiketler == n);
karakter = goruntuTersi(min(r): max(r), min(c): max(c));
karakter = imresize(karakter, [42, 24]);
figure, imshow(karakter), title('Karakter');

pause(0.2);
x = [];


% elde ettigimiz nesnenin  veritabanindaki tüm karakterlerle kiyaslamasini
% yapiyoruz
for k=1: karakterSayisi
    y = corr2(goruntuler{1, k}, karakter);
    x = [x y];
end

t = [t max(x)];

if(max(x) > 0.4)
    enBuyukIndis = find(x == max(x));
    cikisKarakter = cell2mat(goruntuler(2, enBuyukIndis));
    finalCikis = [finalCikis cikisKarakter]
end

end

dosyaAdi = 'plakaKarakterleri.txt';
dosya = fopen(dosyaAdi, 'wt');
fprintf(dosya, '%s\n', finalCikis);
fclose(dosya);
winopen(dosyaAdi);




