//
//  CategoriesContract.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation
import UIKit

// MARK: - View

protocol CategoriesViewProtocol: AnyObject {
    func showCategories(_ categories: [String])
}

// MARK: - Presenter

protocol CategoriesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectCategory(_ category: String)
}

// MARK: - Interactor

protocol CategoriesInteractorProtocol: AnyObject {
    func fetchCategories()
}

protocol CategoriesInteractorOutputProtocol: AnyObject {
    func didFetchCategories(_ categories: [String])
}

// MARK: - Router

protocol CategoriesRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToSources(category: String)
}
