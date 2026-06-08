# the-news-ios

Native iOS news application powered by NewsAPI.org. Browse news categories, discover sources per category, and read paginated article feeds with endless scrolling. Open full stories in an in-app web view, search sources and headlines, and handle success, empty results, offline, and API error cases gracefully. Built with Swift and UIKit for iPhones.

## Requirements

- Xcode 16+
- iOS 18+
- [SwiftLint](https://github.com/realm/SwiftLint) (`brew install swiftlint`)

## Setup

1. Clone the repository.
2. Open `TheNews.xcodeproj` in Xcode.
3. Add your [NewsAPI](https://newsapi.org) API key (see project configuration).
4. Build and run on a simulator or device.

SwiftLint runs automatically as a build phase. To lint manually:

```bash
swiftlint
```

## Features

- Browse news by category
- View sources per category with endless scrolling
- Read paginated articles per source
- Open article details in an in-app web view
- Search sources and articles
- Error handling for offline, API, and empty states
