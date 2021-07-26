//
//  BaseModel.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import Foundation

protocol ResponseModel: Decodable {
    var code: String? { get }
    var message: String? { get }
    var errorCode: String? { get }
    var status: Bool? { get }
}
