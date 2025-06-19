//
//  CartViewModel.swift
//  DiscountModule
//
//  Created by Panachai Sulsaksakul on 6/17/25.
//

import SwiftUI

class CartViewModel: ObservableObject {
    @Published var itemList: [CartItem] = []
    @Published var selectedDiscounts: [DiscountCampaign] = []
    @Published var finalPrice: Double = 0.0
    
    private let calculator = DiscountCalculator()
    
    //TODO: - will support after implemented DiscountCalculator
    func calculateFinalPrice() {
        finalPrice = calculator.applyDiscounts(
            cartItems: itemList,
            campaigns: selectedDiscounts
        )
    }
    
    func addItem(_ item: CartItem) {
        itemList.append(item)
        calculateFinalPrice()
    }
    
    func setDiscounts(_ discounts: [DiscountCampaign]) {
        selectedDiscounts = discounts
        calculateFinalPrice()
    }
    
    func loadCartFromJSON() {
        if let loaded: [CartItem] = JSONLoader.load("cart", as: [CartItem].self) {
            self.itemList = loaded
            calculateFinalPrice()
        }
    }
    
    func loadDiscountFromJSON() {
        if let loaded: [DiscountCampaign] = JSONLoader.load("discounts", as: [DiscountCampaign].self) {
            self.selectedDiscounts = loaded
            calculateFinalPrice()
        }
    }
    
    func loadAvailableDiscountsFromJSON() -> [DiscountCampaign] {
        return JSONLoader.load("discounts", as: [DiscountCampaign].self) ?? []
    }
}
