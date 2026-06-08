//
//  UIView+AutoLayout.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

extension UIView {

    /// Disables the autoresizing mask so programmatic constraints can be applied.
    @discardableResult
    func prepareForAutoLayout() -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    /// Adds multiple subviews at once.
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    /// Pins the view to the superview edges with optional padding.
    @discardableResult
    func pinToSuperview(
        edges: UIRectEdge = .all,
        padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        guard let superview else {
            assertionFailure("\(Self.self) does not have a superview.")
            return []
        }

        var constraints: [NSLayoutConstraint] = []

        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom))
        }
        if edges.contains(.left) {
            constraints.append(leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding.left))
        }
        if edges.contains(.right) {
            constraints.append(trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding.right))
        }

        constraints.activate()
        return constraints
    }

    /// Pins the view to the superview's safe area.
    @discardableResult
    func pinToSuperviewSafeArea(
        edges: UIRectEdge = .all,
        padding: UIEdgeInsets = .zero
    ) -> [NSLayoutConstraint] {
        guard let superview else {
            assertionFailure("\(Self.self) does not have a superview.")
            return []
        }

        let guide = superview.safeAreaLayoutGuide
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

    /// Centers the view within its superview.
    @discardableResult
    func centerInSuperview(offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        guard let superview else {
            assertionFailure("\(Self.self) does not have a superview.")
            return []
        }

        let constraints = [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.x),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset.y)
        ]
        constraints.activate()
        return constraints
    }

    /// Sets a fixed width and/or height.
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

    /// Sets the width-to-height aspect ratio.
    @discardableResult
    func constrainAspectRatio(_ ratio: CGFloat) -> NSLayoutConstraint {
        let constraint = widthAnchor.constraint(equalTo: heightAnchor, multiplier: ratio)
        constraint.isActive = true
        return constraint
    }

    /// Aligns a layout attribute with another view.
    @discardableResult
    func align(
        with view: UIView,
        attribute: LayoutAttribute,
        constant: CGFloat = 0
    ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint

        switch attribute {
        case .top:
            constraint = topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
        case .bottom:
            constraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
        case .leading:
            constraint = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
        case .trailing:
            constraint = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
        case .centerX:
            constraint = centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
        case .centerY:
            constraint = centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)
        }

        constraint.isActive = true
        return constraint
    }

    /// Places the view below another view with the given spacing.
    @discardableResult
    func placeBelow(_ view: UIView, spacing: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: spacing)
        constraint.isActive = true
        return constraint
    }

    /// Places the view to the trailing side of another view with the given spacing.
    @discardableResult
    func placeTrailing(to view: UIView, spacing: CGFloat = 0) -> NSLayoutConstraint {
        let constraint = leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: spacing)
        constraint.isActive = true
        return constraint
    }
}

// MARK: - LayoutAttribute

extension UIView {

    enum LayoutAttribute {
        case top
        case bottom
        case leading
        case trailing
        case centerX
        case centerY
    }
}
