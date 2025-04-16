//
//  TokenEntity.swift
//  Damirka.Space
//
//  Created by Dam1rka on 16.01.2024.
//

import Foundation


struct TokenEntity: Codable, Hashable {
    let accessToken: String
    let refreshToken: String
    let scope: String
    let tokenType: String
    let expiresIn: Int
}
