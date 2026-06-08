//
//  SearchBarView.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

protocol SearchBarViewDelegate: AnyObject {
    func searchBar(_ searchBar: SearchBarView, textDidChange text: String)
    func searchBarDidCancel(_ searchBar: SearchBarView)
}

final class SearchBarView: UIView {

    weak var delegate: SearchBarViewDelegate?

    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Search..."
        field.borderStyle = .none
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .search
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        return field
    }()

    private let magnifierIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.isHidden = true
        return button
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var contentStack = UIStackView(
        axis: .horizontal,
        spacing: 8,
        alignment: .center,
        arrangedSubviews: [containerView, cancelButton]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(contentStack.prepareForAutoLayout())
        contentStack.pinToSuperview()

        containerView.addSubviews(magnifierIcon, textField)

        magnifierIcon.prepareForAutoLayout()
            .constrainSize(width: 20, height: 20)
        magnifierIcon.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        magnifierIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true

        textField.prepareForAutoLayout()
        textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        textField.placeTrailing(to: magnifierIcon, spacing: 8)
        textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
        textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true

        cancelButton.setContentHuggingPriority(.required, for: .horizontal)
        cancelButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        textField.delegate = self
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
    }

    @objc private func textChanged() {
        delegate?.searchBar(self, textDidChange: textField.text ?? "")
    }

    @objc private func cancelTapped() {
        textField.text = ""
        textField.resignFirstResponder()
        cancelButton.isHidden = true
        delegate?.searchBarDidCancel(self)
        delegate?.searchBar(self, textDidChange: "")
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        cancelButton.isHidden = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
