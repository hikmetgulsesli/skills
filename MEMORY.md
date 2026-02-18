# MEMORY.md - Uzun Vadeli Hafıza

## Pipeline Koruma Sistemleri (18 Şubat 2026)

**Deploy Edilen Koruma Katmanları:**
1. **MISSING_INPUT_GUARD** (Patch 11) — claimStep() aşamasında [missing: X] bloklar
2. **Medic v4** (Mission Control) — 5dk'da bir: loop + missing + diagnose + auto-fix + unstick + limbo
3. **Pipeline Doctor** — 5dk'da bir: MC down olsa bile SQLite kontrolü yapar
4. **Fix Verify** — antfarm-update sonrası 14 fix'i kontrol eder, Discord'a raporlar

**Yeni Fonksiyonlar (antfarm-db.ts):**
- detectInfiniteLoop(runId) — claim count >= 5 olan step'leri bulur
- checkMissingInput(runId) — [missing: X] pattern'ini tespit eder
- failEntireRun(runId, reason) — tüm step'leri fail eder + WAL checkpoint + Discord alert

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
