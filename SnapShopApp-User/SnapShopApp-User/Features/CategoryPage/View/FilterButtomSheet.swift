//
//  FilterButtomSheet.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct FilterBottomSheet: View {
    @AppStorage("selectedOption") private var selectedOption: String = "ALL"
    @AppStorage("selectedCollection") private var selectedCollection: String = "ALL"
    @StateObject var viewModel: CategoryViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Filter By ").font(.title)
            HStack{
                Text("ALL")
                    .foregroundColor(selectedOption == "ALL" ? .red : .black)
                Spacer()
            }.padding()
            .onTapGesture {
                selectedOption = "ALL"
                viewModel.fetchProducts()
                viewModel.filterProducts(selectedCategory: selectedOption, selectedCollection: selectedCollection)
                dismiss()
            }
            
            HStack{
                Text("T-SHIRTS")
                    .foregroundColor(selectedOption == "T-SHIRTS" ? .red : .black)
                Spacer()
            }.padding()
            .onTapGesture {
                selectedOption = "T-SHIRTS"
                viewModel.filterProducts(selectedCategory: selectedOption, selectedCollection: selectedCollection)
                dismiss()
            }
            
            HStack{
                Text("ACCESSORIES")
                    .foregroundColor(selectedOption == "ACCESSORIES" ? .red : .black)
                Spacer()
            }.padding()
            .onTapGesture {
                selectedOption = "ACCESSORIES"
                viewModel.filterProducts(selectedCategory: selectedOption, selectedCollection: selectedCollection)
                dismiss()
            }
            
            HStack{
                Text("SHOES")
                    .foregroundColor(selectedOption == "SHOES" ? .red : .black)
                Spacer()
            }.padding()
            .onTapGesture {
                selectedOption = "SHOES"
                viewModel.filterProducts(selectedCategory: selectedOption, selectedCollection: selectedCollection)
                dismiss()
            }
        }
    }
}

struct FilterBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilterBottomSheet(viewModel: CategoryViewModel())
    }
}
