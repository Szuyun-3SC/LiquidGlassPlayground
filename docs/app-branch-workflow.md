# App Branch Workflow

The repeatable recipe for creating an `app/<name>` branch that mirrors a real
app's UI structure and applies Liquid Glass. Read [../CLAUDE.md](../CLAUDE.md)
first — its guardrails apply throughout.

## 1. Branch off `main`

```sh
git checkout main
git checkout -b app/<name>      # e.g. app/spotify, app/airbnb
```

## 2. Point Claude at the real app's source (read-only)

Tell Claude the local path to the original app's source. Claude reads it **only**
to understand structure — it never copies code or clones the repo here.

> "The source is at `~/code/realapp`. Mirror its UI structure on this branch."

## 3. Claude maps the architecture

Claude inventories:

- **Entry point** — the `App` / `UIApplicationDelegate` / `SceneDelegate`.
- **Root navigation container** — `TabView`, `NavigationStack`,
  `NavigationSplitView`, `UITabBarController`, `UINavigationController`, …
- **Screen list** — the tabs and the push/present flows under each.
- **Framework per screen** — SwiftUI, UIKit, or hybrid.

Confirm the map with the user before building.

## 4. Rebuild the skeleton

Reshape the scaffold to match the architecture:

- Same navigation container and tab/screen inventory.
- Same framework per screen (use `UIHostingController` bridging where the
  original is hybrid).
- **Placeholder views with mock/static data only** — no production logic,
  networking, or real data. SF Symbols and sample strings/arrays stand in for
  real content.

## 5. Apply Liquid Glass

- Start with **system adoption** — standard `TabView`, toolbars, sheets, and
  nav stacks pick up Liquid Glass automatically on iOS 26.
- Add **custom `glassEffect`** surfaces only where the design needs them.
- **Gate everything** behind `#available(iOS 26, *)` with iOS 18 fallbacks.
- See [liquid-glass-reference.md](liquid-glass-reference.md).

## 6. Build & verify

- Build and run in the simulator.
- Confirm **navigation parity** with the original (same structure/flows).
- Confirm Liquid Glass renders on an **iOS 26** simulator and falls back cleanly
  on an **iOS 18** simulator.
- Grep to confirm no real endpoints/keys/production logic were copied.

## 7. Document the branch

- Add/update the branch's own `README.md`: source app, structure reproduced,
  Liquid Glass changes applied.
- Add a row to the branch index table in the root [../README.md](../README.md).
