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

## Phase 3 — Edit & Delete (Codex)

### Goal

Allow editing and deleting Wines and Tastings safely, with a polished UX and no orphaned photo files.

### Requirements

- Edit Wine from WineDetail
- Delete Wine from Library and from WineDetail
- Add/Edit/Delete Tasting from WineDetail
- Confirm destructive actions (alerts)
- When deleting a Wine:
  - delete its tastings (cascade already)
  - delete its photo file from disk (PhotoStore) if present
- Keep UI consistent with Theme and current layout
- No new color assets or Theme token changes

### Tasks

1. Edit Wine

- Add an Edit button in WineDetailView
- Present EditWineView (sheet) reusing AddWine form fields
- Save updates to SwiftData (name/producer/vintage/type/region/country/grape/notes/wishlist)
- Keep existing photo unless user changes/removes it

2. Tastings CRUD

- In WineDetailView:
  - Add Tasting (already exists) but ensure it is clean
  - Tap a tasting row -> EditTastingView (sheet)
  - Allow delete tasting (swipe actions or context menu)
- Rating, date, memo, location, pricePaid editable

3. Delete Wine

- Library list:
  - swipe to delete wine
  - confirmation alert before delete
- Wine detail:
  - Delete button (toolbar/menu) with confirmation
- Ensure deletion removes:
  - wine record
  - tastings (cascade)
  - photo file on disk via PhotoStore.removeImage(filename:)

Stop after Phase 3.

## Phase 4 — Stats Dashboard (Codex)

### Goal

Add a Stats dashboard that replaces the Settings tab and provides insight into ratings, regions, and trends.

### Navigation

- Replace the existing Settings tab with a Stats tab.
- Final tab layout:
  Home | Library | Add | Stats

### Requirements

- No Settings screen in this phase
- Use existing Theme tokens and dark UI
- No third-party dependencies
- Stats computed from SwiftData (Wine + Tasting)

### Metrics to include

1. Overview cards

- Total wines
- Total tastings
- Wishlist count
- Average rating (all tastings)

2. Ratings by wine type

- Group by WineType
- Show average rating + count per type

3. Ratings by region (Top 10)

- Group by Wine.region (fallback “Unknown”)
- Show avg rating + tasting count

4. Trends (last 90 days)

- Group tastings by week
- Show average rating per period
- Lightweight visual (bars or simple line style)

### UX

- Empty state when no tastings exist
- Fast and readable; avoid heavy computation

Stop after Phase 4.
