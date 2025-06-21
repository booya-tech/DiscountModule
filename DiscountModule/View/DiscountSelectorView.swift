//
//  DiscountSelectorView.swift
//  DiscountModule
//
//  Created by Panachai Sulsaksakul on 6/18/25.
//

import SwiftUI

struct DiscountSelectorView: View {
    @ObservedObject var cartViewModel: CartViewModel
    @Binding var showDiscountAppliedAlert: Bool
    
    @State private var showNoSelectionAlert: Bool = false
    @State private var selectedCouponIndex: Int? = nil
    @State private var selectedOnTopIndex: Int? = nil
    @State private var selectedSeasonalIndex: Int? = nil
    @State private var loadedDiscounts: [DiscountCampaign] = []
    
    var selectedItem: CartItem?
    
    var couponOptions: [DiscountCampaign] {
        loadedDiscounts.filter {
            if case .fixedAmount = $0 { return true }
            if case .percentage = $0 { return true }
            return false
        }
    }

    var onTopOptions: [DiscountCampaign] {
        loadedDiscounts.filter {
            if case .categoryPercentage = $0 { return true }
            if case .points = $0 { return true }
            return false
        }
    }

    var seasonalOptions: [DiscountCampaign] {
        loadedDiscounts.filter {
            if case .seasonal = $0 { return true }
            return false
        }
    }
    
    // Mock Data
    //    private let couponOptions: [DiscountCampaign] = [
    //        .fixedAmount(50),
    //        .percentage(10)
    //    ]
    //
    //    private let onTopOptions: [DiscountCampaign] = [
    //        .categoryPercentage(category: .clothing, percent: 50),
    //        .points(60)
    //    ]
    //
    //    private let seasonalOptions: [DiscountCampaign] = [
    //        .seasonal(300, 40)
    //    ]
    
    var body: some View {
        Form {
            if let item = selectedItem {
                Section(header: Text("Item Info")) {
                    VStack(alignment: .leading) {
                        Text("Name: \(item.name)")
                        Text("Category: \(item.category.rawValue.capitalized)")
                        Text("Price: ฿\(item.price, specifier: "%.2f")")
                    }
                }
            }
            
            Section(header: Text("Coupon")) {
                ForEach(couponOptions.indices, id: \.self) { index in
                    HStack {
                        Text(couponLabel(for: couponOptions[index]))
                        Spacer()
                        
                        Image(systemName: selectedCouponIndex == index ? "checkmark.circle.fill" : "circle")
                    }
                    .onTapGesture {
                        selectedCouponIndex = selectedCouponIndex == index ? nil : index
                    }
                }
            }
            
            Section(header: Text("On Top")) {
                ForEach(onTopOptions.indices, id: \.self) { index in
                    HStack {
                        Text(onTopLabel(for: onTopOptions[index]))
                        Spacer()
                        Image(systemName: selectedOnTopIndex == index ? "checkmark.circle.fill" : "circle")
                    }
                    .onTapGesture {
                        selectedOnTopIndex = selectedOnTopIndex == index ? nil : index
                    }
                }
            }
            
            Section(header: Text("Seasonal")) {
                ForEach(seasonalOptions.indices, id: \.self) { index in
                    HStack {
                        Text(seasonalLabel(for: seasonalOptions[index]))
                        Spacer()
                        Image(systemName: selectedSeasonalIndex == index ? "checkmark.circle.fill" : "circle")
                    }
                    .onTapGesture {
                        selectedSeasonalIndex = selectedSeasonalIndex == index ? nil : index
                    }
                }
            }
            
            Section {
                Button("Apply Discounts") {
                    var selected: [DiscountCampaign] = []
                    
                    if let i = selectedCouponIndex { selected.append(couponOptions[i]) }
                    if let i = selectedOnTopIndex { selected.append(onTopOptions[i]) }
                    if let i = selectedSeasonalIndex { selected.append(seasonalOptions[i]) }
                    
                    if selected.isEmpty {
                        showNoSelectionAlert = true
                        return
                    }
                    
//                    cartViewModel.setDiscounts(selected)
                    if let item = selectedItem {
                        // Filter out only the category-specific discounts for this item's category
                        let filtered = selected.map { discount -> DiscountCampaign in
                            switch discount {
                            case .categoryPercentage(_, let percent):
                                return .categoryPercentage(category: item.category, percent: percent)
                            default:
                                return discount
                            }
                        }
                        cartViewModel.setDiscounts(filtered)
                    } else {
                        cartViewModel.setDiscounts(selected)
                    }
                    showDiscountAppliedAlert = true
                }
                .foregroundStyle(Color.blue)
            }
        }
        .foregroundStyle(Color("FontColor"))
        .navigationTitle("Discounts")
        .alert("No Discount Selected", isPresented: $showNoSelectionAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Plese select at least one discount to apply.")
        }
        
        
        Text("Final Price: ฿\(cartViewModel.finalPrice, specifier: "%.2f")")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundStyle(.green)
            .padding(.top)
        
        .onAppear {
            loadedDiscounts = cartViewModel.loadAvailableDiscountsFromJSON()
        }
    }
    
    //MARK: - Helper label methods
    private func couponLabel(for campaign: DiscountCampaign) -> String {
        switch campaign {
        case .fixedAmount(let amount):
            return "Fixed Amount - \(Int(amount)) THB"
        case .percentage(let percent):
            return "\(Int(percent))% Off Cart"
        default: return "Unknown"
        }
    }
    
    private func onTopLabel(for campaign: DiscountCampaign) -> String {
        switch campaign {
        case .categoryPercentage(let category, let percent):
            if let item = selectedItem {
                return "\(Int(percent))% Off \(item.category.rawValue.capitalized)"
            } else {
                return "\(Int(percent))% Off \(category)"
            }
        case .points(let points):
            return "Use \(points) Points"
        default: return "Unknown"
        }
    }
    
    private func seasonalLabel(for campaign: DiscountCampaign) -> String {
        switch campaign {
        case .seasonal(let threshold, let discount):
            return "\(Int(discount)) THB Off Every \(Int(threshold)) THB"
        default: return "Unknown"
        }
    }
}

#Preview {
    let mockViewModel = CartViewModel()
    mockViewModel.itemList = [
        CartItem(name: "T-Shirt", category: .clothing, price: 350),
        CartItem(name: "Hat", category: .accessories, price: 250)
    ]
    
    return NavigationView {
        VStack {
            DiscountSelectorView(
                cartViewModel: mockViewModel,
                showDiscountAppliedAlert: .constant(false),
                selectedItem: mockViewModel.itemList.first
            )
        }
    }
}
