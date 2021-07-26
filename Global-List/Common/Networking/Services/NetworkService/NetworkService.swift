//
//  NetworkService.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import Foundation
import RxSwift
import RxAlamofire

protocol NetworkServiceProtocol {
    func load<T>(_ resource: ArrayResource<T>) -> Observable<[T]>
}

struct NetworkService: NetworkServiceProtocol {
    
    func load<T>(_ resource: ArrayResource<T>) -> Observable<[T]> where T : Decodable {
        return
            RxAlamofire
            .request(.get, resource.action.url)
            .debug()
            .responseData()
            .map { _, data in return data }
            .flatMap(resource.parse)
    }
}
