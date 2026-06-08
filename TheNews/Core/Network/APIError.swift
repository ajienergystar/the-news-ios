//
//  APIError.swift
//  TheNews
//
//  Created by Aji Prakosa on 08/06/26.
//


import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingFailed
    case serverMessage(String)
    case noInternet

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .invalidResponse:
            return "Server returned an invalid response."
        case .noData:
            return "No data received from server."
        case .decodingFailed:
            return "Failed to parse server response."
        case .serverMessage(let message):
            return message
        case .noInternet:
            return "No internet connection. Please check your network and try again."
        }
    }
}
