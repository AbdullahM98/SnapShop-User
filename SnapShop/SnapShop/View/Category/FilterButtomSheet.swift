//
//  FilterButtomSheet.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

//
//  FilterBottomSheet.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct FilterBottomSheet: View {
    @AppStorage("selectedOption") private var selectedOption: String = "ALL"
    @ObservedObject var viewModel: HomeViewModel
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
                dismiss()
            }
            
            HStack{
                Text("T-SHIRTS")
                    .foregroundColor(selectedOption == "T-SHIRTS" ? .red : .black)
                Spacer()
            }.padding()
            .onTapGesture {
                selectedOption = "T-SHIRTS"
                viewModel.fetchProductsByCategory(category: selectedOption)
                dismiss()
            }
            
            HStack{
                Text("ACCESSORIES")
                    .foregroundColor(selectedOption == "ACCESSORIES" ? .red : .black)
                Spacer()
            }.padding()
            .onTapGesture {
                selectedOption = "ACCESSORIES"
                viewModel.fetchProductsByCategory(category: selectedOption)
                dismiss()
            }
            
            HStack{
                Text("SHOES")
                    .foregroundColor(selectedOption == "SHOES" ? .red : .black)
                Spacer()
            }.padding()
            .onTapGesture {
                selectedOption = "SHOES"
                viewModel.fetchProductsByCategory(category: selectedOption)
                dismiss()
            }
        }
    }
}

struct FilterBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        FilterBottomSheet(viewModel: HomeViewModel())
    }
}
