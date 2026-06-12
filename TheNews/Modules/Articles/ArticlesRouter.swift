//
//  ArticlesRouter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class ArticlesRouter: ArticlesRouterProtocol {

    weak var viewController: UIViewController?
    private let container: DIContainer

    init(container: DIContainer) {
        self.container = container
    }

    static func createModule(sourceID: String, container: DIContainer) -> UIViewController {
        let apiService = container.resolve(NewsAPIServiceProtocol.self)
        let view = ArticlesViewController()
        let presenter = ArticlesPresenter()
        let interactor = ArticlesInteractor(sourceID: sourceID, apiService: apiService)
        let router = ArticlesRouter(container: container)

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }

    func navigateToArticleDetail(url: URL, title: String) {
        let detailVC = ArticleDetailRouter.createModule(url: url, title: title, container: container)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
