//
//  ArrayResource.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import Foundation
import RxSwift

struct ArrayResource<T: Decodable> {
    
    let objectType = [T].self
    var action: ApiAction
    
    func parse(_ data: Data) -> Observable<[T]> {
        return Observable.create { observer in
            
            guard let result = try? JSONDecoder().decode(objectType, from: data) else {
                observer.onError(CustomError(value: "JSON Decoding Error!"))
                return Disposables.create()
            }
            
            if let responseModel = result as? ResponseModel, responseModel.status ?? false {
                observer.onError(CustomError(value: responseModel.message))
            }
            observer.onNext(result)
            return Disposables.create()
        }
    }
}
