//
//  DependencyScope.swift
//  TheNews
//
//  Created by Aji Prakosa on 12/06/26.
//

import Foundation

/// Defines how long a registered dependency lives inside the container.
enum DependencyScope {
    /// One shared instance for the lifetime of the container.
    case singleton
    /// A new instance is created on every resolve.
    case transient
}
