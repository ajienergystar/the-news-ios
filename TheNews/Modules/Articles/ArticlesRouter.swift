//
//  ArticlesRouter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class ArticlesRouter: ArticlesRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule(sourceID: String) -> UIViewController {
        let view = ArticlesViewController()
        let presenter = ArticlesPresenter()
        let interactor = ArticlesInteractor(sourceID: sourceID)
        let router = ArticlesRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.viewController = view

        return view
    }

    func navigateToArticleDetail(url: URL, title: String) {
        let detailVC = ArticleDetailRouter.createModule(url: url, title: title)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
