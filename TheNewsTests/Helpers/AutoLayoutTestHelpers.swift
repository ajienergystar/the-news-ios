//
//  AutoLayoutTestHelpers.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import UIKit
@testable import TheNews

enum AutoLayoutTestHelpers {

    static func makeViewHierarchy(
        superviewSize: CGSize = CGSize(width: 375, height: 812)
    ) -> (superview: UIView, child: UIView) {
        let superview = UIView(frame: CGRect(origin: .zero, size: superviewSize))
        let child = UIView()
        superview.addSubview(child.prepareForAutoLayout())
        return (superview, child)
    }

    static func makeLayoutGuide(in owningView: UIView) -> UILayoutGuide {
        let guide = UILayoutGuide()
        owningView.addLayoutGuide(guide)
        return guide
    }

    static func findConstraint(
        in constraints: [NSLayoutConstraint],
        firstItem: AnyObject,
        secondItem: AnyObject,
        firstAttribute: NSLayoutConstraint.Attribute,
        secondAttribute: NSLayoutConstraint.Attribute
    ) -> NSLayoutConstraint? {
        constraints.first { constraint in
            constraint.isActive
                && (constraint.firstItem as AnyObject?) === firstItem
                && (constraint.secondItem as AnyObject?) === secondItem
                && constraint.firstAttribute == firstAttribute
                && constraint.secondAttribute == secondAttribute
        }
    }

    static func waitUntil(
        timeout: TimeInterval = 2,
        condition: @escaping () -> Bool
    ) async {
        let deadline = Date().addingTimeInterval(timeout)
        while !condition(), Date() < deadline {
            await Task.yield()
            try? await Task.sleep(nanoseconds: 10_000_000)
        }
    }
}
