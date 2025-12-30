# Plan

## Phase 0 (Done)

- App scaffold + DesignSystem
- AppShell tabs
- Hero header background
- App icon + assets

## Phase 1 — Data + Library + Add Wine (Codex)

### 1. Models

- Create SwiftData models: Wine, Tasting
- Add enums and helpers (WineType, rating formatting)
- Seed sample data for previews/dev

### 2. Library

- Library tab shows:
  - segmented filter: All / Cellar / Wishlist
  - search by name/producer/region
  - list rows with name, producer, vintage, rating (latest), wishlist badge
- Tap a wine -> WineDetail screen with:
  - hero header (simple)
  - wine metadata
  - tasting list
  - add tasting button

### 3. Add Wine

- Add Wine flow:
  - Form with name, producer, vintage, type, region/country, grape, wishlist toggle, notes
  - Save to SwiftData
  - After save: show WineDetail

### 4. Home

- Replace placeholder cards with real counts:
  - Recent tastings (last 7/30 days)
  - Wishlist count
  - Avg rating

## Phase 2 (Later)

- Barcode scanner, price lookup, recommendations, sharing/export
