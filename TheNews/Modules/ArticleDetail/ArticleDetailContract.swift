//
//  ArticleDetailContract.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation
import UIKit

protocol ArticleDetailViewProtocol: AnyObject {
    func loadURL(_ url: URL)
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
}

protocol ArticleDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapRetry()
}

protocol ArticleDetailInteractorProtocol: AnyObject {
    func prepareArticle(url: URL)
}

protocol ArticleDetailInteractorOutputProtocol: AnyObject {
    func didPrepareArticle(url: URL)
}

protocol ArticleDetailRouterProtocol: AnyObject {
    static func createModule(url: URL, title: String) -> UIViewController
}
