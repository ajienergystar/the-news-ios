//
//  SourcesRouter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class SourcesRouter: SourcesRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule(category: String) -> UIViewController {
        let view = SourcesViewController()
        view.categoryTitle = category
        let presenter = SourcesPresenter(category: category)
        let interactor = SourcesInteractor(category: category)
        let router = SourcesRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }

    func navigateToArticles(sourceID: String) {
        let articlesVC = ArticlesRouter.createModule(sourceID: sourceID)
        viewController?.navigationController?.pushViewController(articlesVC, animated: true)
    }
}
