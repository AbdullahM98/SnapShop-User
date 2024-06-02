//
//  CategoryView.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct CategoryView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State var isPresented : Bool = false
    @State var settingsDetents = PresentationDetent.medium
    @AppStorage("selectedOption") private var selectedOption: String = "ALL"
    var body: some View {
        HStack{
            HomeSearchBar()
            Button(action: {
                isPresented.toggle()
            }, label: {
                Image(systemName: "line.horizontal.3.decrease")
                    .font(.system(size: 24, weight: .semibold))
                    .padding(.horizontal)
                    .padding(.vertical,1)
                    .foregroundColor(.black)
            })
            .sheet(isPresented: $isPresented, content: {
                FilterBottomSheet(viewModel: viewModel).presentationDetents([.medium], selection: $settingsDetents)
            })
        }      
        Divider().background(Color.black)
        FilterBar(viewModel: viewModel)
        CategoryProducts(products: viewModel.categoryProducts)
            .onDisappear {
                selectedOption = "ALL"
            }
    }
}

#Preview {
    CategoryView()
}
