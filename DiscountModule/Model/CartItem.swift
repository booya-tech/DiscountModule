//
//  CartItem.swift
//  DiscountModule
//
//  Created by Panachai Sulsaksakul on 6/17/25.
//

import Foundation

struct CartItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let category: Category
    let price: Double
}
