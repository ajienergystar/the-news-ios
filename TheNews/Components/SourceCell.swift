//
//  SourceCell.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class SourceCell: UITableViewCell {

    static let reuseIdentifier = "SourceCell"

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        return label
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator

        let stack = UIStackView(
            axis: .vertical,
            spacing: 4,
            arrangedSubviews: [nameLabel, detailLabel]
        )

        contentView.addSubview(stack.prepareForAutoLayout())
        stack.pinToSuperview(padding: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(source: NewsSource) {
        nameLabel.text = source.name ?? "Unknown Source"
        detailLabel.text = source.id
        detailLabel.isHidden = source.id == nil
    }
}
