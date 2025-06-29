# Veri Tabanı Sistemleri Dersi – Örnek Alıştırmalar

Bu depo, “Veri Tabanı Sistemleri” dersi kapsamında hazırlanmış **3 adet SQL çalışma dosyası** ve Microsoft SQL Server aracılığıyla geri yüklenen **`ARAC_SATIS.bak`** yedek veritabanını içerir.


## 📚 Proje Açıklaması
- **`ARAC_SATIS.bak`**: Ders kapsamında hazırlanan “Araç Satış Yönetim Sistemi” veritabanının yedeği.  
- **`calisma1.sql`**, **`calisma2.sql`**, **`calisma3.sql`**: Sınavda çözdüğüm tabloları oluşturma, test verisi ekleme ve sorgu alıştırmalarını içeren dosyalar.



## ⚙️ Gereksinimler
- Microsoft SQL Server 2016 veya üzeri  
- SQL Server Management Studio (SSMS) veya eşdeğer bir araç  
- (İsteğe bağlı) `sqlcmd` komut satırı aracı  


## Veritabanını Geri Yükleme (`.bak`)
**SQL Server Management Studio (SSMS) ile**  
1. SSMS’i açın ve sunucunuza bağlanın.  
2. **Databases** üzerine sağ tıklayın → **Restore Database…**  
3. Kaynak olarak **Device** seçin, üç nokta (…) tuşuna basın.  
4. **Add** → `backup/ARAC_SATIS.bak` dosyasını gösterin → **OK**.  
5. Hedef Database adını (ör. `ARAC_SATIS`) doğrulayın.  
6. **Options** sekmesinde dosya yollarını kontrol edin (MDF/LDF yolunu gerektiği gibi ayarlayın).  
7. **OK** ile işlemi başlatın.  

  
