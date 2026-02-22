# AutoPress PRD - Eksiklik ve Bug Raporu

**Proje:** AutoPress - Otonom AI Yayincilik Platformu
**Tarih:** 2026-02-20
**Haziran:** Claude Code (Opus 4.6) - Tam site taramasi + kaynak kod analizi
**Repo:** /home/setrox/autopress (monorepo: client/ + server/)
**Stack:** React + Vite + TypeScript + Express + PostgreSQL + TailwindCSS
**Domain:** autopress.setrox.com.tr (port 4519)

---

## Ozet

Site taramasi ve kaynak kod analizi sonucunda **78 sorun** tespit edildi:
- **P0 (Kritik):** 8 sorun - Uygulama calismiyor veya guvenlik acigi
- **P1 (Yuksek):** 14 sorun - Temel ozellikler eksik veya bozuk
- **P2 (Orta):** 22 sorun - UX/bug/mimari sorunlar
- **P3 (Dusuk):** 12 sorun - Iyilestirme ve polish

Toplam tahmini is: **6 story** (her biri 1-3 gun arasi)

---

## STORY 1: Icerik Studyosu Tamamlama (P0)

**Oncelik:** KRITIK - Makaleler kaydedilemiyor, duzenlenemiyor
**Dosyalar:** `client/src/pages/ContentStudio.tsx`, `server/src/routes/articles.ts`, `server/src/services/content.service.ts`, `server/src/index.ts`

### 1.1 handleSave TODO stub (P0)
- **Dosya:** `client/src/pages/ContentStudio.tsx` ~satir 15
- **Sorun:** Save butonu sadece `console.log` yapiyor. Makale kaydedilemiyor.
- **Cozum:** `POST /api/articles` ve `PUT /api/articles/:id` API cagrilari ekle. Basarili kayit sonrasi toast bildirimi goster.

### 1.2 Makale yukleme/duzenleme yok (P0)
- **Dosya:** `client/src/pages/ContentStudio.tsx`
- **Sorun:** Dashboard'dan makale tiklandiginda `/content?article=ID` URL'ine gidiyor ama ContentStudio `article` query param'ini okumuyor. Mevcut makaleler duzenlenemiyor.
- **Cozum:** `useSearchParams` ile article ID oku, `GET /api/articles/:id` ile yukle, TipTap editor'e set et.

### 1.3 Makale listesi/yonetim gorunumu yok (P1)
- **Dosya:** `client/src/pages/ContentStudio.tsx`
- **Sorun:** Sadece editor var. Mevcut makaleleri listeleyecek, filtreleyecek gorunum yok.
- **Cozum:** Sol panel veya tab ile makale listesi ekle (baslik, durum, tarih, SEO skoru). Listeden tikla -> editor'e yukle.

### 1.4 AI Asistan butonlari calismiyor (P1)
- **Dosya:** `client/src/pages/ContentStudio.tsx` ~satir 92-98
- **Sorun:** "Baslik Oner" ve "SEO Analizi" butonlari onClick handler'i yok. Dekoratif.
- **Cozum:** Content service endpoint'i olustur (`POST /api/content/generate-title`, `POST /api/content/analyze-seo`). AI asistan panelini aktif et.

### 1.5 AI icerik uretimi route'u yok (P0)
- **Dosya:** `server/src/services/content.service.ts`, `server/src/index.ts`
- **Sorun:** `content.service.ts` tam calisan `generateArticle()` fonksiyonu var (OpenAI GPT-4o) ama hicbir route bu servisi kullanmiyor. `index.ts`'de content route register edilmemis.
- **Cozum:** `server/src/routes/content.ts` dosyasi olustur. Endpoint'ler: `POST /api/content/generate` (makale uret), `POST /api/content/suggest-title` (baslik oner), `POST /api/content/analyze-seo` (SEO analiz). `index.ts`'e register et.

### 1.6 SEO metadata alanlari yok (P2)
- **Dosya:** `client/src/pages/ContentStudio.tsx`
- **Sorun:** Article type'da `meta_title`, `meta_description`, `seo_score` var ama editor'de bunlar icin input yok.
- **Cozum:** Editor saginda "SEO" tab'i ekle: meta title, meta description, slug, kelime sayisi, okunma suresi.

### 1.7 Site/dil secimi yok (P2)
- **Dosya:** `client/src/pages/ContentStudio.tsx`
- **Sorun:** Makaleler `site_id` ve `language` gerektiriyor ama form'da secenek yok.
- **Cozum:** Baslik uzerinde site dropdown + dil dropdown ekle.

### 1.8 TipTap duplicate link extension (P2)
- **Dosya:** `client/src/components/TipTapEditor.tsx`
- **Sorun:** Konsolda `[tiptap warn]: Duplicate extension names found: ['link']` uyarisi. Link extension 2 kere yukleniyor.
- **Cozum:** StarterKit'ten `link: false` ile devre disi birak, ayri Link extension kullan.

### 1.9 TipTap content prop sync yok (P2)
- **Dosya:** `client/src/components/TipTapEditor.tsx` ~satir 19
- **Sorun:** Editor `content` prop'u sadece ilk render'da kullaniyor. Parent degisince editor guncellenmiyor.
- **Cozum:** `useEffect` ile `editor.commands.setContent()` cagir.

---

## STORY 2: Ayarlar + Trend Explorer Sayfalari (P0)

**Oncelik:** KRITIK - 2 sayfa tamamen placeholder
**Dosyalar:** `client/src/pages/Settings.tsx`, `client/src/pages/TrendExplorer.tsx`, `server/src/routes/settings.ts`, `server/src/routes/trends.ts`

### 2.1 Settings sayfasi tamamen stub (P0)
- **Dosya:** `client/src/pages/Settings.tsx`
- **Sorun:** Sadece "Ayarlar - Yakinda" yaziyor. Hicbir ayar yapilabilir degil.
- **Cozum:** Tab'li ayarlar sayfasi:
  - **Genel:** Varsayilan dil, AI model secimi, yayin jitter suresi, SEO minimum kelime sayisi
  - **API Anahtarlari:** OpenAI API key, Unsplash API key, Google Trends API, Search Console credentials
  - **Profil:** Ad, email, sifre degistir
  - **Bildirimler:** Email/push bildirim tercihleri
  - Backend: `GET /api/settings` ve `PUT /api/settings` zaten var, frontend entegrasyonu lazim.

### 2.2 TrendExplorer sayfasi tamamen stub (P0)
- **Dosya:** `client/src/pages/TrendExplorer.tsx`
- **Sorun:** "Faz 4'te aktif olacak" yaziyor. Backend'de trend service tamamen calisiyor ama frontend bos.
- **Cozum:** Trend sayfasi ozellikleri:
  - Ulke/bolge bazli Google Trends listesi
  - Trend skoru ve haber sayisi
  - "Makale Olustur" butonu (trend -> content studio'ya yonlendir)
  - Trend arama
  - Trend gecmisi grafigi
  - Backend endpoint'leri zaten var: `GET /api/trends`, `GET /api/trends/search`, `GET /api/trends/daily`

---

## STORY 3: Yayin Sistemi Duzeltme (P0)

**Oncelik:** KRITIK - "Simdi Yayinla" sahte, Blogger entegrasyonu yok
**Dosyalar:** `server/src/routes/publish.ts`, `server/src/routes/scheduler.ts`, `server/src/services/blogger.service.ts`, `server/src/services/wordpress.service.ts`, `client/src/pages/Publisher.tsx`

### 3.1 "Publish Now" tamamen sahte (P0)
- **Dosya:** `server/src/routes/publish.ts` ~satir 114-142
- **Sorun:** `POST /api/publish/publish-now` gercek yayin yapmiyor. URL'i `https://example.com/${slug}` olarak hardcode'luyor. Scheduler'daki gercek WordPress entegrasyonunu kullanmiyor.
- **Cozum:** Gercek yayin akisi: site bilgilerini al -> platformuna gore WordPress/Blogger service cagir -> gercek URL'i kaydet. `scheduler.service.ts`'deki `publishArticle()` mantigini paylas.

### 3.2 Blogger route'lari yok (P1)
- **Dosya:** `server/src/services/blogger.service.ts`
- **Sorun:** Blogger service tamamen hazir (OAuth, blog listele, post CRUD) ama hicbir route yok. Publisher'da platform "Blogger" secilse bile aslinda hicbir sey olmuyor.
- **Cozum:** `server/src/routes/blogger.ts` olustur: `GET /api/blogger/auth-url`, `POST /api/blogger/callback`, `GET /api/blogger/blogs`, `POST /api/blogger/publish`. Scheduler'a Blogger entegrasyonu ekle.

### 3.3 WordPress site bazli degil, env bazli (P1)
- **Dosya:** `server/src/services/wordpress.service.ts`
- **Sorun:** WP credentials sadece `.env`'den geliyor (`WORDPRESS_SITE_URL`, `WORDPRESS_USERNAME`, `WORDPRESS_APP_PASSWORD`). Sites tablosundaki `api_credentials` kullanilmiyor. Tek bir WP sitesine yayin yapilabilir.
- **Cozum:** `publishPost()` fonksiyonunu site_id bazli yap. Sites tablosundan credentials oku. Boylece birden fazla WP/Blogger sitesine yayin yapiabilir.

### 3.4 Duplicate scheduling sistemi (P1)
- **Dosya:** `server/src/routes/publish.ts` vs `server/src/routes/scheduler.ts`
- **Sorun:** Iki ayri zamanlama sistemi var. `publish.ts` sadece `publish_history`'ye yazar (gercek yayin yok), `scheduler.ts` gercek `publish_queue` + cron ile yayin yapar.
- **Cozum:** `publish.ts`'deki zamanlama endpoint'lerini kaldir veya `scheduler.ts`'e yonlendir. Tek bir yayin pipeline'i olsun.

### 3.5 Publisher sayfasi 500 hatasi (P1)
- **Dosya:** `client/src/pages/Publisher.tsx`
- **Sorun:** Konsolda `Failed to fetch publisher data: AxiosError: Request failed with status code 500`. Publisher sayfasi veri yukleyemiyor.
- **Cozum:** Backend'deki 500 hatasini debug et (muhtemelen `publish_history` veya `publish_queue` tablosu eksik ya da schema mismatch). Frontend'de hata durumunda kullaniciya mesaj goster.

### 3.6 "Simdi Yayinla" butonu yok (P2)
- **Dosya:** `client/src/pages/Publisher.tsx`
- **Sorun:** UI'da sadece zamanlama var. Aninda yayinlama butonu yok.
- **Cozum:** Kuyruk gorunumune "Simdi Yayinla" butonu ekle.

---

## STORY 4: Guvenlik Aciklari (P0)

**Oncelik:** KRITIK - Auth bypass, SQL injection, veri izolasyonu yok
**Dosyalar:** `server/src/routes/searchconsole.ts`, `server/src/routes/rss.ts`, `server/src/services/bulkseo.service.ts`, `server/src/middleware/auth.ts`, `server/src/index.ts`

### 4.1 Search Console route'lari auth'suz (P0)
- **Dosya:** `server/src/routes/searchconsole.ts`
- **Sorun:** Tum endpoint'ler public. Herhangi biri URL submit edebilir, Google Indexing API kotasini (200/gun) tuketebilir.
- **Cozum:** `router.use(authenticate)` ekle.

### 4.2 User-scoped data izolasyonu yok (P0)
- **Dosya:** Tum route'lar (articles, sites, settings, seo, publish, scheduler)
- **Sorun:** Authenticate middleware `req.user` cikariyor ama hicbir query `WHERE user_id = $X` kullanmiyor. Her kullanici herkesinkini goruyor/degistirebiliyor.
- **Cozum:** Tum CRUD query'lerine `user_id` filtresi ekle. Multi-tenancy sagla.

### 4.3 SQL injection (P1)
- **Dosya:** `server/src/routes/rss.ts` ~satir 290, `server/src/services/bulkseo.service.ts` ~satir 290
- **Sorun:** `INTERVAL '${hours} hours'` ve `INTERVAL '${days} days'` string interpolation ile SQL'e yaziliyor.
- **Cozum:** Parameterized query kullan: `INTERVAL $1` veya `NOW() - ($1 || ' hours')::interval`.

### 4.4 Rate limiting yok (P1)
- **Dosya:** `server/src/index.ts`
- **Sorun:** Hicbir endpoint'te rate limit yok. Login brute-force, API kota tuketimi mumkun.
- **Cozum:** `express-rate-limit` ekle: Login: 5/dakika, API genel: 100/dakika, Search Console: 200/gun.

### 4.5 JWT_SECRET undefined kontrolu yok (P1)
- **Dosya:** `server/src/middleware/auth.ts`, `server/src/routes/auth.ts`
- **Sorun:** `process.env.JWT_SECRET!` undefined olabilir. Token `"undefined"` secret ile imzalanir.
- **Cozum:** Server startup'ta env validation ekle. JWT_SECRET, JWT_REFRESH_SECRET, DATABASE_URL zorunlu kontrol.

### 4.6 SPA fallback API 404'leri yakaliyor (P1)
- **Dosya:** `server/src/index.ts` ~satir 53-56
- **Sorun:** `app.get('*')` catch-all, hatali GET API isteklerinde JSON yerine index.html donduruyor.
- **Cozum:** Catch-all'i sadece `/api` ile baslamayan path'lere uygula: `app.get(/^(?!\/api).*/, ...)`

### 4.7 Error mesajlari internal detay sizdiriyor (P2)
- **Dosya:** Birden fazla route
- **Sorun:** `res.status(500).json({ error: err.message })` PostgreSQL hata detaylarini client'a gonderiyor.
- **Cozum:** Production'da generic mesaj dondur, detayi sadece loglara yaz.

### 4.8 Refresh token plain text saklanıyor (P2)
- **Dosya:** `server/src/routes/auth.ts` ~satir 23
- **Sorun:** Refresh token DB'de plain text. DB leak'te tum token'lar kullanilabilir.
- **Cozum:** Token'i hash'le (bcrypt) ve karsilastirmada `bcrypt.compare` kullan.

---

## STORY 5: Site Yonetimi + SEO Iyilestirmeleri (P1)

**Oncelik:** YUKSEK - Platform entegrasyonlari eksik
**Dosyalar:** `client/src/pages/SiteManager.tsx`, `client/src/pages/SEOTools.tsx`, `server/src/routes/seo.ts`, `server/src/services/bulkseo.service.ts`

### 5.1 API credentials yonetimi yok (P1)
- **Dosya:** `client/src/pages/SiteManager.tsx`
- **Sorun:** Sites tablosunda `api_credentials` alani var ama form'da credential girisi yok. WordPress/Blogger baglantisi kurulamaz.
- **Cozum:** Site formuna platform bazli credential alanlari ekle: WP (site URL, username, app password), Blogger (client ID, client secret, OAuth flow).

### 5.2 Site baglanti testi yok (P2)
- **Dosya:** `client/src/pages/SiteManager.tsx`
- **Sorun:** "Test Connection" butonu yok. Credential'larin dogru girilip girilmedigi belli degil.
- **Cozum:** `POST /api/sites/:id/test-connection` endpoint'i + UI butonu ekle.

### 5.3 SEO skoru hesaplanmiyor (P1)
- **Dosya:** `server/src/services/bulkseo.service.ts`
- **Sorun:** `analyzeArticleSEO()` skor hesapliyor ama DB'ye yazmiyor. Skor hep 0.
- **Cozum:** Analiz sonrasi `UPDATE articles SET seo_score = $1 WHERE id = $2` ekle.

### 5.4 Broken link ON CONFLICT yanlish kolon (P2)
- **Dosya:** `server/src/services/bulkseo.service.ts` ~satir 222
- **Sorun:** `ON CONFLICT (id)` kullaniliyor, auto-increment ID hicbir zaman conflict olmaz. Her check yeni row olusturuyor.
- **Cozum:** `ON CONFLICT (article_id, url)` olarak degistir. Unique constraint ekle.

### 5.5 Link oneri "apply" icerik degistirmiyor (P2)
- **Dosya:** `server/src/services/bulkseo.service.ts` ~satir 283
- **Sorun:** `applyLinkSuggestion()` sadece `is_applied = true` yapiyor, makale icerigine link eklemiyor.
- **Cozum:** Makale iceriginde onerilenanchor text'i bulup link olarak sarmala.

### 5.6 Site ID text input yerine dropdown (P2)
- **Dosya:** `client/src/pages/SEOTools.tsx` ~satir 52
- **Sorun:** SEO filtrelerinde "Site ID" manual text input. Kullanici ID bilmek zorunda.
- **Cozum:** Sites API'den dropdown populate et.

### 5.7 Search Console quota tracking stub (P2)
- **Dosya:** `server/src/services/searchconsole.service.ts` ~satir 282
- **Sorun:** Kota her zaman 0 kullanilmis / 200 kalan donduruyor. Gercek takip yok.
- **Cozum:** DB'de `indexing_quota` tablosu olustur, her submit'te say.

---

## STORY 6: UX/UI + Genel Iyilestirmeler (P2-P3)

**Oncelik:** ORTA-DUSUK
**Dosyalar:** Birden fazla

### 6.1 Global error boundary yok (P2)
- **Dosya:** `client/src/App.tsx`
- **Sorun:** Herhangi bir component render hatasi tum uygulamayi beyaz ekrana ceviriyor.
- **Cozum:** React ErrorBoundary wrap'i ekle.

### 6.2 Toast/bildirim sistemi yok (P2)
- **Dosya:** Tum client
- **Sorun:** Basari/hata mesajlari `alert()` veya `console.log`. Modern toast yok.
- **Cozum:** `react-hot-toast` veya `sonner` ekle. Tum CRUD islemlerinde toast goster.

### 6.3 404 sayfasi yok (P2)
- **Dosya:** `client/src/App.tsx`
- **Sorun:** Gecersiz route'lar bos icerik gosteriyor.
- **Cozum:** Catch-all route ile "Sayfa Bulunamadi" sayfasi ekle.

### 6.4 Tutarsiz renk sistemi (P2)
- **Dosya:** Login.tsx, Header.tsx, Sidebar.tsx, SiteManager.tsx, SEOTools.tsx, Publisher.tsx, Settings.tsx, TrendExplorer.tsx
- **Sorun:** Bazi sayfalar CSS variable (`bg-surface-alt`, `text-text-muted`), bazilari hardcoded Tailwind (`bg-dark-900`, `text-dark-400`) kullaniyor.
- **Cozum:** Tum sayfalari CSS variable sistemine gecir.

### 6.5 Mobile responsive degil (P2)
- **Dosya:** `client/src/components/layout/Layout.tsx`
- **Sorun:** `ml-64` fixed margin. Mobilde sidebar icerige biniyor, hamburger menu yok.
- **Cozum:** Responsive sidebar: mobilde hidden + hamburger toggle. `ml-64` sadece desktop'ta.

### 6.6 Auth token refresh race condition (P2)
- **Dosya:** `client/src/services/api.ts` ~satir 18
- **Sorun:** Esanli 401 response'larda her biri bagimsiz refresh denemesi yapiyor.
- **Cozum:** Mutex/queue pattern: tek refresh, diger istekler beklesin.

### 6.7 checkAuth hic cagirilmiyor (P2)
- **Dosya:** `client/src/store/authStore.ts`
- **Sorun:** `checkAuth()` metodu var ama hicbir yerde cagirilmiyor. Expired token ile kullanici authenticated gorunuyor.
- **Cozum:** `App.tsx`'te mount'ta `checkAuth()` cagir, loading state ekle.

### 6.8 Migration tracking yok (P2)
- **Dosya:** `server/src/db/migrate.ts`
- **Sorun:** Her calistirmada tum migration'lar tekrar calisiyor. Tracking tablosu yok.
- **Cozum:** `_migrations` tablosu olustur, calmis dosyalari kaydet, sadece yenileri calistir.

### 6.9 Graceful shutdown yok (P3)
- **Dosya:** `server/src/index.ts`
- **Sorun:** SIGTERM/SIGINT handler yok. Process olurken DB baglantilari, cron job'lar temizlenmiyor.
- **Cozum:** Shutdown handler ekle: cron durdur, pool drain, process exit.

### 6.10 Health check DB kontrolu yok (P3)
- **Dosya:** `server/src/index.ts`
- **Sorun:** `/api/health` sadece scheduler durumu donduruyor. DB connectivity check yok.
- **Cozum:** DB'ye `SELECT 1` sorgusu ekle.

### 6.11 Notification bell dekoratif (P3)
- **Dosya:** `client/src/components/layout/Header.tsx`
- **Sorun:** Zil ikonu tiklanmiyor, bildirim sistemi yok.
- **Cozum:** Ya kaldir ya da basit bildirim dropdown'u ekle.

### 6.12 Password degistirme yok (P3)
- **Dosya:** `server/src/routes/auth.ts`
- **Sorun:** Sifre degistirme/sifirlama endpoint'i yok.
- **Cozum:** `PUT /api/auth/change-password` endpoint'i ekle.

---

## Uygulama Sirasi (Setfarm Story'leri)

| Sira | Story | Oncelik | Tahmini Adim |
|------|-------|---------|--------------|
| 1 | Story 4: Guvenlik Aciklari | P0 | 8 adim |
| 2 | Story 1: Icerik Studyosu | P0 | 9 adim |
| 3 | Story 3: Yayin Sistemi | P0 | 6 adim |
| 4 | Story 2: Ayarlar + Trends | P0 | 2 sayfa |
| 5 | Story 5: Site Yonetimi + SEO | P1 | 7 adim |
| 6 | Story 6: UX/UI | P2-P3 | 12 adim |

---

## Teknik Notlar

- **Monorepo:** `client/` (React+Vite, port 3519 dev) + `server/` (Express, port 4519)
- **Build:** `npm run build` (client build -> server/dist ile serve edilir)
- **DB:** PostgreSQL (uzak: 72.61.186.46:37550/autopress)
- **Systemd:** `/etc/systemd/system/autopress.service` (ExecStart: node dist/index.js)
- **Tunnel:** autopress.setrox.com.tr -> 127.0.0.1:4519
- **Auth:** JWT (1h access + 7d refresh), bcrypt password hash
- **Konsol hatalari:** Publisher 500 error, TipTap duplicate link extension
- **Test:** Vitest (client), Jest (server) - mevcut test'ler var ama coverage dusuk
