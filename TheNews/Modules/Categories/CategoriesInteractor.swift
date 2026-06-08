//
//  CategoriesInteractor.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

final class CategoriesInteractor: CategoriesInteractorProtocol {

    weak var output: CategoriesInteractorOutputProtocol?

    func fetchCategories() {
        output?.didFetchCategories(Constants.categories)
    }
}
