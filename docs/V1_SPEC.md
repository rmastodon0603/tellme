# Tell Me — MVP Spec (v1) — iOS Couples Conversation Cards

> This document is the execution spec for v1 (MVP).  
> Product vision/roadmap lives in `CONCEPT.md`.

## 0) Goal of v1
Ship a simple, offline-first iOS app to learn:
- SwiftUI app development
- StoreKit 2 (one-time purchase) + restore
- App Store publishing workflow (TestFlight → Review → Release)

v1 is **Couples-only**, **English-only**, **no login**, **no history**, **no favorites**, **no spicy**.

---

## 1) Product Summary (v1)
**Tell Me** is a couples conversation card game.
Users pick a pack and draw cards one by one to talk.

v1 includes:
- A free **Base** pack (mixed relationship questions) with **10 card reveals/day**
- A paid **Starter Pack** (one-time purchase) that unlocks:
  - Unlimited access to the full Base pack (removes daily limit)
  - Two additional packs:
    - **“Between Us”** (UA: “Між нами”)
    - **“Deeper About You”** (UA: “Глибше про тебе”)

**Price:** $2.99 (one-time IAP)

---

## 2) Platforms & Tech
- Platform: iOS only
- Minimum OS: iOS 17+
- UI: SwiftUI
- Purchases: StoreKit 2
- Data: Local JSON in app bundle (offline-first)
- Persistence: UserDefaults (daily limit counter + date; optional cache flags)
- No third-party analytics SDK in v1

Development workflow:
- Coding with Cursor + LLMs
- Build/run/archive in Xcode

---

## 3) Scope
### In scope (v1)
- Packs list (Base + locked packs)
- Session flow: show card → Next / Skip
- Daily free limit: 10 reveals/day (Base pack only)
- Paywall + purchase + restore purchases
- Offline operation (no backend)
- Settings screen with Restore + Support + Privacy

### Out of scope (v1)
- Spicy / 18+ content
- Friends mode
- Favorites / saved cards
- Game history / recap / journaling
- Account/login/sync
- UGC (user-generated packs)
- Push notifications
- In-app event analytics / attribution SDKs

---

## 4) Packs & Access Rules
### Pack definitions
- **Base** (free preview with limit): mixed questions, broad relationship themes
- **Between Us** (paid)
- **Deeper About You** (paid)

### Access rules (v1)
- If user is **not Pro**:
  - Can play **Base** only
  - Enforced limit: **10 card reveals per calendar day**
  - Attempts to reveal card #11 show Paywall
  - Paid packs are visible but locked

- If user **is Pro** (Starter Pack purchased/restored):
  - Base: unlimited
  - Between Us: unlocked
  - Deeper About You: unlocked
  - No daily limit anywhere

---

## 5) Core Loop
1) Home: choose a pack (Base / Between Us / Deeper About You)
2) Start Session
3) Reveal card
4) Actions: Next / Skip / End Session
5) Continue until user ends session or limit reached (Base only, free users)

---

## 6) Screens (Minimum)
### 6.1 Home (Packs)
- App title + short tagline
- List of packs:
  - Base (Free — “10 cards/day” label)
  - Between Us (Locked badge if not Pro)
  - Deeper About You (Locked badge if not Pro)
- Tap pack → Pack details or direct Start (choose one UX, keep simple)
- If locked pack tapped while not Pro → show Paywall (or an “Unlock” interstitial)

### 6.2 Session
- Large card text
- Buttons:
  - **Next** (primary)
  - **Skip** (secondary)
  - **End Session** (back)
- If free user reaches daily limit on Base:
  - show Paywall modal/screen
  - after closing paywall: block reveal until next day or purchase

### 6.3 Paywall
- Title: “Unlock Starter Pack”
- Value bullets:
  - “Unlimited Base questions”
  - “Unlock ‘Between Us’”
  - “Unlock ‘Deeper About You’”
- Price display: $2.99 (pulled from StoreKit where possible)
- Buttons:
  - **Unlock Now** (purchase)
  - **Restore Purchases**
  - Not now (close)

### 6.4 Settings
- Restore Purchases
- Privacy Policy (opens URL)
- Support (opens URL or mailto)
- App version

---

## 7) Daily Limit (Free users)
### Rule
- Base pack: **10 card reveals/day**
- “Reveal” = moment the question is shown to the user (not just opening session)

### Storage
- UserDefaults keys:
  - `dailyRevealCount` (Int)
  - `dailyRevealDate` (String, e.g., "YYYY-MM-DD" normalized; choose UTC or device calendar but be consistent)

### Reset
- On app launch and on each reveal attempt:
  - if stored date != today → reset count to 0, update date

### Edge cases
- If user changes device time manually: acceptable to have imperfect behavior in v1; prefer UTC date via Calendar if possible.

---

## 8) Content Requirements
### Quantity
- v1 target: **100 total cards minimum** across all packs combined
  - Suggested split:
    - Base: 50–60
    - Between Us: 20–30
    - Deeper About You: 20–30

### Categories
- No “Light/Deep” labeling in UI for Base (per requirement).
- Internally you may still tag cards (optional) for future use, but **not required**.

### Quality constraints
- No explicit sexual content / pornography / minors
- Avoid humiliation, hate, harassment
- Keep tone: curious, respectful, relationship-positive
- Questions should be short and readable on one screen

---

## 9) Data Model & JSON (Bundle)
### Models
- `Pack`
  - `id: String` (e.g., "base", "between_us", "deeper_about_you")
  - `title: String`
  - `subtitle: String` (optional)
  - `isPaid: Bool` (true for paid packs)
  - `order: Int`

- `Card`
  - `id: String`
  - `packId: String`
  - `text: String`

### Storage
- `/Data/packs.json`
- `/Data/cards.json`

### Loading
- `ContentRepository` loads JSON from `Bundle.main`
- Fail-safe: if JSON fails to load, show a user-friendly error screen (or an empty state) — keep minimal.

---

## 10) Purchase (StoreKit 2)
### Product
- One non-consumable IAP:
  - Name: Starter Pack
  - Product ID: `starter_pack`
  - Price: $2.99

### Behavior
- Purchase sets entitlement: `isPro = true`
- Restore also sets `isPro = true` if owned
- App checks entitlement on launch and on foreground

### UI requirements for review safety
- Restore Purchases available in Paywall and Settings
- Clear description of what Starter Pack unlocks

---

## 11) Analytics (v1)
No in-app analytics SDK.
Use App Store Connect:
- App Analytics: installs, active devices, retention, sessions
- Sales & Trends: proceeds, IAP purchases

Note: this will not provide in-app funnel metrics.

---

## 12) Privacy / Compliance (v1)
- No account/login
- No data collection beyond what iOS/Apple requires
- Provide:
  - Privacy Policy URL
  - Support URL
- Age rating: appropriate for general relationship conversation content (no spicy)

---

## 13) Suggested File Structure
- /Models
  - Card.swift
  - Pack.swift
- /Data
  - packs.json
  - cards.json
  - ContentRepository.swift
- /Views
  - HomeView.swift
  - SessionView.swift
  - PaywallView.swift
  - SettingsView.swift
- /Store
  - PurchaseManager.swift
  - EntitlementStore.swift
- /Utilities
  - DailyLimitStore.swift

---

## 14) Definition of Done (v1)
- [ ] App compiles and runs on iOS 17+
- [ ] Packs load from JSON and display on Home
- [ ] Session works (Next/Skip/End)
- [ ] Free Base enforced at 10 reveals/day
- [ ] Paywall shown at limit
- [ ] StoreKit 2 purchase works (Sandbox/TestFlight)
- [ ] Restore purchases works after reinstall
- [ ] Pro unlock removes limit and unlocks both paid packs
- [ ] Offline works (no internet required for core usage)
- [ ] Privacy Policy + Support links exist
- [ ] App Store assets ready (icon + screenshots + description)
- [ ] Submitted to TestFlight and then App Review

---

## 15) Future (not v1, reference only)
- New paid packs (content drops)
- Packs with unique mechanics (e.g., “write answers first”, “guess partner’s answer” mode)
- Friends mode
- Favorites/history
- Localization