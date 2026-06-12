//
//  DIContainer.swift
//  TheNews
//
//  Created by Aji Prakosa on 12/06/26.
//

import Foundation

/// Abstraction over the dependency container so VIPER modules can depend on
/// resolution behavior without coupling to a concrete implementation.
protocol DIContaining: AnyObject {
    func resolve<T>(_ type: T.Type) -> T
}

/// Lightweight service locator that wires shared dependencies for the app.
///
/// Dependencies are registered once at launch (see `AppDependencies`) and
/// resolved by Routers when assembling VIPER modules.
final class DIContainer: DIContaining {

    private typealias Factory = (DIContainer) -> Any

    private var factories: [ObjectIdentifier: Factory] = [:]
    private var scopes: [ObjectIdentifier: DependencyScope] = [:]
    private var singletons: [ObjectIdentifier: Any] = [:]
    /// Recursive lock allows factories to resolve other dependencies while registering.
    private let lock = NSRecursiveLock()

    // MARK: - Registration

    /// Registers a dependency factory.
    ///
    /// - Parameters:
    ///   - type: The protocol or concrete type to resolve.
    ///   - scope: `.singleton` keeps one instance; `.transient` creates a new one each time.
    ///   - factory: Closure that receives the container so dependencies can be composed.
    func register<T>(
        _ type: T.Type,
        scope: DependencyScope = .transient,
        factory: @escaping (DIContainer) -> T
    ) {
        let key = ObjectIdentifier(type)
        lock.lock()
        defer { lock.unlock() }

        factories[key] = { container in factory(container) }
        scopes[key] = scope

        if scope == .singleton {
            singletons.removeValue(forKey: key)
        }
    }

    /// Registers a pre-built instance as a singleton.
    ///
    /// Useful in unit tests when a mock should replace a production dependency.
    func registerInstance<T>(_ type: T.Type, instance: T) {
        let key = ObjectIdentifier(type)
        lock.lock()
        defer { lock.unlock() }

        factories[key] = { _ in instance }
        scopes[key] = .singleton
        singletons[key] = instance
    }

    // MARK: - Resolution

    func resolve<T>(_ type: T.Type) -> T {
        guard let instance = resolveOptional(type) else {
            fatalError("No dependency registered for \(String(describing: type))")
        }
        return instance
    }

    func resolveOptional<T>(_ type: T.Type) -> T? {
        let key = ObjectIdentifier(type)

        lock.lock()
        defer { lock.unlock() }

        guard let factory = factories[key] else { return nil }

        switch scopes[key] ?? .transient {
        case .singleton:
            if let cached = singletons[key] as? T {
                return cached
            }
            let instance = factory(self) as! T
            singletons[key] = instance
            return instance

        case .transient:
            return factory(self) as? T
        }
    }
}
