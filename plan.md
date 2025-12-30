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

## Phase 2 — Wine Photos (Codex)

### Goal

Allow adding, viewing, changing, and removing a photo for each Wine.

### Requirements

- Store images on disk (Documents/wines/<wine-id>.jpg)
- Store only a filename/path string in SwiftData (Wine.imageFilename)
- Do NOT store image Data blobs in SwiftData

### Tasks

1. Model

- Add `imageFilename: String?` to Wine

2. Storage

- Add Services/ImageStore.swift with:
  - ensure Documents/wines directory exists
  - save JPEG (compression ~0.85), optionally downscale large images
  - load UIImage by filename
  - delete image file

3. Add Wine

- Add PhotosPicker image selection + preview
- On save: write image -> set filename -> persist Wine

4. Library + Detail

- Library row shows thumbnail if available
- Wine detail shows header image if available with fallback
- Add “Edit Photo” + “Remove Photo” actions

Stop after Phase 2.
