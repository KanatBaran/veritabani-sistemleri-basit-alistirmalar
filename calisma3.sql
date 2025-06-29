USE ARAC_SATIS

-- Her araç sahibinin sahip olduðu araçlar arasýnda en pahalý ve en ucuz araç 
--	fiyatlarýný gösteren bir sorgu yazýn.
SELECT sahip.isim AS SahipIsim, sahip.soyisim AS SahipSoyisim,
       (SELECT MAX(arac.fiyat) FROM TblAraclar arac WHERE arac.sahip_id = sahip.id) AS EnPahaliArac,
       (SELECT MIN(arac.fiyat) FROM TblAraclar arac WHERE arac.sahip_id = sahip.id) AS EnUcuzArac
FROM TblAracSahibi sahip;


-- Bir araç sahibinin tüm araçlarýnýn toplam piyasa deðerini ve 
--	bu araçlarýn ortalama fiyatýný yazdirin. Ancak sadece piyasa degeri > ortalama fiyat þartý ekleyin.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, 
SUM(arac.fiyat) as PiyasaDegeri, AVG(arac.fiyat) AS OrtalamaFiyat 
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
GROUP BY sahip.isim, sahip.soyisim 
HAVING SUM(arac.fiyat) >AVG(arac.fiyat);



--	Her markaya ait araçlarýn arasýnda ortalama fiyatýn üzerinde 
--	olan araçlarý listeleyen bir sorgu yazýn.
SELECT marka.isim AS Marka, arac.fiyat AS Fiyat 
FROM TblAraclar arac
INNER JOIN TblMarka marka ON marka.id = arac.marka_id
WHERE arac.fiyat >(SELECT AVG(TblAraclar.fiyat) FROM TblAraclar WHERE TblAraclar.marka_id = marka.id);


SELECT marka.isim AS Marka, model.model AS Model, arac.fiyat
FROM TblAraclar arac
INNER JOIN TblMarka marka ON arac.marka_id = marka.id
INNER JOIN TblModel model ON arac.model_id = model.id
WHERE arac.fiyat > (SELECT AVG(arac2.fiyat) 
                    FROM TblAraclar arac2 
                    WHERE arac2.marka_id = arac.marka_id);


-- Sahiplerin sahip olduðu araçlarýn model yýlý ortalamasý 2018’den
--  büyük olan sahiplerin isimlerini ve araçlarýnýn sayýsýný listeleyin.

SELECT sahip.isim AS Isim, COUNT(arac.sahip_id)
FROM TblAraclar arac
INNER JOIN TblModel model ON model.id = arac.model_id
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
WHERE 2018 > (SELECT AVG(TblAraclar.yýl) FROM TblAraclar WHERE TblAraclar.sahip_id = sahip.id)
GROUP BY sahip.isim; 

SELECT sahip.isim AS SahipIsim, sahip.soyisim AS SahipSoyisim, COUNT(arac.sahip_id) AS AracSayisi
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON arac.sahip_id = sahip.id
GROUP BY sahip.isim, sahip.soyisim
HAVING AVG(arac.yýl) > 2018;













