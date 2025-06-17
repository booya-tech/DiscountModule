//
//  DiscountCampaign.swift
//  DiscountModule
//
//  Created by Panachai Sulsaksakul on 6/17/25.
//

import Foundation

enum DiscountCampaign: Codable, Identifiable {
    var id: UUID { UUID() }
    
    case fixedAmount(Double)
    case percentage(Double)
    case categoryPercentage(category: Category, percent: Double)
    case points(Int)
    case seasonal(threshold: Double, discount: Double)
    
    private enum CodingKeys: String, CodingKey {
        case type, value, category, threshold, discount
    }
    
    private enum CampaignType: String, Codable {
        case fixedAmount, percentage, categoryPercentage, points, seasonal
    }
    
    // Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(CampaignType.self, forKey: .type)

        switch type {
        case .fixedAmount:
            self = .fixedAmount(try container.decode(Double.self, forKey: .value))
        case .percentage:
            self = .percentage(try container.decode(Double.self, forKey: .value))
        case .categoryPercentage:
            let category = try container.decode(Category.self, forKey: .category)
            let percent = try container.decode(Double.self, forKey: .value)
            self = .categoryPercentage(category: category, percent: percent)
        case .points:
            self = .points(try container.decode(Int.self, forKey: .value))
        case .seasonal:
            let threshold = try container.decode(Double.self, forKey: .threshold)
            let discount = try container.decode(Double.self, forKey: .discount)
            self = .seasonal(threshold: threshold, discount: discount)
        }
    }
    
    // Encoder
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .fixedAmount(let value):
            try container.encode(CampaignType.fixedAmount, forKey: .type)
            try container.encode(value, forKey: .value)
        case .percentage(let value):
            try container.encode(CampaignType.percentage, forKey: .type)
            try container.encode(value, forKey: .value)
        case .categoryPercentage(let category, let percent):
            try container.encode(CampaignType.categoryPercentage, forKey: .type)
            try container.encode(category, forKey: .category)
            try container.encode(percent, forKey: .value)
        case .points(let value):
            try container.encode(CampaignType.points, forKey: .type)
            try container.encode(value, forKey: .value)
        case .seasonal(let threshold, let discount):
            try container.encode(CampaignType.seasonal, forKey: .type)
            try container.encode(threshold, forKey: .threshold)
            try container.encode(discount, forKey: .discount)
        }
    }
}
