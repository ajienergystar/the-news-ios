//
//  UIViewAutoLayoutTests.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
import UIKit
@testable import TheNews

@Suite(.serialized)
@MainActor
struct UIViewAutoLayoutTests {

    @Test func prepareForAutoLayout_disablesTranslatesAutoresizingMask() {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true

        let result = view.prepareForAutoLayout()

        #expect(result === view)
        #expect(view.translatesAutoresizingMaskIntoConstraints == false)
    }

    @Test func addSubviews_addsAllViewsToHierarchy() {
        let container = UIView()
        let first = UIView()
        let second = UIView()
        let third = UIView()

        container.addSubviews(first, second, third)

        #expect(container.subviews.count == 3)
        #expect(container.subviews.contains(first))
        #expect(container.subviews.contains(second))
        #expect(container.subviews.contains(third))
    }

    @Test func pinToSuperview_pinsAllEdgesWithPadding() {
        let (superview, child) = AutoLayoutTestHelpers.makeViewHierarchy()
        let padding = UIEdgeInsets(top: 16, left: 20, bottom: 24, right: 12)

        let constraints = child.pinToSuperview(padding: padding)

        #expect(constraints.count == 4)
        #expect(constraints.allSatisfy { $0.isActive })

        let top = AutoLayoutTestHelpers.findConstraint(
            in: constraints,
            firstItem: child,
            secondItem: superview,
            firstAttribute: .top,
            secondAttribute: .top
        )
        #expect(top?.constant == 16)

        let bottom = AutoLayoutTestHelpers.findConstraint(
            in: constraints,
            firstItem: child,
            secondItem: superview,
            firstAttribute: .bottom,
            secondAttribute: .bottom
        )
        #expect(bottom?.constant == -24)

        let leading = AutoLayoutTestHelpers.findConstraint(
            in: constraints,
            firstItem: child,
            secondItem: superview,
            firstAttribute: .leading,
            secondAttribute: .leading
        )
        #expect(leading?.constant == 20)

        let trailing = AutoLayoutTestHelpers.findConstraint(
            in: constraints,
            firstItem: child,
            secondItem: superview,
            firstAttribute: .trailing,
            secondAttribute: .trailing
        )
        #expect(trailing?.constant == -12)
    }

    @Test func pinToSuperview_pinsSelectedEdgesOnly() {
        let (superview, child) = AutoLayoutTestHelpers.makeViewHierarchy()

        let constraints = child.pinToSuperview(edges: [.top, .left])

        #expect(constraints.count == 2)
        #expect(
            AutoLayoutTestHelpers.findConstraint(
                in: constraints,
                firstItem: child,
                secondItem: superview,
                firstAttribute: .top,
                secondAttribute: .top
            ) != nil
        )
        #expect(
            AutoLayoutTestHelpers.findConstraint(
                in: constraints,
                firstItem: child,
                secondItem: superview,
                firstAttribute: .leading,
                secondAttribute: .leading
            ) != nil
        )
    }

    @Test func pinToSuperviewSafeArea_pinsToSafeAreaGuide() {
        let (superview, child) = AutoLayoutTestHelpers.makeViewHierarchy()
        let guide = superview.safeAreaLayoutGuide

        let constraints = child.pinToSuperviewSafeArea()

        #expect(constraints.count == 4)
        #expect(
            AutoLayoutTestHelpers.findConstraint(
                in: constraints,
                firstItem: child,
                secondItem: guide,
                firstAttribute: .top,
                secondAttribute: .top
            ) != nil
        )
    }

    @Test func centerInSuperview_createsCenterConstraints() {
        let (superview, child) = AutoLayoutTestHelpers.makeViewHierarchy()
        let offset = CGPoint(x: 10, y: -5)

        let constraints = child.centerInSuperview(offset: offset)

        #expect(constraints.count == 2)
        #expect(constraints.allSatisfy { $0.isActive })

        let centerX = AutoLayoutTestHelpers.findConstraint(
            in: constraints,
            firstItem: child,
            secondItem: superview,
            firstAttribute: .centerX,
            secondAttribute: .centerX
        )
        #expect(centerX?.constant == 10)

        let centerY = AutoLayoutTestHelpers.findConstraint(
            in: constraints,
            firstItem: child,
            secondItem: superview,
            firstAttribute: .centerY,
            secondAttribute: .centerY
        )
        #expect(centerY?.constant == -5)
    }

    @Test func constrainSize_setsWidthAndHeight() {
        let view = UIView().prepareForAutoLayout()

        let constraints = view.constrainSize(width: 120, height: 80)

        #expect(constraints.count == 2)
        #expect(constraints.contains { $0.firstAttribute == .width && $0.constant == 120 })
        #expect(constraints.contains { $0.firstAttribute == .height && $0.constant == 80 })
    }

    @Test func constrainSize_setsOnlyProvidedDimensions() {
        let view = UIView().prepareForAutoLayout()

        let widthOnly = view.constrainSize(width: 200)
        #expect(widthOnly.count == 1)
        #expect(widthOnly.first?.firstAttribute == .width)

        let heightOnly = view.constrainSize(height: 44)
        #expect(heightOnly.count == 1)
        #expect(heightOnly.first?.firstAttribute == .height)
    }

    @Test func constrainAspectRatio_setsWidthToHeightMultiplier() {
        let view = UIView().prepareForAutoLayout()

        let constraint = view.constrainAspectRatio(1.5)

        #expect(constraint.isActive)
        #expect(constraint.multiplier == 1.5)
        #expect(constraint.firstAttribute == .width)
        #expect(constraint.secondAttribute == .height)
    }

    @Test func align_createsConstraintForEachAttribute() {
        let container = UIView()
        let reference = UIView().prepareForAutoLayout()
        let target = UIView().prepareForAutoLayout()
        container.addSubviews(reference, target)
        let attributes: [UIView.LayoutAttribute] = [.top, .bottom, .leading, .trailing, .centerX, .centerY]

        for attribute in attributes {
            let constraint = target.align(with: reference, attribute: attribute, constant: 8)
            #expect(constraint.isActive)
            #expect(constraint.constant == 8)
        }
    }

    @Test func placeBelow_linksTopToReferenceBottom() {
        let container = UIView()
        let above = UIView().prepareForAutoLayout()
        let below = UIView().prepareForAutoLayout()
        container.addSubviews(above, below)

        let constraint = below.placeBelow(above, spacing: 12)

        #expect(constraint.isActive)
        #expect(constraint.constant == 12)
        #expect(constraint.firstItem as? UIView === below)
        #expect(constraint.secondItem as? UIView === above)
        #expect(constraint.firstAttribute == .top)
        #expect(constraint.secondAttribute == .bottom)
    }

    @Test func placeTrailing_linksLeadingToReferenceTrailing() {
        let container = UIView()
        let leading = UIView().prepareForAutoLayout()
        let trailing = UIView().prepareForAutoLayout()
        container.addSubviews(leading, trailing)

        let constraint = trailing.placeTrailing(to: leading, spacing: 16)

        #expect(constraint.isActive)
        #expect(constraint.constant == 16)
        #expect(constraint.firstItem as? UIView === trailing)
        #expect(constraint.secondItem as? UIView === leading)
        #expect(constraint.firstAttribute == .leading)
        #expect(constraint.secondAttribute == .trailing)
    }
}
