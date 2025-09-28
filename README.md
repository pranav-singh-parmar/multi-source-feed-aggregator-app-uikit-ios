# Multi-Source Feed Aggregator App (UIKit, iOS)

A modular iOS app built with **UIKit** that aggregates posts, users, comments, and images from multiple sources. The app follows **Clean Architecture** principles to ensure maintainability, testability, and scalability.

---

## Built With

- **Xcode 16.2**
- **iOS Simulator 18.2**
- **UIKit**
- Traditional approach using **DispatchQueues** for asynchronous operations

## Dependencies

- [Kingfisher 8.5.0](https://github.com/onevcat/Kingfisher) via Swift Package Manager (for async image downloading and caching)

## Features

- Fetches and displays posts, users, comments, and images.
- Supports caching for offline usage.
- Modular architecture with separate layers for:
  - API Data Source
  - Core Data Cache
  - Repository
  - UseCase
  - ViewModel
  - UIViewController
- Pagination and data aggregation from multiple sources.
- Fully unit-testable components.

---

## Architecture

The app uses **Clean Architecture**:
- **ViewController**: Displays aggregated feed to the user.
- **ViewModel**: Prepares data for the view layer.
- **UseCase**: Encapsulates business logic.
- **Repository**: Mediates between use cases and data sources.
- **Data Sources (API/CoreData)**: Handles API calls and local cache.

## Folder Structure

MultiSourceFeedAggregatorApp/
- **DataSource**:
  - **APIDataSource**: Handles API calls
  - **CacheDataSource**: Handles Cache
- **Repository**: Data aggregation layer
- **UseCase**: Business logic
- **ViewModel**: Prepares data for the view
- **Views**: UIKit views & controllers
- **Tests**: Unit tests

---

## Unit Testing
Unit tests are included in MultiSourceFeedAggregatorAppTests.
