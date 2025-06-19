//
//  CartView.swift
//  DiscountModule
//
//  Created by Panachai Sulsaksakul on 6/18/25.
//

import SwiftUI

struct CartView: View {
    @StateObject private var cartViewModel = CartViewModel()
    @State private var showDiscountAppliedAlert: Bool = false
    @State private var newItemName: String = ""
    @State private var newItemCategory: Category = .clothing
    @State private var newItemPrice: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List(cartViewModel.itemList) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.category.rawValue.capitalized)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("฿\(item.price, specifier: "%.2f")")
                            .bold()
                    }
                }
                
                if !cartViewModel.selectedDiscounts.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Applied Discounts:")
                            .font(.headline)
                    }
                    
                    ForEach(cartViewModel.selectedDiscounts.indices, id: \.self) { index in
                        Text("• \(appliedDiscountLabel(for: cartViewModel.selectedDiscounts[index]))")
                            .font(.subheadline)
                    }
                }
                
                HStack {
                    Text("Total:")
                        .font(.title2)
                    Spacer()
                    Text("฿\(cartViewModel.finalPrice, specifier: "%.2f")")
                        .font(.title2)
                        .foregroundStyle(.green)
                }
                .padding()
                NavigationLink(destination: DiscountSelectorView(cartViewModel: cartViewModel, showDiscountAppliedAlert: $showDiscountAppliedAlert)) {
                    Text("Select Discounts")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .alert("Discount Applied", isPresented: $showDiscountAppliedAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text("Your selected discounts have been applied")
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Add Custom Item")
                        .font(.headline)

                    TextField("Item name", text: $newItemName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Price", text: $newItemPrice)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Category", selection: $newItemCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    Button("Add Item") {
                        if let price = Double(newItemPrice), !newItemName.isEmpty {

                            let item = CartItem(name: newItemName, category: newItemCategory, price: price)
                            cartViewModel.addItem(item)
                            
                            // Reset inputs
                            newItemName = ""
                            newItemPrice = ""
                            newItemCategory = .clothing
                        }
                    }
                    .padding(.top, 4)
                }
                .padding()
            }
        }
        .navigationTitle("Cart")
        
        // Might use
        //        .onAppear {
        //            //            cartViewModel.loadCartFromJSON()
        //            //            cartViewModel.loadDiscountFromJSON()
        //        }
    }
    
    //MARK: - Helper label methods
    private func appliedDiscountLabel(for campaign: DiscountCampaign) -> String {
        switch campaign {
        case .fixedAmount(let amount):
            return "Fixed Amount: ฿\(amount)"
        case .percentage(let percent):
            return "Cart Discount: \(Int(percent))%"
        case .categoryPercentage(let category, let percent):
            return "\(category.rawValue.capitalized): \(Int(percent))% Off"
        case .points(let points):
            return "Used Points: \(points)"
        case .seasonal(let threshold, let discount):
            return "฿\(Int(discount)) off every ฿\(Int(threshold))"
        }
    }
}

#Preview {
    CartView()
}
