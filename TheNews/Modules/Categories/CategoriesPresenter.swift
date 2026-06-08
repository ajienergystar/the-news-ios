//
//  CategoriesPresenter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

final class CategoriesPresenter: CategoriesPresenterProtocol {

    weak var view: CategoriesViewProtocol?
    var interactor: CategoriesInteractorProtocol?
    var router: CategoriesRouterProtocol?

    func viewDidLoad() {
        interactor?.fetchCategories()
    }

    func didSelectCategory(_ category: String) {
        router?.navigateToSources(category: category)
    }
}

extension CategoriesPresenter: CategoriesInteractorOutputProtocol {
    func didFetchCategories(_ categories: [String]) {
        view?.showCategories(categories)
    }
}
