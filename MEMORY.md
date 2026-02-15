# MEMORY.md - Uzun Vadeli Hafıza

## Haftalık Öz - 15 Şubat 2026

### Bu Haftanın Dersleri

**Sistem Stabilitesi:**
- Gateway ve Antfarm sorunsuz çalışıyor
- RAM ve disk kullanımı düşük seviyede

**Tekrarlayan Sorunlar:**
- 3 cron job timeout oluyor (session-cleanup, gunaydin, disk-kontrol)
- Timeout süreleri yetersiz kalıyor

**Çözümler:**
- Timeout sürelerini artırmak gerekiyor
- Kısa süreli job'lar için model seçimi önemli

### Model Kullanımı

- MiniMax-M2.5 varsayılan model olarak kullanılıyor
- Kimi-coding/k2p5 raporlama job'ları için kullanılıyor
- Maliyet hedefi: ~$5-15/hafta

### Önümüzdeki Hafta

- Timeout ayarlarını düzelt
- Health check sıklığını optimize et
- Session cleanup script'ini gözden geçir
