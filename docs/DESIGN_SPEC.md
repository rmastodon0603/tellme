# Tell Me — Design Spec (v1 baseline)

**Purpose:** Define a simple, consistent, “calm & premium-light” UI baseline for Tell Me.  
**Goal:** High readability, low friction, minimal visual noise.  
**Platform:** iOS 17+ (SwiftUI).  
**Note:** This is a baseline spec. Keep design decisions stable unless they block usability.

---

## 1) Design goals
1) **Two taps to first question**
2) **Text-first clarity** (this is a reading + conversation product)
3) **Calm, intimate, premium-light**
4) **Consistency across screens**
5) **Dark mode friendly**
6) **Accessible by default** (Dynamic Type, readable contrast)

---

## 2) Visual style
### Overall vibe
- Minimalist, Apple-native, no “gaming” look
- No gradients, no neon, no heavy shadows
- Use whitespace and typography for hierarchy

### Color palette
- Use **system colors** only:
  - Background: `Color(.systemBackground)`
  - Primary text: `Color(.label)`
  - Secondary text: `Color(.secondaryLabel)`
  - Separator/border: `Color(.separator)` or `secondary.opacity(0.2)`
- One accent color for actions/highlights:
  - Accent: `Color.indigo` (baseline)
- Avoid hardcoded hex colors in v1 unless absolutely required.

### Typography
- Use **system fonts** only.
- Recommended hierarchy:
  - Screen title: `.font(.title2).fontWeight(.semibold)`
  - Pack title: `.font(.headline)`
  - Pack subtitle / meta: `.font(.subheadline).foregroundStyle(.secondary)`
  - Card question text: `.font(.title3)` (or `.headline` if long), with:
    - `lineSpacing(4)` or similar
    - `multilineTextAlignment(.leading)`
- Avoid fixed font sizes that break Dynamic Type.

### Spacing
- Use consistent spacing tokens:
  - `xs = 6`, `s = 10`, `m = 16`, `l = 24`, `xl = 32`
- Prefer generous padding (`m`/`l`) on card content.

---

## 3) Core components
### Card container
- Rounded rectangle container for pack tiles and question cards.
- Specs:
  - Corner radius: **16**
  - Padding inside: **16–24**
  - Border: subtle stroke (`secondary.opacity(0.18–0.25)`)
  - Shadow: optional and very light (opacity ≤ 0.08)

### Buttons
**Primary button**
- Filled with accent color
- Height: **52**
- Corner radius: **14**
- Text: `.font(.headline)` with strong contrast

**Secondary button**
- Outline or soft gray background
- Same height/corner radius
- Used for Skip / Not now / secondary actions

**Destructive button**
- Only for actions like “End session” if needed
- Use system red style sparingly

### Badges (Locked / Free)
- Small pill badges for pack list:
  - “FREE 10/day”
  - “LOCKED”
- Use subtle background with system materials or secondary opacity.

---

## 4) Navigation & layouts
### Navigation
- Use `NavigationStack`
- Minimal toolbar actions:
  - Home: Settings icon/button
  - Session: Back/End session
- Avoid deep navigation trees in v1.

### Layout rules
- Keep screens uncluttered:
  - One primary goal per screen
- Use scroll only when needed (e.g., long card text or pack list).
- No decorative illustrations required in v1.

---

## 5) Screen-by-screen baseline
### Home (Packs)
- Vertical list of pack tiles (recommended)
- Each tile includes:
  - Pack title
  - 1-line description
  - Badge (FREE or LOCKED)
- Tap behavior:
  - Free pack → Session
  - Locked pack → Paywall

### Session
- Centered card container with question text
- Buttons anchored near bottom:
  - Primary: Next
  - Secondary: Skip
- Keep “End session” accessible but not visually dominant.

### Paywall
- Simple, honest, text-driven layout:
  - Title
  - 3 bullet benefits
  - Price (from StoreKit if possible)
  - Primary CTA: Unlock
  - Secondary CTA: Restore
  - Tertiary: Not now
- No fake timers, no “limited offer” tricks.

### Settings
- Simple list:
  - Restore Purchases
  - Privacy Policy
  - Support
  - Version
- Use native `List` style.

---

## 6) Accessibility & localization considerations
- Support Dynamic Type (avoid fixed heights for text containers)
- Use system colors for contrast across light/dark mode
- Ensure buttons have adequate tappable area (≥ 44pt)
- English-only in v1, but avoid hardcoding strings deep in logic (keep strings centralized when feasible)

---

## 7) Implementation guidance (SwiftUI)
Recommended approach:
- Create a small design token file:
  - `Theme.swift` with spacing/corner radius constants
  - `PrimaryButtonStyle`, `SecondaryButtonStyle`
  - `CardContainerModifier`

Keep it minimal — do not over-engineer.

---

## 8) Anti-goals (what NOT to do in v1)
- No gradients, heavy animations, parallax
- No “gamey” fonts or excessive icons
- No complex theming system
- No custom navigation or tab bars unless necessary
- No busy backgrounds behind text

---