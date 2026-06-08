//
//  ArticleDetailInteractor.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

final class ArticleDetailInteractor: ArticleDetailInteractorProtocol {

    weak var output: ArticleDetailInteractorOutputProtocol?

    func prepareArticle(url: URL) {
        output?.didPrepareArticle(url: url)
    }
}
