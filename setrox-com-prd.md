# PRD: setrox.com — Personal Developer Portfolio

**Version:** 2.0
**Date:** 2026-02-15
**Author:** Hikmet Gulsesli
**Reference Design:** alexcinovoj.dev

---

## 1. Product Overview

**setrox.com** is a multi-theme, terminal-aesthetic developer portfolio showcasing Hikmet's OpenClaw AI agent ecosystem, projects, and technical expertise. The design follows a cyberpunk-minimalist approach with monospace typography, ASCII art elements, glassmorphism cards, smooth staggered animations, **5 accent color themes**, and **light/dark mode toggle**.

**Target URL:** setrox.com (Cloudflare Tunnel via moltclaw)
**Stack:** Next.js 15 + Tailwind CSS 4 + Framer Motion
**Deployment:** Static export → Hikmet server (systemd + Cloudflare Tunnel)

---

## 2. Design System

### 2.1 Color System (oklch-based, Multi-Theme)

The site uses **oklch color space** with CSS custom properties. Neutral colors change between light/dark mode. Accent colors change between 5 themes. Implementation: `next-themes` for light/dark (class-based), JS inline `style` on `<html>` for accent overrides.

**Storage:** `localStorage['color-theme']` (accent name), `localStorage['theme']` (light/dark via next-themes)

#### Neutral Colors (constant across accent themes)

**Dark mode (`.dark` class):**

| Token | Value | Usage |
|-------|-------|-------|
| `--background` | `oklch(0.06 0.015 260)` | Page background |
| `--card` | `oklch(0.1 0.015 260)` | Card backgrounds |
| `--border` | `oklch(0.2 0.015 260)` | Borders, dividers |
| `--foreground` | `oklch(0.96 0 0)` | Headings, primary text |
| `--muted-foreground` | `oklch(0.58 0 0)` | Descriptions, metadata |

**Light mode (`:root` default):**

| Token | Value | Usage |
|-------|-------|-------|
| `--background` | `oklch(0.985 0.002 260)` | Page background |
| `--card` | `oklch(1 0 0)` | Card backgrounds |
| `--border` | `oklch(0.92 0.008 260)` | Borders, dividers |
| `--foreground` | `oklch(0.12 0.015 260)` | Headings, primary text |
| `--muted-foreground` | `oklch(0.48 0.01 260)` | Descriptions, metadata |

#### 5 Accent Themes (JS overrides `--primary`, `--accent`, `--ring`, `--glow-color`)

| Theme | Dark Primary | Light Primary | Hue |
|-------|-------------|---------------|-----|
| Purple (default) | `oklch(0.70 0.20 295)` | `oklch(0.55 0.25 295)` | 295 |
| Cyan | `oklch(0.75 0.15 195)` | `oklch(0.55 0.15 195)` | 195 |
| Golden | `oklch(0.78 0.14 85)` | `oklch(0.60 0.16 85)` | 85 |
| Emerald | `oklch(0.75 0.17 165)` | `oklch(0.55 0.17 165)` | 165 |
| Rose | `oklch(0.70 0.18 20)` | `oklch(0.55 0.20 20)` | 20 |

Glow derivation: `--glow-color: oklch(from var(--primary) l c h / 0.12)`, `--glow-color-strong: oklch(from var(--primary) l c h / 0.22)`

#### Semantic Status Colors (constant)

| Token | Value | Usage |
|-------|-------|-------|
| `--accent-green` | `#22c55e` | Status: running/online |
| `--accent-yellow` | `#eab308` | Status: in-progress |
| `--accent-red` | `#ef4444` | Status: down/error |

### 2.2 Typography

| Element | Font | Weight | Size (desktop) | Size (mobile) | Tracking |
|---------|------|--------|----------------|---------------|----------|
| Logo | Space Grotesk | 700 | 24px | 20px | 0.05em |
| H1 (Hero) | Space Grotesk | 700 | 56px (text-5xl) | 36px (text-3xl) | -0.02em |
| H2 (Section) | Space Grotesk | 600 | 36px (text-3xl) | 28px (text-2xl) | -0.01em |
| H3 (Card title) | Geist Mono | 500 | 20px | 18px | 0 |
| Body | Geist Sans | 400 | 16px | 15px | 0 |
| Label/Tag | Geist Mono | 500 | 12px | 11px | 0.25em |
| Terminal text | Geist Mono | 400 | 14px | 13px | 0.05em |

### 2.3 Spacing & Layout

- **Container:** max-width 1200px, centered, px-6 (mobile) / px-8 (desktop)
- **Section gap:** 120px (desktop) / 80px (mobile)
- **Card padding:** 24px
- **Card border-radius:** 12px
- **Card border:** 1px solid `--border`
- **Grid gap:** 24px

### 2.4 Effects

| Effect | CSS |
|--------|-----|
| Glassmorphism | `oklch(from var(--card) l c h / .6)` + `backdrop-blur(12px) saturate(1.5)` + `border-white/5` |
| Glass strong | `oklch(from var(--card) l c h / .8)` + `backdrop-blur(20px) saturate(1.8)` |
| Card hover lift | `transform: translateY(-4px)` + `border-color: var(--glow-color-strong)` |
| Gradient text | `bg-gradient-to-r` using `var(--primary)` → lighter variant, `bg-clip-text text-transparent` |
| Selection highlight | `oklch(from var(--primary) l c h / .3)` |
| Cursor glow | Mouse-tracking dual-layer glow (see 2.5 below) |
| Scanlines | `repeating-linear-gradient(0deg, transparent, transparent 2px, rgba(0,0,0,0.03) 2px, rgba(0,0,0,0.03) 4px)` overlay |
| Glow | `box-shadow: 0 0 30px rgba(0,212,255,0.1)` |
| Shimmer (progress) | Animated `background-position` on linear-gradient |

### 2.5 CursorGlow Effect (Desktop Only)

Mouse'u takip eden çift katmanlı ışıma efekti. Sadece `lg:` breakpoint üstünde görünür.

**Component:** `src/components/ui/CursorGlow.tsx`

**Katman 1 — Dış glow:**
- `position: fixed`, `pointer-events: none`, `border-radius: 50%`
- Boyut: 400px (normal), 500px (interactive element üzerinde — `a, button, [role="button"], input`)
- Renk: `var(--primary)` ile `radial-gradient`, düşük opacity
- Geçiş: `transition: opacity 0.4s ease, width 0.3s ease, height 0.3s ease`

**Katman 2 — İç nokta:**
- 32px küçük daire, `position: fixed`, mouse'un tam ortasında
- `background: radial-gradient(circle, var(--primary) 0%, transparent 70%)`
- `opacity: 0.15`, `filter: blur(4px)`, `mix-blend-screen`

**Davranış:**
- `mousemove` event → `requestAnimationFrame` ile position güncelle (smooth, passive listener)
- `mouseleave` → glow kaybolur (`opacity: 0`)
- `mouseover` → interactive element check → glow büyür (400→500px)
- `hidden lg:block` — mobilde gizli

**Tema uyumu:** `var(--primary)` kullandığı için seçili accent theme'e otomatik uyar.

### 2.6 Animations (Framer Motion)

| Animation | Config |
|-----------|--------|
| Fade-in-up (sections) | `y: 20 → 0, opacity: 0 → 1, duration: 0.6s, ease: easeOut` |
| Stagger children | `staggerChildren: 0.1s` |
| Card hover | `scale: 1.02, transition: 0.3s` |
| Typing cursor | `opacity: 0 ↔ 1, repeat: Infinity, duration: 0.8s` |
| Progress bar fill | `width: 0% → N%, duration: 1.2s, ease: easeOut` |
| Button hover | `background-position shift, scale: 1.05` |

---

## 3. Page Structure (Top to Bottom)

### 3.1 Sticky Navigation Bar

```
┌─────────────────────────────────────────────────────────┐
│ [HG]  Home  Projects  Agents  Blog   [Li] [X] [GH]     │
└─────────────────────────────────────────────────────────┘
```

- **Logo:** "HG" circle monogram + "Setrox" wordmark
- **Links:** `>HOME`, `PROJECTS`, `AGENTS`, `WRITING` — uppercase, Geist Mono, letter-spaced
- **Theme controls (right side):**
  - Palette icon → dropdown with 5 color circles (Purple, Cyan, Golden, Emerald, Rose)
  - Sun/Moon icon → toggles light/dark mode via `next-themes`
- **Social icons:** LinkedIn, X, GitHub — right-aligned
- **Status badge:** "10 agents live" (green pulsing dot + text)
- **Style:** Glassmorphism (`backdrop-blur(12px) saturate(1.5)`), sticky top, z-50
- **Mobile:** Hamburger menu, theme controls stay visible
- **Behavior:** Sticky top, smooth scroll to sections via anchor links

### 3.2 Hero Section

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  DEVELOPER & AI ARCHITECT                               │
│                                                         │
│  Hikmet Gulsesli                                        │
│  — Founder of OpenClaw                                  │
│                                                         │
│  Building autonomous AI agent systems                   │
│  that work while you sleep.                             │
│                                                         │
│  ┌──────────────────┐  ┌──────────────────────────────┐ │
│  │  OPENCLAW         │  │  ╔═══════════════════════╗   │ │
│  │  agents: 10       │  │  ║   O P E N C L A W     ║   │ │
│  │  projects: 12+    │  │  ║   status: running      ║   │ │
│  │  uptime: 99.5%    │  │  ║   agents: 10/10 ✓      ║   │ │
│  │  status: running  │  │  ╚═══════════════════════╝   │ │
│  └──────────────────┘  └──────────────────────────────┘ │
│                                                         │
│  [explore projects]  [meet the agents]                  │
│                                                         │
│  10 Agents  ·  12+ Projects  ·  20GB Server             │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Content:**
- **Superscript label:** "DEVELOPER & AI ARCHITECT" — uppercase, letter-spaced, `--text-muted`, Geist Mono
- **Name:** "Hikmet Gulsesli" — H1, gradient text using current accent theme color
- **Subtitle:** "— Founder of OpenClaw" — `--text-secondary`
- **Tagline:** "Building autonomous AI agent systems that work while you sleep." — animated typing effect on "that work while you sleep" portion
- **ASCII art:** Two terminal boxes showing OpenClaw stats (monospace, `var(--primary)` border)
- **CTAs:** Two buttons — "explore projects" (filled, accent color) + "meet the agents" (outlined)
- **Stats row:** "10 Agents · 12+ Projects · 20GB Server" — small, muted, centered

### 3.3 Projects Section

```
┌─────────────────────────────────────────────────────────┐
│  PROJECTS                                               │
│  Projects & Open Source                                  │
│  12+ projects. 10 agents running across the ecosystem.   │
│                                                         │
│  [all] [shipped] [in-progress] [archived]               │
│                                                         │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐       │
│  │ 2026 shipped │ │ 2026  wip   │ │ 2025 shipped│       │
│  │ Mission Ctrl │ │ RestMenu    │ │ LogPulse    │       │
│  │ React+Express│ │ Restaurant  │ │ Real-time   │       │
│  │ dashboard    │ │ menu system │ │ log viewer  │       │
│  │ #react #node │ │ #next #api  │ │ #node #sse  │       │
│  │ [live][code] │ │ [live][code]│ │ [live][code]│       │
│  └─────────────┘ └─────────────┘ └─────────────┘       │
│  ... (4x3 grid or 3x4 grid)                            │
└─────────────────────────────────────────────────────────┘
```

**Grid:** 3 columns (desktop), 2 columns (tablet), 1 column (mobile)

**Each project card contains:**
- **Year badge:** Top-left, `--text-muted`
- **Status badge:** Top-right — "shipped" (green), "in-progress" (yellow), "archived" (muted)
- **Title:** H3, Geist Mono
- **Description:** 2 lines max, `--text-secondary`
- **Tags:** Pill-shaped — e.g. `#react`, `#node`, `#ai`, `#python`
- **Links:** "live" icon + "source" icon (bottom-right)
- **Hover:** Card lifts, border glows with accent color

**Project Data (12 items):**

| # | Name | Year | Status | Tags | Has Live | Has Source |
|---|------|------|--------|------|----------|------------|
| 1 | Mission Control | 2026 | shipped | react, express, ai | ai.setrox.com.tr | github |
| 2 | Antfarm Workflows | 2026 | shipped | automation, yaml, ci | antfarm.setrox.com.tr | github |
| 3 | RestMenu | 2026 | in-progress | next.js, restaurant | restmenu.setrox.com.tr | github |
| 4 | LogPulse | 2026 | shipped | node, sse, logging | logpulse.setrox.com.tr | github |
| 5 | AgentViz | 2026 | shipped | react, d3, agents | agentviz.setrox.com.tr | github |
| 6 | ClawDocs | 2026 | shipped | docs, markdown | clawdocs.setrox.com.tr | github |
| 7 | StatusPage | 2026 | shipped | monitoring, uptime | statuspage.setrox.com.tr | github |
| 8 | Discord Bot (Arya) | 2026 | shipped | discord.js, ai | - | github |
| 9 | Pomodoro Timer | 2025 | shipped | react, productivity | pomodoro.setrox.com.tr | github |
| 10 | Habit Tracker | 2025 | shipped | react, wellness | habit.setrox.com.tr | github |
| 11 | Typing Speed Test | 2025 | shipped | vanilla js, game | typing.setrox.com.tr | github |
| 12 | Smart RAM Skill | 2025 | shipped | bash, monitoring | - | github |

**Filter tabs:** Clicking filters cards with CSS transition (fade out/in).

### 3.4 Agents Section (Unique — replaces "Resources" section)

```
┌─────────────────────────────────────────────────────────┐
│  AGENTS                                                  │
│  The OpenClaw Team                                       │
│  10 autonomous AI agents, each with a specialized role.  │
│                                                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │ 🦞 Arya  │ │ 🤖 Koda  │ │ ⚡ Kaan  │ │ 🌍 Atlas │   │
│  │ CEO      │ │ Lead Dev │ │ Sr. FS   │ │ Infra    │   │
│  │ M2.5     │ │ K2.5     │ │ K2.5     │ │ K2.5     │   │
│  │ orchestr.│ │ planning │ │ features │ │ deploy   │   │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐   │
│  │ 🔍 Defne │ │ 🛡️ Sinan │ │ 💻 Elif  │ │ ✍️ Deniz │   │
│  │ Research │ │ QA/CR    │ │ Backend  │ │ Content  │   │
│  │ M2.5     │ │ M2.5     │ │ K2.5     │ │ M2.5     │   │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘   │
│  ┌──────────┐ ┌──────────┐                              │
│  │ 🔄 Onur  │ │ 🎨 Mert  │                              │
│  │ SRE      │ │ Frontend │                              │
│  │ M2.5     │ │ M2.5     │                              │
│  └──────────┘ └──────────┘                              │
└─────────────────────────────────────────────────────────┘
```

**Grid:** 4 columns (desktop), 2 columns (mobile)

**Each agent card contains:**
- **Emoji:** Large (32px), top-left
- **Name:** H3, bold
- **Role:** `--text-secondary`, one line
- **Model badge:** Small pill — "MiniMax M2.5" or "Kimi K2.5"
- **Description:** 1-2 lines of what they do
- **Status dot:** Green pulsing dot = "online"
- **Hover:** Emoji scales up, border glows with agent-specific color

**Agent-specific accent colors:**

| Agent | Hover Color |
|-------|-------------|
| Arya | `#ef4444` (red/lobster) |
| Koda | `#3b82f6` (blue) |
| Kaan | `#eab308` (yellow/lightning) |
| Atlas | `#22c55e` (green/earth) |
| Defne | `#a855f7` (purple/search) |
| Sinan | `#6366f1` (indigo/shield) |
| Elif | `#06b6d4` (cyan/code) |
| Deniz | `#f97316` (orange/write) |
| Onur | `#14b8a6` (teal/cycle) |
| Mert | `#ec4899` (pink/art) |

### 3.5 Active Projects Terminal

```
┌─────────────────────────────────────────────────────────┐
│  ● ● ●  ~/setrox/active-projects                        │
│─────────────────────────────────────────────────────────│
│  $ openclaw status --projects                            │
│                                                         │
│  mission-control     ██████████████████░░  92%  2h ago  │
│  antfarm-workflows   ████████████████████  100% 1d ago  │
│  restmenu            █████████████░░░░░░░  68%  4h ago  │
│  agent-viz           ██████████████████░░  95%  6h ago  │
│  logpulse            ████████████████████  100% 3d ago  │
│                                                         │
│  ❯ openclaw agents status | 10/10 agents operational    │
│  ❯ server uptime: 45d 12h | ram: 12.4/20GB              │
└─────────────────────────────────────────────────────────┘
```

**Design:**
- **Window chrome:** macOS-style dots (red, yellow, green) + file path
- **Background:** `#0d0d14`, slightly lighter than page bg
- **Border:** 1px solid `--border`, border-radius: 12px
- **Content:** Monospace, `var(--primary)` for commands
- **Progress bars:** Filled portion colored by completion:
  - 100%: `--accent-green`
  - 75-99%: `--accent-cyan`
  - 50-74%: `--accent-yellow`
  - <50%: `--accent-red`
- **Shimmer animation** on progress bars
- **Bottom commands:** Typing animation, one after another

### 3.6 Tech Stack Section (Optional — compact)

```
┌─────────────────────────────────────────────────────────┐
│  STACK                                                   │
│  Built With                                              │
│                                                         │
│  [Node.js] [React] [Python] [Docker] [PostgreSQL]       │
│  [Tailscale] [Cloudflare] [Grafana] [Prometheus]        │
│  [Discord.js] [n8n] [Ollama] [Next.js] [Express]       │
└─────────────────────────────────────────────────────────┘
```

- Horizontal scrollable row of tech badges
- Each badge: icon + name, glassmorphism style
- Subtle hover scale effect
- No links, purely visual

### 3.7 Newsletter / Contact Section

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│  Let's build autonomous systems together.                │
│                                                         │
│  ┌──────────────────────────┐ [subscribe →]             │
│  │  your@email.com          │                           │
│  └──────────────────────────┘                           │
│  No spam · Unsubscribe anytime · Monthly insights       │
│                                                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐                │
│  │ LinkedIn  │ │ X        │ │ GitHub   │                │
│  │ /setrox   │ │ @setrox  │ │ @hikmet  │                │
│  └──────────┘ └──────────┘ └──────────┘                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

- **Heading:** "Let's build autonomous systems together." — gradient text using accent theme
- **Email input:** Dark input field + accent-colored "subscribe" button
- **Reassurance:** Small muted text below
- **Social cards:** 3 full-width cards with icon, platform name, handle
- **Hover:** Cards lift, icon scales

### 3.8 Footer

```
┌─────────────────────────────────────────────────────────┐
│  © 2026 Hikmet Gulsesli — All rights reserved           │
│  Built with OpenClaw · Powered by {agents.length} AI agents │
└─────────────────────────────────────────────────────────┘
```

- Minimal single-line footer
- `--text-muted` color
- Centered text
- Top border: `1px solid --border`

---

## 4. Responsive Breakpoints

| Breakpoint | Width | Grid Columns | Hero Text |
|------------|-------|--------------|-----------|
| Mobile | < 640px | 1 col | text-3xl |
| Tablet | 640-1024px | 2 col | text-4xl |
| Desktop | > 1024px | 3-4 col | text-5xl |

**Key responsive changes:**
- Nav: Full links → icon-only social on mobile
- Hero ASCII art: Side-by-side → stacked on mobile
- Project grid: 3 → 2 → 1 columns
- Agent grid: 4 → 2 → 1 columns
- Terminal: Horizontal scroll on narrow screens
- Section padding: 120px → 80px → 60px

---

## 5. Interactions & Micro-animations

| Interaction | Animation |
|-------------|-----------|
| Page load | Sections fade-in-up sequentially (stagger 0.15s) |
| Scroll into view | Each section triggers entrance animation (IntersectionObserver) |
| Card hover | `translateY(-4px)`, border glow, shadow increase |
| Button hover | Background gradient shift, `scale(1.05)` |
| Agent card hover | Emoji bounces, agent-color border glow |
| Terminal load | Progress bars animate from 0% → target |
| Typing effect | Hero tagline types out character by character |
| Status dots | Green dot pulses with `scale(1) → scale(1.3)` every 2s |
| Filter tabs | Active tab: filled bg, inactive: outlined |
| Smooth scroll | `scroll-behavior: smooth` on anchor navigation |
| Page transition | Fade between routes (Next.js) |

---

## 6. Pages

### 6.1 Homepage (/)
All sections described above in single scrollable page.

### 6.2 Projects Page (/projects)
Full project listing with filter tabs. Same cards but more detail (full description, screenshots on hover).

### 6.3 Agents Page (/agents) — Future
Dedicated page per agent with activity timeline, recent commits, model info.

### 6.4 Blog Page (/blog) — Future
MDX-powered blog with syntax highlighting, terminal-style code blocks.

### 6.5 404 Page
Glitch animation on "404" heading + ASCII art terminal showing `command not found`.

---

## 7. SEO & Meta

```html
<title>Hikmet Gulsesli — Developer & AI Architect | setrox.com</title>
<meta name="description" content="Building autonomous AI agent systems with OpenClaw. 10 agents, 12+ projects, one developer.">
<meta property="og:image" content="/og-image.png">
<meta property="og:title" content="Hikmet Gulsesli — setrox.com">
<meta name="theme-color" content="#8b5cf6"> <!-- Purple default, updates dynamically -->
```

- Open Graph image: Dark card with name + "10 Agents · 12+ Projects"
- Favicon: "HG" monogram or Setrox logo (accent color on dark bg)
- Sitemap.xml for all pages
- robots.txt allowing all

---

## 8. Performance Targets

| Metric | Target |
|--------|--------|
| Lighthouse Performance | > 95 |
| First Contentful Paint | < 1.0s |
| Largest Contentful Paint | < 2.0s |
| Cumulative Layout Shift | < 0.05 |
| Total Bundle Size | < 200KB (gzipped) |
| Image format | WebP/AVIF with fallback |

---

## 9. Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 15 (App Router) |
| Styling | Tailwind CSS 4 |
| Animations | Framer Motion 12 |
| Fonts | Space Grotesk + Geist (local hosting) |
| Icons | Lucide React |
| Deployment | Static export → systemd service |
| Tunnel | Cloudflare Tunnel (setrox.com.tr subdomain) |
| Analytics | Plausible or Umami (self-hosted, optional) |
| Newsletter | Buttondown or custom API (optional) |

---

## 10. Data Architecture

All project and agent data should be stored in TypeScript data files (not a CMS).

### 10.1 Dynamic Counts (CRITICAL)

**ASLA sayı hardcode'lanmayacak.** Hero, Navbar ve diğer tüm bölümlerde proje/agent sayıları data dosyalarından türetilecek:

```tsx
import { projects } from '@/data/projects'
import { agents } from '@/data/agents'

// Hero stats row:
<span>{agents.length} Agents · {projects.length}+ Projects · 20GB Server</span>

// Navbar status badge:
<span>{agents.length} agents live</span>
```

Bu sayede `projects.ts`'e yeni bir entry eklenip rebuild yapıldığında tüm sayılar otomatik güncellenir. Hiçbir component'ta `"10"` veya `"12"` gibi sabit sayı kullanılmayacak — her zaman `.length` ile.

### 10.2 Data Files Structure:

```
src/
├── data/
│   ├── projects.ts    # Project[] array with all metadata
│   ├── agents.ts      # Agent[] array with roles, models, colors
│   └── socials.ts     # Social links
├── lib/
│   └── theme-context.tsx  # React context for accent color + inline style management
├── components/
│   ├── layout/
│   │   ├── Navbar.tsx
│   │   └── Footer.tsx
│   ├── sections/
│   │   ├── Hero.tsx
│   │   ├── Projects.tsx
│   │   ├── Agents.tsx
│   │   ├── Terminal.tsx
│   │   ├── TechStack.tsx
│   │   ├── Contact.tsx
│   │   └── Blog.tsx
│   └── ui/
│       ├── Card.tsx
│       ├── Badge.tsx
│       ├── ProgressBar.tsx
│       ├── FilterTabs.tsx
│       ├── AsciiBox.tsx
│       ├── TypingEffect.tsx
│       ├── ThemeSwitcher.tsx  # Navbar color picker + sun/moon toggle
│       └── CursorGlow.tsx    # Mouse-tracking dual-layer glow (desktop only)
├── styles/
│   └── globals.css    # oklch CSS vars, 5 themes, light/dark neutrals, glassmorphism
└── app/
    ├── layout.tsx     # Root layout, fonts, ThemeProvider + AccentProvider
    ├── page.tsx
    ├── projects/page.tsx
    └── not-found.tsx
```

---

## 11. Deployment Plan

1. Develop locally on Windows (D:\openclaw\setrox-com\)
2. Git repo: github.com/hikmetgulsesli/setrox-com
3. `next build && next export` → static files in `out/`
4. rsync/scp to server: `~/setrox-com/`
5. Systemd service: `setrox-com.service` (serve static via `npx serve` or nginx)
6. Cloudflare Tunnel: add `setrox.com.tr` hostname → `localhost:PORT`
7. DNS: CNAME setrox.com.tr → tunnel UUID.cfargotunnel.com
8. Uptime Kuma monitor: HTTP check on localhost:PORT

---

## 12. Content Localization

- **Primary language:** English (international portfolio)
- **Secondary:** Turkish elements where natural (agent names are already Turkish)
- No i18n framework needed — single language with occasional Turkish flair

---

## 13. Acceptance Criteria

- [ ] All 8 sections render correctly on desktop, tablet, mobile
- [ ] Smooth scroll-triggered animations (no jank)
- [ ] All 12 projects display with correct status/tags/links
- [ ] All 10 agents display with correct roles/models/colors
- [ ] Terminal section shows animated progress bars
- [ ] Hero typing effect works smoothly
- [ ] Filter tabs correctly filter project cards
- [ ] Lighthouse score > 95 on all metrics
- [ ] 5 accent color themes work (Purple, Cyan, Golden, Emerald, Rose) — accent changes everywhere
- [ ] Light/Dark mode toggle works with proper contrast in both modes
- [ ] Theme selections persist via localStorage across page reloads
- [ ] All external links open in new tab
- [ ] 404 page with glitch effect
- [ ] Responsive at all breakpoints (320px → 1920px)
- [ ] Accessible: semantic HTML, proper heading hierarchy, alt texts
- [ ] CursorGlow efekti desktop'ta çalışıyor, mobilde gizli
- [ ] CursorGlow interactive element'lerde büyüyor (400→500px)
- [ ] Tüm sayılar (agent count, project count) data dosyalarından dynamic geliyor, hardcode yok
- [ ] Deployed and reachable via setrox.com.tr
