//
//  NetworkUrl.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import Foundation

protocol UrlBuilderProtocol {}

// MARK: - Countries List

class CountriesListUrlBuilder: UrlBuilderProtocol {
    static let shared = CountriesListUrlBuilder()
    
    private var urlComponents = URLComponents()
    
    private init() {
        urlComponents.scheme = "https"
        urlComponents.host = "restcountries.eu"
        urlComponents.path = "/rest/v2/"
    }
    
    func makeUrl() -> URL {
        urlComponents.path += "all"
        return urlComponents.url!
    }
}

// MARK: - Countries Detail

class CountriesDetailUrlBuilder: UrlBuilderProtocol {
    static let shared = CountriesDetailUrlBuilder()
    
    private var urlComponents = URLComponents()
    
    private init() {
        urlComponents.scheme = "https"
        urlComponents.host = "en.wikipedia.org"
        urlComponents.path = "/w/index.php"
    }
    
    func makeUrl(for searchText: String) -> URL {
        urlComponents.queryItems = [URLQueryItem(name: "search", value: searchText)]
        return urlComponents.url!
    }
}
