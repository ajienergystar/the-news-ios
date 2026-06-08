//
//  NSLayoutConstraintHelperTests.swift
//  TheNewsTests
//  
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
import UIKit
@testable import TheNews

@Suite(.serialized)
@MainActor
struct NSLayoutConstraintHelperTests {

    @Test func activated_activatesConstraint() {
        let view = UIView().prepareForAutoLayout()
        let constraint = view.widthAnchor.constraint(equalToConstant: 100)

        #expect(constraint.isActive == false)

        let result = constraint.activated()

        #expect(result === constraint)
        #expect(constraint.isActive == true)
    }

    @Test func deactivated_deactivatesConstraint() {
        let view = UIView().prepareForAutoLayout()
        let constraint = view.widthAnchor.constraint(equalToConstant: 100).activated()

        let result = constraint.deactivated()

        #expect(result === constraint)
        #expect(constraint.isActive == false)
    }

    @Test func withPriority_setsPriority() {
        let view = UIView().prepareForAutoLayout()
        let constraint = view.heightAnchor.constraint(equalToConstant: 44)

        let result = constraint.withPriority(.almostRequired)

        #expect(result === constraint)
        #expect(constraint.priority == .almostRequired)
    }

    @Test func identified_setsIdentifier() {
        let view = UIView().prepareForAutoLayout()
        let constraint = view.heightAnchor.constraint(equalToConstant: 44)

        let result = constraint.identified(as: "heightConstraint")

        #expect(result === constraint)
        #expect(constraint.identifier == "heightConstraint")
    }

    @Test func arrayActivate_activatesAllConstraints() {
        let view = UIView().prepareForAutoLayout()
        let constraints = [
            view.widthAnchor.constraint(equalToConstant: 100),
            view.heightAnchor.constraint(equalToConstant: 50)
        ]

        constraints.activate()

        #expect(constraints.allSatisfy { $0.isActive })
    }

    @Test func arrayActivate_emptyArrayDoesNothing() {
        let constraints: [NSLayoutConstraint] = []
        constraints.activate()
        #expect(constraints.isEmpty)
    }

    @Test func arrayDeactivate_deactivatesAllConstraints() {
        let view = UIView().prepareForAutoLayout()
        let constraints = [
            view.widthAnchor.constraint(equalToConstant: 100),
            view.heightAnchor.constraint(equalToConstant: 50)
        ]
        constraints.activate()

        constraints.deactivate()

        #expect(constraints.allSatisfy { !$0.isActive })
    }

    @Test func layoutPriorityConstants_haveExpectedValues() {
        #expect(UILayoutPriority.almostRequired.rawValue == 999)
        #expect(UILayoutPriority.low.rawValue == 250)
        #expect(UILayoutPriority.high.rawValue == 750)
    }
}
