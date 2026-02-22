# MEMORY.md - Uzun Vadeli Hafıza

Bu dosya, Hikmet Gülsesli (SeTRoX) ile olan tüm çalışmalarımızın kalıcı hafızasıdır.

---

## 0. DAVRANIŞ KURALLARI
- Selamlama her zaman kibar olmalı: "Merhaba!", "Selam!", "İyi günler!" gibi
- "Ordamısın" gibi kaba sözler KULLANILMAZ
- Her konuşmaya saygıyla başla

---

## 1. KİMLİK (Identity)

### Ben (AI Asistan)
- İsim: Belirlenmedi (henüz isim vermedi)
- Sistem: OpenClaw
- Versiyon: Güncel

### Kullanıcı (Hikmet Gülsesli)
- Takma ad: SeTRoX
- Konum: Samsun, Türkiye
- Zaman dilimi: Europe/Istanbul
- Email: setrox@agentmail.to

---

## 2. PREFERANSLAR (Preferences)

### Çalışma Tercihleri
- Antfarm/MC ile proje geliştirme tercih ediyor
- Ben (AI) doğrudan kod yazmamalıyım, Antfarm üzerinden ilerlemeli
- Proje durumunu MC'den takip ediyor

### Teknik Tercihler
- Next.js 14 + React + TypeScript + Tailwind CSS
- shadcn/ui bileşenleri
- PostgreSQL (harici)
- Port yapısı: 35xx (frontend), 45xx (backend)

### İletişim
- Telegram öncelikli
- WhatsApp bağlantısı var (zaman zaman kopuyor)
- Discord aktif

---

## 3. KARARLAR (Decisions)

| Tarih | Karar | Detay |
|-------|-------|-------|
| 2026-02-15 | Antfarm workflow kullanımı | Yeni projeler için Antfarm feature-dev workflow kullanılacak |
| 2026-02-18 | DB şifre kuralları | 16+ karakter, büyük/küçük harf + rakam + özel karakter |
| 2026-02-18 | Pipeline Doctor | 5dk'da çalışan koruma sistemi |
| 2026-02-19 | Video arşivi | `/data/video-archive/` altında kategori bazlı saklama |
| 2026-02-19 | Long-term memory | 5 bölümlük hafıza sistemi entegre edildi |

---

## 4. PROJELER (Projects)

### Aktif Projeler
| Proje | Repo | Port | Durum |
|-------|------|------|-------|
| Hızlı Okuma | /home/setrox/hizliokuma | 3517/4517 | Antfarm #20 çalışıyor |
| Recipe Book | /home/setrox/recipe-book | 3516/4516 | Tamamlandı |
| AgentViz | /home/setrox/agentviz | 3503 | Tamamlandı |

### Tamamlananlar
- Recipe Book (2026-02-18)
- AgentViz (2026-02-18)
- Pipeline Doctor sistemi (2026-02-18)

---

## 5. KİŞİLER (People)

| İsim | Rol | Not |
|------|-----|-----|
| Hikmet Gülsesli | Kullanıcı | Sahip, yazılımcı |
| - | SET takımı | Linear API bağlı |

---

## KURALLAR (Rules)

✅ Her girdiye tarih ekle (YYYY-MM-DD)  
✅ Her bilgiyi tek satırda tut (atomic)  
✅ Hassas veri (şifre, API key, kişisel bilgi) Saklama  
✅ Karar verirken USER.md ve SOUL.md'yi oku  
✅ Günlük notları memory/YYYY-MM-DD.md'ye yaz  

❌ Şifreleri asla hafızada tutma (sadece referans)  
❌ Kimlik bilgileri saklama  

---

## ÖZ DENETİM (Self-Review)

Haftada bir yapılacak:
- [ ] memory/ dosyasındaki tekrarları temizle
- [ ] Çelişkili bilgileri çöz
- [ ] Eski projeleri arşivle
- [ ] MEMORY.md'yi güncelle

---

## ESKİ NOTLAR (Arşiv)

### PostgreSQL Bağlantıları
- Host: 72.61.186.46:37550
- Admin: postgres / lckdvtbwghdzhxxh

### Pipeline Koruma Sistemleri
- MISSING_INPUT_GUARD
- Medic v4
- Pipeline Doctor
- Fix Verify
