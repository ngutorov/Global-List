//
//  CustomError.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import Foundation

struct CustomError: LocalizedError {
    let value: String?
    var localizedDescription: String? {
        return value
    }
}
