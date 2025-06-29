USE ARAC_SATIS

-- En ucuzdan en pahalýya araçlarýn marka, model, km ve fiyat bilgilerini getirin.
SELECT marka.isim AS MarkaIsim, model.model AS ModelIsim, arac.km AS KM, arac.fiyat AS Fiyat FROM TblAraclar arac 
INNER JOIN TblMarka marka ON arac.marka_id = marka.id
INNER JOIN TblModel model ON model.id = arac.model_id GROUP BY marka.isim, model.model, KM, Fiyat 
ORDER BY Fiyat ASC;

-- Her markadan kaç tane araç olduðunu gösteren bir sorgu yazýn.
SELECT marka.isim, COUNT(marka.id) AS AracSayisi FROM TblAraclar arac 
INNER JOIN TblMarka marka ON marka.id = arac.marka_id GROUP BY marka.isim;

-- Otomatik vitesli araçlarýn en yüksek fiyatlýsýný getirin.
SELECT vites.tur, MAX(arac.fiyat) AS MaxFiyat FROM TblAraclar arac 
INNER JOIN TblVites vites ON vites.id = arac.vites_id WHERE vites.tur = 'Otomatik' GROUP BY vites.tur;

--Araçlarýn marka, model, km ve sahiplerinin ad ve soyad bilgilerini listeleyin.
SELECT marka.isim AS Marka, model.model AS Model, arac.km AS KM, sahip.isim AS Isim, sahip.soyisim AS Soyisim 
FROM TblAraclar arac
INNER JOIN TblMarka marka ON marka.id = arac.marka_id
INNER JOIN TblModel model ON model.id = arac.model_id
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id;

--Her bir araç sahibinin sahip olduðu araçlarýn toplam piyasa deðerini hesaplayarak, 
--	bu deðere göre azalan sýrayla listeleyin.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, SUM(arac.fiyat) AS PiyasaDegeri 
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id GROUP BY sahip.isim, sahip.soyisim 
ORDER BY sum(arac.fiyat) DESC;


--Ýlk olarak sahip sayýsýna göre, ardýndan fiyat ortalamasýna göre en popüler markalarý listeleyin.
SELECT marka.isim AS Marka, COUNT(arac.marka_id) AS AracSayisi, AVG(arac.fiyat) AS Fiyat 
FROM TblAraclar arac
INNER JOIN TblMarka marka ON marka.id = arac.marka_id 
GROUP BY marka.isim ORDER BY AracSayisi DESC, Fiyat DESC ;


--Model yýlý 2015'ten sonraki araçlarý sahipleriyle birlikte, aracýn km bilgisiyle birlikte listeleyin.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, arac.km AS KM, arac.yýl AS Yil 
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
WHERE arac.yýl > 2015;

-- Otomatik vitesli araçlarýn ortalama fiyatýný ve sahiplerinin iletiþim
--	bilgilerini listeleyen bir sorgu yazýn.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, sahip.ceptel AS Tel, AVG(arac.fiyat) 
FROM TblAraclar arac 
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
INNER JOIN TblVites vites ON vites.id = arac.vites_id 
WHERE vites.tur = 'Otomatik' GROUP BY Isim, Soyisim, sahip.ceptel;


-- Her araç sahibinin sahip olduðu araç modellerini ve bu araçlarýn 
--	ortalama km'sini getiren bir sorgu yazýn.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, model.model AS Model, AVG(arac.km) AS OrtalamaKM
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
INNER JOIN TblModel model ON model.id = arac.model_id 
GROUP BY sahip.isim, sahip.soyisim, model.model;


-- Bir markaya ait araçlarýn ortalama fiyatýný ve bu markaya ait 
--	toplam araç sayýsýný gösteren bir sorgu yazýn.
SELECT marka.isim AS Marka, AVG(arac.fiyat) AS OrlamaFiyat, COUNT(arac.marka_id) AS AracSayisi
FROM TblAraclar arac
INNER JOIN TblMarka marka ON marka.id = arac.marka_id
GROUP BY marka.isim ORDER BY avg(arac.fiyat) DESC;


-- Farklý marka ve modelde en az 2 araç sahibi olan kiþilerin isimlerini listeleyin.
SELECT sahip.isim AS Ad, sahip.soyisim AS Soyad, COUNT(DISTINCT arac.model_id) AS ModelSayisi,
COUNT(DISTINCT arac.marka_id) AS MarkaSayisi
FROM TblAraclar arac
INNER JOIN TblMarka marka ON marka.id = arac.marka_id -- bu satir gereksiz
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
INNER JOIN TblModel model ON model.id = arac.model_id -- bu satir gereksiz
GROUP BY sahip.isim, sahip.soyisim
HAVING COUNT(DISTINCT arac.model_id) >1 AND COUNT(DISTINCT arac.marka_id) > 1;


-- Sadece manuel vitesli ve 100.000 km’nin altýnda olan araçlarý listeleyin ve
--	 bu araçlarýn sahiplerinin cep telefon numarasýný da ekleyin.
SELECT sahip.ceptel AS SahipTel, vites.tur AS Tur, arac.km AS KM
FROM TblAraclar arac 
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
INNER JOIN TblVites vites ON vites.id = arac.vites_id 
WHERE arac.km < 100000 AND vites.tur = 'Düz';


-- Her bir aracýn yýllýk ortalama kullanýmýný hesaplayarak km 
--	bilgisine göre en çok kullanýlan araçlarý sýralayýn.
SELECT marka.isim AS Marka, model.model AS Model, arac.km / (YEAR(GETDATE()) - arac.yýl) AS YillikOrtalamaKM
FROM TblAraclar arac
INNER JOIN TblMarka marka ON arac.marka_id = marka.id
INNER JOIN TblModel model ON arac.model_id = model.id
ORDER BY YillikOrtalamaKM DESC;













select * from TblVites;
SELECT * FROM TblAraclar;
SELECT * FROM TblAracSahibi;





