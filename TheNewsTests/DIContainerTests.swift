//
//  DIContainerTests.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 12/06/26.
//

import Testing
@testable import TheNews

struct DIContainerTests {

    @Test func resolve_returnsRegisteredSingleton() {
        let container = DIContainer()
        container.register(String.self, scope: .singleton) { _ in "shared-value" }

        let first = container.resolve(String.self)
        let second = container.resolve(String.self)

        #expect(first == "shared-value")
        #expect(second == "shared-value")
    }

    @Test func resolve_createsNewTransientInstances() {
        final class Counter {
            static var count = 0
            let id: Int

            init() {
                Counter.count += 1
                id = Counter.count
            }
        }

        Counter.count = 0

        let container = DIContainer()
        container.register(Counter.self, scope: .transient) { _ in Counter() }

        let first = container.resolve(Counter.self)
        let second = container.resolve(Counter.self)

        #expect(first.id == 1)
        #expect(second.id == 2)
    }

    @Test func registerInstance_overridesFactory() {
        let container = DIContainer()
        let mock = MockNewsAPIService()

        container.registerInstance(NewsAPIServiceProtocol.self, instance: mock)

        let resolved = container.resolve(NewsAPIServiceProtocol.self)

        #expect(resolved is MockNewsAPIService)
    }

    @Test func resolve_composesDependencies() {
        let container = AppDependencies.makeContainer()

        let apiService = container.resolve(NewsAPIServiceProtocol.self)

        #expect(apiService is NewsAPIService)
    }
}
