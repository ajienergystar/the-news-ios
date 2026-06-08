# TheNews

A native iOS news reader built with **Swift** and **UIKit**, powered by the [NewsAPI.org](https://newsapi.org) REST API. Browse news by category, discover sources, read paginated article feeds with endless scrolling, and open full stories in an in-app web view — with robust handling for success, empty results, offline mode, and API errors.

---

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Architecture](#architecture)
- [Navigation Flow](#navigation-flow)
- [Project Structure](#project-structure)
- [API Integration](#api-integration)
- [Dependencies](#dependencies)
- [Testing](#testing)
- [Code Quality](#code-quality)
- [Error Handling](#error-handling)
- [Contributing](#contributing)
- [License](#license)

---

## Features

### Browse & Discover

- **Category grid** — Seven curated categories: Business, Entertainment, General, Health, Science, Sports, and Technology.
- **Source listing** — Fetches all news sources for a selected category from NewsAPI and displays them in a searchable table view.
- **Article feed** — Paginated headlines per source with thumbnail images, titles, descriptions, and publication dates.

### Search

- **Source search** — Client-side filtering by source name as you type.
- **Article search** — Server-side headline search via the NewsAPI `/everything` endpoint, with a 300 ms debounce to reduce unnecessary network calls.

### Pagination & Scrolling

- **Endless scrolling** — Automatically loads the next page when the user reaches the bottom of the list.
- **Articles** — Server-side pagination (20 items per page) with a `hasMore` guard to stop when fewer results are returned.
- **Sources** — Client-side pagination: all sources are fetched once, then sliced locally in pages of 20.

### Reading Experience

- **In-app web view** — Full articles open inside the app using `WKWebView`, with loading and error overlays.
- **Image loading** — Article thumbnails are loaded asynchronously via [Kingfisher](https://github.com/onevcat/Kingfisher).
- **Large navigation titles** — Native iOS navigation bar with large titles enabled throughout the app.

### State Management

- **Loading** — Full-screen activity indicator on initial fetch; footer spinner during load-more.
- **Empty state** — Friendly message when no sources or articles match the current query.
- **Error state** — User-readable error messages with a **Retry** button for recoverable failures.
- **Offline detection** — `URLError.notConnectedToInternet` is mapped to a dedicated offline message.

---

## Screenshots

> Add screenshots of the Categories, Sources, Articles, and Article Detail screens here.

| Categories | Sources | Articles | Article Detail |
|:----------:|:-------:|:--------:|:--------------:|
| _Coming soon_ | _Coming soon_ | _Coming soon_ | _Coming soon_ |

---

## Requirements

| Tool | Version |
|------|---------|
| [Xcode](https://developer.apple.com/xcode/) | 16+ |
| iOS Deployment Target | 17.6+ |
| [SwiftLint](https://github.com/realm/SwiftLint) | Latest (`brew install swiftlint`) |
| [NewsAPI](https://newsapi.org) account | Free API key required |

**Supported devices:** iPhone only (portrait).

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/ajienergystar/the-news-ios.git
cd the-news-ios
```

### 2. Install SwiftLint (recommended)

SwiftLint runs automatically as a pre-build script. Install it via Homebrew:

```bash
brew install swiftlint
```

If SwiftLint is not installed, the build will still succeed but emit a warning.

### 3. Configure your API key

See [Configuration](#configuration) below.

### 4. Open and run

1. Open `TheNews.xcodeproj` in Xcode.
2. Select an iPhone simulator or a connected device.
3. Press **⌘R** to build and run.

Xcode will resolve the Swift Package Manager dependency (Kingfisher) automatically on first build.

---

## Configuration

### NewsAPI API Key

1. Register for a free API key at [newsapi.org/register](https://newsapi.org/register).
2. Open `TheNews/Core/Constants.swift`.
3. Replace the placeholder value of `apiKey` with your own key:

```swift
enum Constants {
    static let apiKey = "YOUR_NEWSAPI_KEY_HERE"
    static let baseURL = "https://newsapi.org/v2/"
    static let pageSize = 20
    // ...
}
```

> **Security note:** Do not commit your personal API key to a public repository. The project `.gitignore` already excludes `Secrets.swift` and `.env` files if you choose to externalize credentials in the future.

### Tunable Constants

| Constant | Default | Description |
|----------|---------|-------------|
| `apiKey` | — | Your NewsAPI.org API key |
| `baseURL` | `https://newsapi.org/v2/` | NewsAPI base URL |
| `pageSize` | `20` | Number of articles/sources per page |
| `categories` | 7 categories | Static list shown on the home screen |

---

## Architecture

The app follows the **VIPER** (View – Interactor – Presenter – Entity – Router) architecture pattern. Each feature module is self-contained with protocol-based contracts, making components testable and swappable.

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│    View     │────▶│  Presenter   │────▶│ Interactor  │
│ (UIViewCtrl)│◀────│              │◀────│             │
└─────────────┘     └──────┬───────┘     └──────┬──────┘
                           │                     │
                           ▼                     ▼
                    ┌──────────────┐     ┌─────────────┐
                    │    Router    │     │   Entity    │
                    │ (Navigation) │     │  (Models)   │
                    └──────────────┘     └─────────────┘
```

### Module wiring

Each module exposes a static `createModule()` factory on its Router that wires all VIPER components together. Example from the Categories module:

```swift
static func createModule() -> UIViewController {
    let view = CategoriesViewController()
    let presenter = CategoriesPresenter()
    let interactor = CategoriesInteractor()
    let router = CategoriesRouter()

    view.presenter = presenter
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    interactor.output = presenter
    router.viewController = view

    return view
}
```

### Key design decisions

| Decision | Rationale |
|----------|-----------|
| **Programmatic UIKit** | All screens are built in code — no storyboard-driven view controllers (only `LaunchScreen.storyboard` is used). |
| **Protocol-based DI** | `NewsAPIServiceProtocol` is injected into Interactors, enabling mock-based unit tests. |
| **Swift concurrency** | `async`/`await` with `Task` and `MainActor` for network calls and UI updates. |
| **Custom Auto Layout DSL** | Reusable layout helpers (`prepareForAutoLayout()`, `pinToSuperviewSafeArea()`, etc.) reduce boilerplate. |

---

## Navigation Flow

```
Categories (UICollectionView grid)
    │
    ▼  tap category
Sources (UITableView + search bar)
    │
    ▼  tap source
Articles (UITableView + search bar)
    │
    ▼  tap article
Article Detail (WKWebView)
```

The root `UINavigationController` is created in `SceneDelegate` with the Categories module as its root view controller.

---

## Project Structure

```
the-news-ios/
├── TheNews/                        # Main application target
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── Core/
│   │   ├── Constants.swift         # API key, base URL, categories
│   │   └── Network/
│   │       ├── APIError.swift      # Typed network error enum
│   │       └── NewsAPIService.swift
│   ├── Entities/
│   │   └── Article.swift           # Article, NewsSource, response models
│   ├── Modules/
│   │   ├── Categories/             # VIPER: category grid
│   │   ├── Sources/                # VIPER: source list + search
│   │   ├── Articles/               # VIPER: article feed + search
│   │   └── ArticleDetail/          # VIPER: in-app web reader
│   ├── Components/                 # Reusable cells & state views
│   │   ├── ArticleCardCell.swift
│   │   ├── CategoryCardCell.swift
│   │   ├── SourceCell.swift
│   │   ├── SearchBarView.swift
│   │   ├── LoadingFooterView.swift
│   │   └── StateViews.swift        # Loading, Empty, Error views
│   └── Helper/                     # Auto Layout extensions
├── TheNewsTests/                   # Unit tests (Swift Testing)
│   └── Helpers/                    # Mocks, fixtures, test utilities
├── TheNewsUITests/                 # UI tests (XCTest scaffold)
├── .swiftlint.yml
└── README.md
```

### Feature modules

| Module | View | Primary UI Component |
|--------|------|----------------------|
| **Categories** | `CategoriesViewController` | `UICollectionView` (grid) |
| **Sources** | `SourcesViewController` | `UITableView` + `SearchBarView` |
| **Articles** | `ArticlesViewController` | `UITableView` + `SearchBarView` |
| **Article Detail** | `ArticleDetailViewController` | `WKWebView` |

Each module contains five files following the VIPER convention:

- `*Contract.swift` — Protocol definitions for all roles
- `*ViewController.swift` — UIViewController (passive view)
- `*Presenter.swift` — Presentation logic
- `*Interactor.swift` — Business logic & data fetching
- `*Router.swift` — Navigation & module assembly

---

## API Integration

All network requests go through `NewsAPIService`, a singleton that wraps `URLSession` with `async`/`await`.

| Method | Endpoint | Parameters |
|--------|----------|------------|
| `fetchSources(category:)` | `GET /v2/sources` | `category`, `apiKey` |
| `fetchArticles(source:page:)` | `GET /v2/everything` | `sources`, `page`, `pageSize`, `apiKey` |
| `searchArticles(query:page:)` | `GET /v2/everything` | `q`, `page`, `pageSize`, `apiKey` |

### Error mapping

`APIError` provides typed, user-facing error cases:

| Case | Trigger |
|------|---------|
| `invalidURL` | Malformed request URL |
| `invalidResponse` | Non-HTTP response |
| `noData` | Empty response body |
| `decodingFailed` | JSON decoding failure |
| `serverMessage(String)` | NewsAPI error JSON (`message` field) |
| `noInternet` | `URLError.notConnectedToInternet` |

---

## Dependencies

Managed exclusively via **Swift Package Manager** — no CocoaPods or Carthage.

| Package | Version | Purpose |
|---------|---------|---------|
| [Kingfisher](https://github.com/onevcat/Kingfisher) | 8.9.0 | Async image loading & caching for article thumbnails |

---

## Testing

### Unit Tests — `TheNewsTests`

The project uses Apple's **[Swift Testing](https://developer.apple.com/documentation/testing)** framework (`@Test`, `@Suite`) with **75+ test cases** across 13 test files.

| Test Suite | Coverage |
|------------|----------|
| `NewsAPIServiceTests` | HTTP layer via `MockURLProtocol` |
| `ArticlesInteractorTests` | Pagination, search, error propagation |
| `SourcesInteractorTests` | Fetch, client-side filter, local pagination |
| `ArticlesPresenterTests` | Presentation logic, navigation triggers |
| `SourcesPresenterTests` | Presentation logic |
| `CategoriesPresenterTests` | Presentation logic |
| `CategoriesInteractorTests` | Static category list |
| `ArticleTests` | Model decoding & computed properties |
| `APIErrorTests` | Error message strings |
| `UIViewAutoLayoutTests` | Layout helper extensions |
| `UIStackViewAutoLayoutTests` | Stack view layout helpers |
| `UILayoutGuideAutoLayoutTests` | Layout guide helpers |
| `NSLayoutConstraintHelperTests` | Constraint activation helpers |

**Test helpers** in `TheNewsTests/Helpers/`:

- `MockNewsAPIService` — Protocol mock for Interactor/Presenter tests
- `MockURLProtocol` — Stubs `URLSession` for service-level tests
- `MockVIPEROutputs` — Spy mocks for VIPER output protocols
- `TestFixtures` — Shared JSON fixtures and sample models

**Run unit tests:**

```bash
# From Xcode
⌘U

# From the command line
xcodebuild test \
  -project TheNews.xcodeproj \
  -scheme TheNews \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

### UI Tests — `TheNewsUITests`

A minimal XCTest scaffold is included (launch test and performance baseline). Functional UI test coverage for navigation, search, and API flows is not yet implemented.

---

## Code Quality

### SwiftLint

SwiftLint runs automatically as a **pre-build script phase** on the `TheNews` target. Configuration lives in `.swiftlint.yml`.

**Run manually:**

```bash
swiftlint
```

**Key rules:**

| Setting | Value |
|---------|-------|
| Line length | Warning 120 / Error 200 |
| Type body length | Warning 300 / Error 400 |
| File length | Warning 500 / Error 1000 |
| Opt-in rules | `force_unwrapping`, `empty_count`, `trailing_closure`, and more |
| Reporter | `xcode` (inline warnings in Xcode) |

---

## Error Handling

The app handles four distinct UI states on every data-driven screen:

| State | View | User Action |
|-------|------|-------------|
| **Loading** | `LoadingView` (spinner) | Wait |
| **Success** | Table/Collection view with data | Browse, search, scroll |
| **Empty** | `EmptyStateView` (message) | Adjust search or go back |
| **Error** | `ErrorStateView` (message + button) | Tap **Retry** |

Errors propagate through the VIPER chain: `NewsAPIService` → `Interactor` → `Presenter` → `View`. The Presenter decides which state to show; the View is responsible only for rendering.

Concurrent fetch requests are prevented by an `isFetching` guard in `ArticlesInteractor`.

---

## Contributing

Contributions are welcome. To get started:

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes and ensure all tests pass (`⌘U`).
4. Run SwiftLint: `swiftlint`
5. Commit with a clear message and open a Pull Request.

Please do not include API keys or other secrets in your commits.

---

## License

This project does not currently include a license file. All rights reserved by the author unless otherwise specified.

---

## Acknowledgments

- [NewsAPI.org](https://newsapi.org) — News data provider
- [Kingfisher](https://github.com/onevcat/Kingfisher) — Image loading library
- [SwiftLint](https://github.com/realm/SwiftLint) — Swift style and convention linter
