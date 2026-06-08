//
//  CategoriesInteractorTests.swift
//  TheNewsTests
//  
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
@testable import TheNews

struct CategoriesInteractorTests {

    @Test func fetchCategories_returnsAllConstantsCategories() {
        let output = MockCategoriesInteractorOutput()
        let interactor = CategoriesInteractor()
        interactor.output = output

        interactor.fetchCategories()

        #expect(output.fetchedCategories == Constants.categories)
        #expect(output.fetchedCategories.count == 7)
        #expect(output.fetchedCategories.contains("technology"))
        #expect(output.fetchedCategories.contains("business"))
    }
}
