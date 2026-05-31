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
| _add app branches here_ | | | | |

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
