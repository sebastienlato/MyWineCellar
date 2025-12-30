You are working in the MyWineCellar repo.

Follow architecture.md and plan.md exactly.

Goal: Implement Phase 1 (Models + Library + Add Wine + Home counts) with SwiftUI + SwiftData.

Constraints:

- Use Theme tokens (Theme.Colors/Spacing/Radius). Do not add new colors.
- HeroBlur must remain confined to a header area (avoid full-screen background images).
- No third-party dependencies.
- Keep changes incremental and compile-safe.

Tasks:

1. Create Models/ folder with SwiftData models:
   - Wine (fields per architecture.md)
   - Tasting (fields per architecture.md)
   - WineType enum with displayName and SF Symbol
2. Create Features/Library:
   - LibraryView (replacing placeholder) with filter + search + list
   - WineRow component
   - WineDetailView with wine metadata + tastings list + add tasting button
3. Create Features/AddWine:
   - AddWineView form to create a Wine
4. Update Home:
   - Show real counts from SwiftData (recent tastings, wishlist count, avg rating)
5. Wire AppShell tabs to the new feature views.
6. Add Previews using an in-memory ModelContainer with seeded sample data.

Stop after completing Phase 1 and ensure the app builds.
