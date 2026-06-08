//
//  ArticleCardCell.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit
import Kingfisher

final class ArticleCardCell: UITableViewCell {

    static let reuseIdentifier = "ArticleCardCell"

    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()

    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemBlue
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(cardView.prepareForAutoLayout())
        cardView.pinToSuperview(padding: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))

        let metaStack = UIStackView(
            axis: .horizontal,
            spacing: 8,
            alignment: .center,
            arrangedSubviews: [sourceLabel, dateLabel]
        )
        dateLabel.setContentHuggingPriority(.required, for: .horizontal)

        let stack = UIStackView(
            axis: .vertical,
            spacing: 8,
            arrangedSubviews: [articleImageView, titleLabel, descriptionLabel, metaStack]
        )

        cardView.addSubview(stack.prepareForAutoLayout())
        stack.pinToSuperview(padding: UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        articleImageView.constrainSize(height: 180)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.kf.cancelDownloadTask()
        articleImageView.image = nil
    }

    func configure(article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        descriptionLabel.isHidden = article.description == nil
        sourceLabel.text = article.source.name
        dateLabel.text = article.formattedDate

        if let imageURL = article.imageURL {
            articleImageView.isHidden = false
            articleImageView.kf.setImage(with: imageURL)
        } else {
            articleImageView.isHidden = true
            articleImageView.image = nil
        }
    }
}
