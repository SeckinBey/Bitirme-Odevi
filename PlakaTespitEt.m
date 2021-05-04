clc, clear all, close all;

load imgfiledata.mat;

% Kullan�c�ya dosya se�tirme i�lemi
[dosya, dosyaYolu] = uigetfile({'*.jpg; *.bmp; *.tif; *.png'}, 'Bir g�r�nt� se�in');

% Dosya ad� tam  haliyle olu�turuldu
dosya = [dosyaYolu, dosya];

goruntu = imread(dosya);

[~, boyut] = size(goruntu);
goruntu = imresize(goruntu, [300, 500]);

% E�er g�r�nt� renkli ise gri ye �evir.
if size(goruntu, 3) == 3
    
    goruntu = rgb2gray(goruntu);
    
end

% Grilik seviyesine g�re g�r�nt�y� binary e �evirdik
threshold = graythresh(goruntu);
goruntu = imbinarize(goruntu, threshold);

goruntuTersi = ~goruntu;
figure, imshow(goruntu), title("Orjinal G�r�nt�");
figure, imshow(goruntuTersi), title("G�r�nt�n�n Tersi");

% G�r�lt� temizleme i�lemleri
if boyut > 2000
    goruntu1 = bwareaopen(goruntuTersi, 3500);
else
    goruntu1 = bwareaopen(goruntuTersi, 3000);
end

figure, imshow(goruntu1), title("Temizlenmi� G�r�nt�")

goruntu2 = goruntuTersi -  goruntu1;
figure, imshow(goruntu2), title("��kar�lm�� G�r�nt�");


goruntu2 = bwareaopen(goruntu2, 200);
figure, imshow(goruntu2), title("��kar�lm�� G�r�nt� 2");

[etiketler, Nesneler] = bwlabel(goruntu2);
nesneOzellikler = regionprops(etiketler, 'BoundingBox');

hold on 

pause(1);


for n=1: size(nesneOzellikler, 1)

rectangle('Position', nesneOzellikler(n).BoundingBox, 'EdgeColor', 'g', 'LineWidth', 2);

end
hold off

%T�m plaka de�erlerini finalCikis de�i�keninde sakl�yoruz
finalCikis = [];
% Her nesnenin max korelasyon de�erini tutar
t = [];
% Karakter say�s�n� bulduk
karakterSayisi = size(goruntuler, 2);

for n=1: Nesneler
% %   Etiketlenmi� g�r�nt�de karakter ara
[r, c] = find(etiketler == n);
karakter = goruntuTersi(min(r): max(r), min(c): max(c));
karakter = imresize(karakter, [42, 24]);
figure, imshow(karakter), title('Karakter');

pause(0.2);
x = [];


% elde etti�imiz nesnenin  veritaban�ndaki t�m karakterlerle k�yaslamas�n�
% yap�yoruz
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




