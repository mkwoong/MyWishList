//
//  Product.swift
//  MyWishList
//
//  Created by 문기웅 on 4/18/24.
//

import Foundation

struct Products: Decodable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let thumbnail: URL
}
