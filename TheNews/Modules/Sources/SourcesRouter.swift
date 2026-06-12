//
//  SourcesRouter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class SourcesRouter: SourcesRouterProtocol {

    weak var viewController: UIViewController?
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    static func createModule(category: String, container: DIContainer) -> UIViewController {
        let apiService = container.resolve(NewsAPIServiceProtocol.self)
        let view = SourcesViewController()
        view.categoryTitle = category
        let presenter = SourcesPresenter(category: category)
        let interactor = SourcesInteractor(category: category, apiService: apiService)
        let router = SourcesRouter(container: container)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }

    func navigateToArticles(sourceID: String) {
        let articlesVC = ArticlesRouter.createModule(sourceID: sourceID, container: container)
        viewController?.navigationController?.pushViewController(articlesVC, animated: true)
    }
}
