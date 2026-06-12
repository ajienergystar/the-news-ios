//
//  CategoriesRouter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class CategoriesRouter: CategoriesRouterProtocol {

    weak var viewController: UIViewController?
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    static func createModule(container: DIContainer) -> UIViewController {
        let view = CategoriesViewController()
        let presenter = CategoriesPresenter()
        let interactor = CategoriesInteractor()
        let router = CategoriesRouter(container: container)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }

    func navigateToSources(category: String) {
        let sourcesVC = SourcesRouter.createModule(category: category, container: container)
        viewController?.navigationController?.pushViewController(sourcesVC, animated: true)
    }
}
