//
//  NSLayoutConstraint+Helper.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

extension NSLayoutConstraint {

    /// Activates the constraint and returns itself for chaining.
    @discardableResult
    func activated() -> NSLayoutConstraint {
        isActive = true
        return self
    }

    /// Deactivates the constraint and returns itself for chaining.
    @discardableResult
    func deactivated() -> NSLayoutConstraint {
        isActive = false
        return self
    }

    /// Sets the constraint priority.
    @discardableResult
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }

    /// Sets the constraint identifier (useful for debugging in Xcode).
    @discardableResult
    func identified(as identifier: String) -> NSLayoutConstraint {
        self.identifier = identifier
        return self
    }
}

extension Array where Element == NSLayoutConstraint {

    /// Activates a group of constraints at once.
    func activate() {
        guard !isEmpty else { return }
        NSLayoutConstraint.activate(self)
    }

    /// Deactivates a group of constraints at once.
    func deactivate() {
        guard !isEmpty else { return }
        NSLayoutConstraint.deactivate(self)
    }
}

extension UILayoutPriority {

    static let almostRequired = UILayoutPriority(999)
    static let low = UILayoutPriority(250)
    static let high = UILayoutPriority(750)
}
