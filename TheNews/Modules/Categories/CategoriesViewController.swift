//
//  CategoriesViewController.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class CategoriesViewController: UIViewController {

    var presenter: CategoriesPresenterProtocol?

    private var categories: [String] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CategoryCardCell.self,
            forCellWithReuseIdentifier: CategoryCardCell.reuseIdentifier
        )
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Categories"
        view.backgroundColor = .systemBackground
        setupLayout()
        presenter?.viewDidLoad()
    }

    private func setupLayout() {
        view.addSubview(collectionView.prepareForAutoLayout())
        collectionView.pinToSuperviewSafeArea()
    }
}

extension CategoriesViewController: CategoriesViewProtocol {
    func showCategories(_ categories: [String]) {
        self.categories = categories
        collectionView.reloadData()
    }
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCardCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryCardCell else {
            return UICollectionViewCell()
        }
        cell.configure(category: categories[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectCategory(categories[indexPath.item])
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let padding: CGFloat = 16 * 3
        let width = (collectionView.bounds.width - padding) / 2
        return CGSize(width: width, height: 150)
    }
}
