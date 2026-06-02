# Liquid Glass Playground

A sandbox for experimenting with Apple's **[Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/liquid-glass)**
(the iOS 26 design system) on the *shapes* of existing apps — without touching any
of their production code.

## Who this is for

- **iOS developers** — fork a branch that mirrors a real app's UI architecture and
  try Liquid Glass effects against a faithful skeleton.
- **Designers** — use Claude Code with plain-language requests to experiment on
  those same skeletons ("make the tab bar glass", "try a floating glass toolbar
  on the profile screen").

## Running it (no Xcode experience needed)

You don't need to know Xcode or write any code — Claude Code drives it for you.

1. **Install Xcode 26+** from the [Mac App Store](https://apps.apple.com/app/xcode/id497799835), open it once, and let it finish installing components. This is the only prerequisite.
2. **Open this folder in Claude Code.**
3. **Ask in plain language**, for example:
   > Build and run the app in the iPhone simulator and show me a screenshot.

   Claude will pick an available simulator, build the `LiquidGlassPlayground`
   scheme, launch it, and screenshot it. From there you can ask for changes
   ("make the tab bar glass", "try a floating glass toolbar on the profile
   screen") and have it rebuild.

To see real app UI rather than the bare scaffold, switch to an `app/<name>`
branch first — just ask Claude to "switch to the `app/blood` branch".

## How the repo works

| Branch          | Contents                                                                 |
| --------------- | ------------------------------------------------------------------------ |
| `main`          | A bare, runnable empty SwiftUI app + these docs. The fork point.         |
| `app/<name>`    | One branch per experimented app. Mirrors the real app's UI structure (tab vs nav, SwiftUI/UIKit/hybrid, screen hierarchy) with **placeholder screens and mock data only** — Liquid Glass applied. |

Each `app/<name>` branch reproduces the *structure* of a real app. It never
contains production code, business logic, secrets, networking, analytics, or real
data — only enough scaffolding to feel like the app so Liquid Glass can be tried
against it.

## Branch index

| Branch | Source app | Navigation | Framework | Notes |
| ------ | ---------- | ---------- | --------- | ----- |
| `main` | —          | —          | SwiftUI   | Empty scaffold + docs |
| `app/blood` | Blood (American Red Cross) | Tab-based (3 tabs) | Hybrid (UIKit shell + SwiftUI) | Tabs-shell skeleton. See [docs/blood-branch.md](docs/blood-branch.md) |

## Starting a new app branch

See **[docs/app-branch-workflow.md](docs/app-branch-workflow.md)** for the
repeatable recipe. In short: branch off `main`, point Claude at the real app's
source (read-only), let it rebuild the UI skeleton with mock data, then apply
Liquid Glass.

## Conventions

- Repo rules Claude follows on every branch: **[CLAUDE.md](CLAUDE.md)**
- Liquid Glass API cheat-sheet + iOS 18 fallback pattern:
  **[docs/liquid-glass-reference.md](docs/liquid-glass-reference.md)**

## Requirements

- Xcode 26+ (for Liquid Glass APIs)
- Minimum deployment target: **iOS 18.0** — Liquid Glass APIs are gated behind
  `#available(iOS 26, *)` with graceful fallbacks on earlier versions.
