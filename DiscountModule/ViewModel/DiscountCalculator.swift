//
//  DiscountCalculator.swift
//  DiscountModule
//
//  Created by Panachai Sulsaksakul on 6/17/25.
//

import Foundation

class DiscountCalculator {
    func applyDiscounts(cartItems: [CartItem], campaigns: [DiscountCampaign]) -> Double {
        // Caculate total price from items in cardItems
        var total = cartItems.reduce(0) { $0 + $1.price }
        
        //MARK: - Seperate campaigns by type
        // Coupon
        let coupon = campaigns.first(where: {
            if case .fixedAmount = $0 { return true }
            if case .percentage = $0 { return true }
            
            return false
        })
        // On Top
        let onTop = campaigns.first(where: {
            if case .categoryPercentage = $0 { return true }
            if case .points = $0 { return true }
            
            return false
        })
        // Seasonal
        let seasonal = campaigns.first(where: {
            if case .seasonal = $0 { return true }
            
            return false
        })
        
        //MARK: - Apply Coupon
        /// Description
        /// Campaigns => Fixed Amount and Percentage Discount
        switch coupon {
        case .fixedAmount(let amount):
            total -= amount
        case .percentage(let percent):
            total -= total * (percent / 100)
        default:
            break
        }
        
        //MARK: - Apply On Top
        /// Description
        /// Campaigns => Percentage discount by item category and Discount by points
        switch onTop {
        case .categoryPercentage(let category, let percent):
            let categoryDiscount = cartItems
                .filter { $0.category == category }
                .reduce(0) { $0 + $1.price } * (percent / 100)
            
            total -= categoryDiscount
        case .points(let points):
            // Capped discount at 20% of total price
            let maxDiscount = total * 0.20
            
            total -= min(Double(points), maxDiscount)
        default:
            break
        }
        
        //MARK: - Apply Seasonal
        /// Description
        /// Campaigns => Special campaigns
        switch seasonal {
        case .seasonal(let threshold, let discount):
            let multiples = Int(total / threshold)
            let totalDiscount = Double(multiples) * discount
            
            total -= totalDiscount
        default:
            break
        }
        
        // never return negative value
        return max(total, 0)
    }
}
