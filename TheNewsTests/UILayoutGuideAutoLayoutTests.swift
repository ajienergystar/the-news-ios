//
//  UILayoutGuideAutoLayoutTests.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
import UIKit
@testable import TheNews

@Suite(.serialized)
@MainActor
struct UILayoutGuideAutoLayoutTests {

    @Test func pinToOwningView_pinsAllEdgesWithPadding() {
        let owningView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        let guide = AutoLayoutTestHelpers.makeLayoutGuide(in: owningView)
        let padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        let constraints = guide.pinToOwningView(padding: padding)

        #expect(constraints.count == 4)
        #expect(constraints.allSatisfy { $0.isActive })

        let top = AutoLayoutTestHelpers.findConstraint(
            in: constraints,
            firstItem: guide,
            secondItem: owningView,
            firstAttribute: .top,
            secondAttribute: .top
        )
        #expect(top?.constant == 8)

        let trailing = AutoLayoutTestHelpers.findConstraint(
            in: constraints,
            firstItem: guide,
            secondItem: owningView,
            firstAttribute: .trailing,
            secondAttribute: .trailing
        )
        #expect(trailing?.constant == -16)
    }

    @Test func pinToOwningView_pinsSelectedEdgesOnly() {
        let owningView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
        let guide = AutoLayoutTestHelpers.makeLayoutGuide(in: owningView)

        let constraints = guide.pinToOwningView(edges: [.bottom, .right])

        #expect(constraints.count == 2)
        #expect(
            AutoLayoutTestHelpers.findConstraint(
                in: constraints,
                firstItem: guide,
                secondItem: owningView,
                firstAttribute: .bottom,
                secondAttribute: .bottom
            ) != nil
        )
        #expect(
            AutoLayoutTestHelpers.findConstraint(
                in: constraints,
                firstItem: guide,
                secondItem: owningView,
                firstAttribute: .trailing,
                secondAttribute: .trailing
            ) != nil
        )
    }

    @Test func pinToOwningViewSafeArea_pinsToSafeAreaGuide() {
        let owningView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        let guide = AutoLayoutTestHelpers.makeLayoutGuide(in: owningView)
        let safeArea = owningView.safeAreaLayoutGuide

        let constraints = guide.pinToOwningViewSafeArea()

        #expect(constraints.count == 4)
        #expect(
            AutoLayoutTestHelpers.findConstraint(
                in: constraints,
                firstItem: guide,
                secondItem: safeArea,
                firstAttribute: .leading,
                secondAttribute: .leading
            ) != nil
        )
    }

    @Test func constrainSize_setsWidthAndHeightForGuide() {
        let owningView = UIView()
        let guide = AutoLayoutTestHelpers.makeLayoutGuide(in: owningView)

        let constraints = guide.constrainSize(width: 200, height: 100)

        #expect(constraints.count == 2)
        #expect(constraints.allSatisfy { $0.isActive })
        #expect(constraints.contains { $0.firstAttribute == .width && $0.constant == 200 })
        #expect(constraints.contains { $0.firstAttribute == .height && $0.constant == 100 })
    }
}
