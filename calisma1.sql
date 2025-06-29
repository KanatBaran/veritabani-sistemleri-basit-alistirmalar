USE ARAC_SATIS

SELECT * FROM TblAraclar;
SELECT * FROM TblAracSahibi;
SELECT * FROM Tbl�l;
SELECT * FROM TblMarka;
SELECT * FROM TblModel;
SELECT * FROM TblVites;
-- model'de marka id = marka id yap

SELECT model.model, marka.isim, sahip.isim, sahip.soyisim, sahip.ceptel, 
vites.tur, arac.km, arac.fiyat 
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON arac.sahip_id = sahip.id
INNER JOIN TblMarka marka ON marka.id = arac.marka_id
INNER JOIN TblModel model ON model.id = arac.model_id
INNER JOIN TblVites vites ON vites.id = arac.vites_id;


--Her Ara� Sahibinin ka� arac� oldu�unu getiren sorguyu yaz�n�z.
SELECT sahip.isim, sahip.soyisim, sahip.id, COUNT(sahip.id) AS AracSayisi
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON arac.sahip_id = sahip.id
INNER JOIN TblMarka marka ON marka.id = arac.marka_id
INNER JOIN TblModel model ON model.id = arac.model_id
INNER JOIN TblVites vites ON vites.id = arac.vites_id GROUP BY sahip.isim, sahip.soyisim, sahip.id; 


--Markalara g�re ara�lar�n ortalama fiyatlar�n� pahal�dan ucuza do�ru getiren sorguyu yaz�n�z. 
SELECT marka.isim, AVG(arac.fiyat) AS ortalamaFiyat FROM TblMarka marka
INNER JOIN TblAraclar arac ON marka.id = arac.marka_id 
GROUP BY marka.isim ORDER BY AVG(arac.fiyat) desc;

select  marka.isim as Marka, avg(a.fiyat) as ortalama_fiyat
from TblMarka marka
inner join TblAraclar a on marka.id = a.marka_id
group by marka.isim
order by ortalama_fiyat desc


-- 100000 km alt�ndaki d�z vites ara�lar�n marka, model, km, 
--	y�l ve fiyat bilgilerini getiren sorguyu yaz�n�z.
SELECT model.model, marka.isim, sahip.isim, sahip.soyisim, sahip.ceptel, 
vites.tur, arac.km, arac.fiyat 
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON arac.sahip_id = sahip.id
INNER JOIN TblMarka marka ON marka.id = arac.marka_id
INNER JOIN TblModel model ON model.id = arac.model_id
INNER JOIN TblVites vites ON vites.id = arac.vites_id WHERE arac.km < 100000 
AND vites.tur = 'D�z';

select marka.isim, model.model, a.km, a.y�l, a.fiyat
from TblMarka marka, TblModel model, TblAraclar a
where a.km<100000 and
a.vites_id = 1 and
marka.id = a.marka_id and
model.id = a.model_id


-- Markalara g�re A'dan Z'ye ve fiyata g�re pahal�dan 
--	ucuza do�ru ara�lar� listeleyen sorguyu yaz�n�z. 
SELECT marka.isim, arac.fiyat AS Fiyat FROM TblAraclar arac 
INNER JOIN TblMarka marka ON arac.marka_id = marka.id GROUP BY marka.isim, arac.fiyat 
ORDER BY marka.isim , arac.fiyat desc;

select marka.isim, a.fiyat
from TblMarka marka, TblAraclar a
where marka.id = a.marka_id
order by marka.isim , (a.fiyat) desc

-- D�z vites ve otomatik ara�lar�n ortalama fiyatlar�n� getiren sorguyu yaz�n�z.
SELECT vites.tur AS T�r, AVG(arac.fiyat) AS OrtalamaFiyat FROM 
TblVites vites INNER JOIN TblAraclar arac ON vites.id = arac.vites_id
WHERE vites.tur = 'D�z' OR vites.tur = 'Otomatik' GROUP BY vites.tur;


-- Ara� sahiplerinin ad, soyad ve cep telefonu ile 
--	birlikte sahip olduklar� ara�lar�n piyasa de�erine g�re 
--	�oktan aza do�ru listeleyen kodu yaz�n�z.
SELECT sahip.isim, sahip.soyisim, sahip.ceptel , SUM(arac.fiyat) AS PiyasaDegeri
FROM TblAraclar arac
INNER JOIN TblAracSahibi sahip ON arac.sahip_id = sahip.id
INNER JOIN TblMarka marka ON marka.id = arac.marka_id
INNER JOIN TblModel model ON model.id = arac.model_id
INNER JOIN TblVites vites ON vites.id = arac.vites_id GROUP BY sahip.isim, sahip.soyisim, sahip.ceptel
ORDER BY sum(arac.fiyat) DESC; 








