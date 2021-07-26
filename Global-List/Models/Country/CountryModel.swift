//
//  CountryModel.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/12/21.
//

import Foundation

struct CountryModel: Decodable, Equatable {
    let name: String
    let capital: String?
    let region: String
    let flag: String?
}
