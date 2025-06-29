USE ARAC_SATIS

-- Her ara� sahibinin sahip oldu�u ara�lar aras�nda en pahal� ve en ucuz ara� 
--	fiyatlar�n� g�steren bir sorgu yaz�n.
SELECT sahip.isim AS SahipIsim, sahip.soyisim AS SahipSoyisim,
       (SELECT MAX(arac.fiyat) FROM TblAraclar arac WHERE arac.sahip_id = sahip.id) AS EnPahaliArac,
       (SELECT MIN(arac.fiyat) FROM TblAraclar arac WHERE arac.sahip_id = sahip.id) AS EnUcuzArac
FROM TblAracSahibi sahip;


-- Bir ara� sahibinin t�m ara�lar�n�n toplam piyasa de�erini ve 
--	bu ara�lar�n ortalama fiyat�n� yazdirin. Ancak sadece piyasa degeri > ortalama fiyat �art� ekleyin.
SELECT sahip.isim AS Isim, sahip.soyisim AS Soyisim, 
SUM(arac.fiyat) as PiyasaDegeri, AVG(arac.fiyat) AS OrtalamaFiyat 
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
GROUP BY sahip.isim, sahip.soyisim 
HAVING SUM(arac.fiyat) >AVG(arac.fiyat);



--	Her markaya ait ara�lar�n aras�nda ortalama fiyat�n �zerinde 
--	olan ara�lar� listeleyen bir sorgu yaz�n.
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


-- Sahiplerin sahip oldu�u ara�lar�n model y�l� ortalamas� 2018�den
--  b�y�k olan sahiplerin isimlerini ve ara�lar�n�n say�s�n� listeleyin.

SELECT sahip.isim AS Isim, COUNT(arac.sahip_id)
FROM TblAraclar arac
INNER JOIN TblModel model ON model.id = arac.model_id
INNER JOIN TblAracSahibi sahip ON sahip.id = arac.sahip_id
WHERE 2018 > (SELECT AVG(TblAraclar.y�l) FROM TblAraclar WHERE TblAraclar.sahip_id = sahip.id)
GROUP BY sahip.isim; 

SELECT sahip.isim AS SahipIsim, sahip.soyisim AS SahipSoyisim, COUNT(arac.sahip_id) AS AracSayisi
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON arac.sahip_id = sahip.id
GROUP BY sahip.isim, sahip.soyisim
HAVING AVG(arac.y�l) > 2018;













