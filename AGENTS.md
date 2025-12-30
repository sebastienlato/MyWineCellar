# Contributor / Agent Rules

## Non-negotiables

- Use SwiftUI + SwiftData only (no deps) unless explicitly requested.
- Use Theme tokens for spacing, radius, and colors.
- Keep UI dark-first, premium, minimal.
- Keep file sizes small and organized by feature folder.
- Build must succeed.

## Code Style

- Prefer small, composable views.
- Prefer `@Query` for SwiftData reads.
- Use `@Model` for SwiftData models.
- Keep models in Models/ and feature UI in Features/<FeatureName>/.
- Add previews for key screens using in-memory ModelContainer.

## Navigation

- Tabs stay in AppShellView.
- Each tab uses its own NavigationStack when necessary.

## Output expectations

- Make incremental changes with clear commit-ready diffs.
- Do not rewrite existing design system.
