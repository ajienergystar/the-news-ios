//
//  CategoryCardCell.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class CategoryCardCell: UICollectionViewCell {

    static let reuseIdentifier = "CategoryCardCell"

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.15)
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBlue.cgColor
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cardView.prepareForAutoLayout())
        cardView.pinToSuperview()

        let stack = UIStackView(
            axis: .vertical,
            spacing: 12,
            alignment: .center,
            arrangedSubviews: [iconView, titleLabel]
        )
        cardView.addSubview(stack.prepareForAutoLayout())
        stack.pinToSuperview(padding: UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12))
        iconView.constrainSize(width: 40, height: 40)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(category: String) {
        titleLabel.text = category.capitalized
        iconView.image = UIImage(systemName: iconName(for: category))
    }

    private func iconName(for category: String) -> String {
        switch category {
        case "business": return "briefcase"
        case "entertainment": return "film"
        case "general": return "newspaper"
        case "health": return "heart"
        case "science": return "flask"
        case "sports": return "sportscourt"
        case "technology": return "desktopcomputer"
        default: return "questionmark"
        }
    }
}
