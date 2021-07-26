//
//  Utilities.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import RxSwift

func ignoreNil<T>(x: T?) -> Observable<T> {
    return x.map { Observable.just($0) } ?? Observable.empty()
}
