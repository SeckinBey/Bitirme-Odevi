clc, clear all, close all;

load imgfiledata.mat;

% Kullanýcýya dosya seçtirme iþlemi
[dosya, dosyaYolu] = uigetfile({'*.jpg; *.bmp; *.tif; *.png'}, 'Bir görüntü seçin');

% Dosya adý tam  haliyle oluþturuldu
dosya = [dosyaYolu, dosya];

goruntu = imread(dosya);

[~, boyut] = size(goruntu);
goruntu = imresize(goruntu, [300, 500]);

% Eðer görüntü renkli ise gri ye çevir.
if size(goruntu, 3) == 3
    
    goruntu = rgb2gray(goruntu);
    
end

% Grilik seviyesine göre görüntüyü binary e çevirdik
threshold = graythresh(goruntu);
goruntu = imbinarize(goruntu, threshold);

goruntuTersi = ~goruntu;
figure, imshow(goruntu), title("Orjinal Görüntü");
figure, imshow(goruntuTersi), title("Görüntünün Tersi");

% Gürültü temizleme iþlemleri
if boyut > 2000
    goruntu1 = bwareaopen(goruntuTersi, 3500);
else
    goruntu1 = bwareaopen(goruntuTersi, 3000);
end

figure, imshow(goruntu1), title("Temizlenmiþ Görüntü")

goruntu2 = goruntuTersi -  goruntu1;
figure, imshow(goruntu2), title("Çýkarýlmýþ Görüntü");


goruntu2 = bwareaopen(goruntu2, 200);
figure, imshow(goruntu2), title("Çýkarýlmýþ Görüntü 2");

[etiketler, Nesneler] = bwlabel(goruntu2);
nesneOzellikler = regionprops(etiketler, 'BoundingBox');

hold on 

pause(1);


for n=1: size(nesneOzellikler, 1)

rectangle('Position', nesneOzellikler(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2);

end
hold off

%Tüm plaka deðerlerini finalCikis deðiþkeninde saklýyoruz
finalCikis = [];
% Her nesnenin max korelasyon deðerini tutar
t = [];
% Karakter sayýsýný bulduk
karakterSayisi = size(goruntuler, 2);

for n=1: Nesneler
% %   Etiketlenmiþ görüntüde karakter ara
[r, c] = find(etiketler == n);
karakter = goruntuTersi(min(r): max(r), min(c): max(c));
karakter = imresize(karakter, [42, 24]);
figure, imshow(karakter), title('Karakter');

pause(0.2);
x = [];


% elde ettiðimiz nesnenin  veritabanýndaki tüm karakterlerle kýyaslamasýný
% yapýyoruz
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




