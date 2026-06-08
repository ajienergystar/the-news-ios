//
//  CategoriesPresenterTests.swift
//  TheNewsTests
//  
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
@testable import TheNews

@MainActor
struct CategoriesPresenterTests {

    @Test func viewDidLoad_fetchesCategories() {
        let presenter = CategoriesPresenter()
        let mockInteractor = MockCategoriesInteractor()
        presenter.interactor = mockInteractor

        presenter.viewDidLoad()

        #expect(mockInteractor.fetchCategoriesCalled == true)
    }

    @Test func didSelectCategory_navigatesToSources() {
        let presenter = CategoriesPresenter()
        let mockRouter = MockCategoriesRouter()
        presenter.router = mockRouter

        presenter.didSelectCategory("science")

        #expect(mockRouter.navigatedCategory == "science")
    }

    @Test func didFetchCategories_showsCategoriesOnView() {
        let presenter = CategoriesPresenter()
        let mockView = MockCategoriesView()
        presenter.view = mockView

        presenter.didFetchCategories(Constants.categories)

        #expect(mockView.displayedCategories == Constants.categories)
    }
}

private final class MockCategoriesInteractor: CategoriesInteractorProtocol {

    var fetchCategoriesCalled = false

    func fetchCategories() {
        fetchCategoriesCalled = true
    }
}
