//
//  User.swift
//  INNOCV
//
//  Created by Alex on 10/10/22.
//

import Foundation

struct User: Decodable, Encodable, Hashable {
    let birthdate: Date
    let id: Int
    let name: String
}
