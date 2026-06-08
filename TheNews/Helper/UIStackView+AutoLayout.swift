//
//  UIStackView+AutoLayout.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit

extension UIStackView {

    /// Creates a stack view with common configuration for programmatic layout.
    convenience init(
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0,
        alignment: UIStackView.Alignment = .fill,
        distribution: UIStackView.Distribution = .fill,
        arrangedSubviews: [UIView] = []
    ) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Adds multiple arranged subviews at once.
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }

    /// Removes all arranged subviews from the stack.
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { view in
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    /// Wraps a view in a container with the given padding insets.
    static func paddedContainer(
        around view: UIView,
        insets: UIEdgeInsets
    ) -> UIView {
        let container = UIView()
        container.addSubview(view.prepareForAutoLayout())
        view.pinToSuperview(padding: insets)
        return container
    }
}
