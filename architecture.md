# MyWineCellar Architecture

## Goals

- A fast, offline-first wine tracker + review journal.
- SwiftUI + SwiftData.
- Premium dark UI with a simple, consistent design system (Theme tokens).

## Stack

- UI: SwiftUI
- Persistence: SwiftData
- Navigation: TabView (Home, Library, Add, Settings)

## Folder Structure

- DesignSystem/
  - Theme.swift
- Features/
  - AppShell/
  - Home/
  - Library/
  - AddWine/
  - Settings/
- Models/
- Services/ (later)

## Data Model (SwiftData)

### Wine

- id (UUID)
- name (String)
- producer (String)
- vintage (Int?)
- region (String?)
- country (String?)
- grape (String?)
- type (enum: red/white/rose/sparkling/dessert/fortified)
- notes (String?)
- isWishlist (Bool)
- createdAt (Date)

### Tasting

- id (UUID)
- date (Date)
- rating (Double 0...5, allow .5)
- pricePaid (Decimal?)
- location (String?)
- memo (String?)
- wine (relationship -> Wine)

## UX Rules

- Use Theme tokens (Theme.Colors / Spacing / Radius).
- Do not introduce new colors without adding to Assets + Theme.
- HeroBlur stays confined to header area (avoid full-screen background causing safe-area issues).
- Use NavigationStack per tab where needed, but keep AppShell stable.

## What NOT to do

- No third-party dependencies in Phase 1.
- No complex animations yet.
- No camera/barcode scanning yet (Phase later).
