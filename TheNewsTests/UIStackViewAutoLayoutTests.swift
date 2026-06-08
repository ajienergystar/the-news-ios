//
//  UIStackViewAutoLayoutTests.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
import UIKit
@testable import TheNews

@Suite(.serialized)
@MainActor
struct UIStackViewAutoLayoutTests {

    @Test func convenienceInit_configuresStackView() {
        let label = UILabel()
        let button = UIButton()

        let stack = UIStackView(
            axis: .vertical,
            spacing: 12,
            alignment: .leading,
            distribution: .fillEqually,
            arrangedSubviews: [label, button]
        )

        #expect(stack.axis == .vertical)
        #expect(stack.spacing == 12)
        #expect(stack.alignment == .leading)
        #expect(stack.distribution == .fillEqually)
        #expect(stack.arrangedSubviews.count == 2)
        #expect(stack.translatesAutoresizingMaskIntoConstraints == false)
    }

    @Test func addArrangedSubviews_addsAllViews() {
        let stack = UIStackView(axis: .horizontal)
        let first = UIView()
        let second = UIView()

        stack.addArrangedSubviews(first, second)

        #expect(stack.arrangedSubviews.count == 2)
        #expect(stack.arrangedSubviews[0] === first)
        #expect(stack.arrangedSubviews[1] === second)
    }

    @Test func removeAllArrangedSubviews_clearsStack() {
        let stack = UIStackView(axis: .vertical, arrangedSubviews: [UIView(), UIView(), UIView()])

        stack.removeAllArrangedSubviews()

        #expect(stack.arrangedSubviews.isEmpty)
        #expect(stack.subviews.isEmpty)
    }

    @Test func paddedContainer_wrapsViewWithInsets() {
        let inner = UIView()
        let insets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

        let container = UIStackView.paddedContainer(around: inner, insets: insets)

        #expect(container.subviews.count == 1)
        #expect(container.subviews.first === inner)
        #expect(inner.translatesAutoresizingMaskIntoConstraints == false)

        let constraints = container.constraints.filter { $0.isActive }
        #expect(constraints.count >= 4)
    }
}
