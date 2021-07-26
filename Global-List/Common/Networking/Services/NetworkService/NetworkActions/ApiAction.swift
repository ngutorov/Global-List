//
//  SearchCountries.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import Alamofire

protocol ApiActionProtocol: URLRequestConvertible {
    var url: URL { get }
}

enum ApiAction: ApiActionProtocol {
    
    case loadCountriesList
    // ...
    
    var url: URL {
        switch self {
        
        case .loadCountriesList:
            return CountriesListUrlBuilder.shared.makeUrl()
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        return URLRequest(url: url)
    }
}
