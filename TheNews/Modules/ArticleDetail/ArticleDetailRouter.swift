//
//  ArticleDetailRouter.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import UIKit

final class ArticleDetailRouter: ArticleDetailRouterProtocol {

    static func createModule(url: URL, title: String) -> UIViewController {
        let view = ArticleDetailViewController()
        let presenter = ArticleDetailPresenter(url: url)
        let interactor = ArticleDetailInteractor()
        let router = ArticleDetailRouter()

        view.presenter = presenter
        view.screenTitle = title
        presenter.view = view
        presenter.interactor = interactor
        interactor.output = presenter
        _ = router

        return view
    }
}
