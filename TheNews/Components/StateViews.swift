//
//  StateViews.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class LoadingView: UIView {

    private let indicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        indicator.prepareForAutoLayout()
        addSubview(indicator)
        indicator.centerInSuperview()
        indicator.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class EmptyStateView: UIView {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()

    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        addSubview(messageLabel.prepareForAutoLayout())
        messageLabel.pinToSuperview(padding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ErrorStateView: UIView {

    var onRetry: (() -> Void)?

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        return button
    }()

    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message

        let stack = UIStackView(
            axis: .vertical,
            spacing: 16,
            alignment: .center,
            arrangedSubviews: [messageLabel, retryButton]
        )

        addSubview(stack.prepareForAutoLayout())
        stack.pinToSuperview(padding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24))
        retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func retryTapped() {
        onRetry?()
    }
}
