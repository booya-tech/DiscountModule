//
//  Category.swift
//  DiscountModule
//
//  Created by Panachai Sulsaksakul on 6/17/25.
//

import Foundation

enum Category: String, CaseIterable, Codable, Identifiable {
    case clothing, accessories, electronics
    
    var id: String { self.rawValue }
}
