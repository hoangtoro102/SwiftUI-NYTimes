# SwiftUI-NYTimes
This repo is a SwiftUI iOS application using the Combine framework and MVVM architecture, that interacts with the New York Times API (https://api.nytimes.com/) to display news articles. The app consists of three main screens.

The Home screen displays two sections. The first section is a search bar that allows the user to enter search terms and navigate to the Search screen. The second section displays a list of articles, including Most Viewed articles, and allows the user to select an article and navigate to the List screen.

The Search screen allows the user to enter search terms and initiate a search for articles. The screen displays the search results, which the user can select and navigate to the List screen.

The List screen displays a list of articles based on the user's selection from either the Home or Search screen. The user can select an article to view its details.

This repo follows the principles of clean architecture, utilizing separate layers for presentation, domain, and data. It also incorporates best practices for SwiftUI and Combine, including reactive programming and asynchronous data handling. With its modular and testable design, this repo provides a solid foundation for developers to build robust and scalable iOS applications using SwiftUI and Combine.

In this application, we apply [Clean Architecture for SwiftUI](https://nalexn.github.io/clean-architecture-swiftui/?utm_source=nalexn_github)

---
* MVVM Architecture for SwiftUI + Combine

## Key features
* Vanilla **SwiftUI** + **Combine** implementation
* Test coverage, including the UI using [ViewInspector](https://github.com/nalexn/ViewInspector)
* Native SwiftUI dependency injection
* Simple yet flexible networking layer built on Generics
* Designed for scalability. It can be used as a reference for building large production apps

### Links
* [Clean Architecture for SwiftUI](https://nalexn.github.io/clean-architecture-swiftui/?utm_source=nalexn_github)
* [Programmatic navigation in SwiftUI project](https://nalexn.github.io/swiftui-deep-linking/?utm_source=nalexn_github)
* [Separation of Concerns in Software Design](https://nalexn.github.io/separation-of-concerns/?utm_source=nalexn_github)

