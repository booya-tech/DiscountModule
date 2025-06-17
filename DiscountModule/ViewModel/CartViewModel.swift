//
//  CartViewModel.swift
//  DiscountModule
//
//  Created by Panachai Sulsaksakul on 6/17/25.
//

import SwiftUI

class CartViewModel: ObservableObject {
    @Published var itemList: [CardItem] = []
    @Published var selectedDiscounts: [DiscountCampaign] = []
    @Published var finalPrice: Double = 0.0
    
    private let calculator = DiscountCalculator()
    
    //TODO: - will support after implemented DiscountCalculator
    //    func calculateDiscount() {
    //        finalPrice = calculator.applyDiscounts(
    //            cardItems: itemList,
    //            campaigns: selectedDiscounts
    //        )
    //    }
}
