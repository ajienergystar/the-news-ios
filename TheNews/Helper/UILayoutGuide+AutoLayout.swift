//
//  UILayoutGuide+AutoLayout.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

extension UILayoutGuide {

    /// Pins the layout guide to the owning view's edges.
    @discardableResult
    func pinToOwningView(
        edges: UIRectEdge = .all,
        padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        guard let owningView else {
            assertionFailure("UILayoutGuide is not attached to an owning view.")
            return []
        }

        var constraints: [NSLayoutConstraint] = []

        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: owningView.topAnchor, constant: padding.top))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: owningView.bottomAnchor, constant: -padding.bottom))
        }
        if edges.contains(.left) {
            constraints.append(leadingAnchor.constraint(equalTo: owningView.leadingAnchor, constant: padding.left))
        }
        if edges.contains(.right) {
            constraints.append(trailingAnchor.constraint(equalTo: owningView.trailingAnchor, constant: -padding.right))
        }

        constraints.activate()
        return constraints
    }

    /// Pins the layout guide to the owning view's safe area.
    @discardableResult
    func pinToOwningViewSafeArea(
        edges: UIRectEdge = .all,
        padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        guard let owningView else {
            assertionFailure("UILayoutGuide is not attached to an owning view.")
            return []
        }

        let guide = owningView.safeAreaLayoutGuide
        var constraints: [NSLayoutConstraint] = []

        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: guide.topAnchor, constant: padding.top))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -padding.bottom))
        }
        if edges.contains(.left) {
            constraints.append(leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: padding.left))
        }
        if edges.contains(.right) {
            constraints.append(trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -padding.right))
        }

        constraints.activate()
        return constraints
    }

    /// Sets a fixed width and/or height for the layout guide.
    @discardableResult
    func constrainSize(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []

        if let width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }

        constraints.activate()
        return constraints
    }
}
