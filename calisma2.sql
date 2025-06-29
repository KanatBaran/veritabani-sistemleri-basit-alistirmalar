USE ARAC_SATIS

-- En ucuzdan en pahal�ya ara�lar�n marka, model, km ve fiyat bilgilerini getirin.
SELECT marka.isim AS MarkaIsim, model.model AS ModelIsim, arac.km AS KM, arac.fiyat AS Fiyat FROM TblAraclar arac 
INNER JOIN TblMarka marka ON arac.marka_id = marka.id
INNER JOIN TblModel model ON model.id = arac.model_id GROUP BY marka.isim, model.model, KM, Fiyat 
ORDER BY Fiyat ASC;

-- Her markadan ka� tane ara� oldu�unu g�steren bir sorgu yaz�n.
SELECT marka.isim, COUNT(marka.id) AS AracSayisi FROM TblAraclar arac 
INNER JOIN TblMarka marka ON marka.id = arac.marka_id GROUP BY marka.isim;

-- Otomatik vitesli ara�lar�n en y�ksek fiyatl�s�n� getirin.
SELECT vites.tur, MAX(arac.fiyat) AS MaxFiyat FROM TblAraclar arac 
INNER JOIN TblVites vites ON vites.id = arac.vites_id WHERE vites.tur = 'Otomatik' GROUP BY vites.tur;

--Ara�lar�n marka, model, km ve sahiplerinin ad ve soyad bilgilerini listeleyin.
SELECT marka.isim AS Marka, model.model AS Model, arac.km AS KM, sahip.isim AS Isim, sahip.soyisim AS Soyisim 
FROM TblAraclar arac
INNER JOIN TblMarka marka ON marka.id = arac.marka_id
INNER JOIN TblModel model ON model.id = arac.model_id
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id;

--Her bir ara� sahibinin sahip oldu�u ara�lar�n toplam piyasa de�erini hesaplayarak, 
--	bu de�ere g�re azalan s�rayla listeleyin.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, SUM(arac.fiyat) AS PiyasaDegeri 
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id GROUP BY sahip.isim, sahip.soyisim 
ORDER BY sum(arac.fiyat) DESC;


--�lk olarak sahip say�s�na g�re, ard�ndan fiyat ortalamas�na g�re en pop�ler markalar� listeleyin.
SELECT marka.isim AS Marka, COUNT(arac.marka_id) AS AracSayisi, AVG(arac.fiyat) AS Fiyat 
FROM TblAraclar arac
INNER JOIN TblMarka marka ON marka.id = arac.marka_id 
GROUP BY marka.isim ORDER BY AracSayisi DESC, Fiyat DESC ;


--Model y�l� 2015'ten sonraki ara�lar� sahipleriyle birlikte, arac�n km bilgisiyle birlikte listeleyin.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, arac.km AS KM, arac.y�l AS Yil 
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
WHERE arac.y�l > 2015;

-- Otomatik vitesli ara�lar�n ortalama fiyat�n� ve sahiplerinin ileti�im
--	bilgilerini listeleyen bir sorgu yaz�n.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, sahip.ceptel AS Tel, AVG(arac.fiyat) 
FROM TblAraclar arac 
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
INNER JOIN TblVites vites ON vites.id = arac.vites_id 
WHERE vites.tur = 'Otomatik' GROUP BY Isim, Soyisim, sahip.ceptel;


-- Her ara� sahibinin sahip oldu�u ara� modellerini ve bu ara�lar�n 
--	ortalama km'sini getiren bir sorgu yaz�n.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, model.model AS Model, AVG(arac.km) AS OrtalamaKM
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
INNER JOIN TblModel model ON model.id = arac.model_id 
GROUP BY sahip.isim, sahip.soyisim, model.model;


-- Bir markaya ait ara�lar�n ortalama fiyat�n� ve bu markaya ait 
--	toplam ara� say�s�n� g�steren bir sorgu yaz�n.
SELECT marka.isim AS Marka, AVG(arac.fiyat) AS OrlamaFiyat, COUNT(arac.marka_id) AS AracSayisi
FROM TblAraclar arac
INNER JOIN TblMarka marka ON marka.id = arac.marka_id
GROUP BY marka.isim ORDER BY avg(arac.fiyat) DESC;


-- Farkl� marka ve modelde en az 2 ara� sahibi olan ki�ilerin isimlerini listeleyin.
SELECT sahip.isim AS Ad, sahip.soyisim AS Soyad, COUNT(DISTINCT arac.model_id) AS ModelSayisi,
COUNT(DISTINCT arac.marka_id) AS MarkaSayisi
FROM TblAraclar arac
INNER JOIN TblMarka marka ON marka.id = arac.marka_id -- bu satir gereksiz
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
INNER JOIN TblModel model ON model.id = arac.model_id -- bu satir gereksiz
GROUP BY sahip.isim, sahip.soyisim
HAVING COUNT(DISTINCT arac.model_id) >1 AND COUNT(DISTINCT arac.marka_id) > 1;


-- Sadece manuel vitesli ve 100.000 km�nin alt�nda olan ara�lar� listeleyin ve
--	 bu ara�lar�n sahiplerinin cep telefon numaras�n� da ekleyin.
SELECT sahip.ceptel AS SahipTel, vites.tur AS Tur, arac.km AS KM
FROM TblAraclar arac 
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
INNER JOIN TblVites vites ON vites.id = arac.vites_id 
WHERE arac.km < 100000 AND vites.tur = 'D�z';


-- Her bir arac�n y�ll�k ortalama kullan�m�n� hesaplayarak km 
--	bilgisine g�re en �ok kullan�lan ara�lar� s�ralay�n.
SELECT marka.isim AS Marka, model.model AS Model, arac.km / (YEAR(GETDATE()) - arac.y�l) AS YillikOrtalamaKM
FROM TblAraclar arac
INNER JOIN TblMarka marka ON arac.marka_id = marka.id
INNER JOIN TblModel model ON arac.model_id = model.id
ORDER BY YillikOrtalamaKM DESC;













select * from TblVites;
SELECT * FROM TblAraclar;
SELECT * FROM TblAracSahibi;





