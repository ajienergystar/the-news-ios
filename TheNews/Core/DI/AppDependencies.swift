//
//  AppDependencies.swift
//  TheNews
//
//  Created by Aji Prakosa on 12/06/26.
//

import Foundation

/// Composition root for production dependencies.
///
/// Called once from `SceneDelegate` to build the dependency graph used by
/// every VIPER module in the app.
enum AppDependencies {

    static func makeContainer() -> DIContainer {
        let container = DIContainer()

        container.register(URLSession.self, scope: .singleton) { _ in
            .shared
        }

        container.register(NewsAPIServiceProtocol.self, scope: .singleton) { container in
            NewsAPIService(session: container.resolve(URLSession.self))
        }

        return container
    }
}
