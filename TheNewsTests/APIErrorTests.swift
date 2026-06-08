//
//  APIErrorTests.swift
//  TheNewsTests
//
//  Created by Aji Prakosa on 08/06/26.
//

import Testing
@testable import TheNews

struct APIErrorTests {

    @Test func errorDescriptions_matchExpectedMessages() {
        #expect(APIError.invalidURL.errorDescription == "Invalid request URL.")
        #expect(APIError.invalidResponse.errorDescription == "Server returned an invalid response.")
        #expect(APIError.noData.errorDescription == "No data received from server.")
        #expect(APIError.decodingFailed.errorDescription == "Failed to parse server response.")
        #expect(APIError.serverMessage("Rate limit exceeded").errorDescription == "Rate limit exceeded")
        #expect(
            APIError.noInternet.errorDescription ==
            "No internet connection. Please check your network and try again."
        )
    }
}
