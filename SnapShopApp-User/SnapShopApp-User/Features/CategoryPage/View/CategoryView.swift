//
//  CategoryView.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct CategoryView: View {
    @StateObject var viewModel = CategoryViewModel()
    @State var isPresented: Bool = false
    @State var settingsDetents = PresentationDetent.medium
    @AppStorage("selectedOption") private var selectedOption: String = "ALL"
    @AppStorage("selectedCollection") private var selectedCollection: String = "ALL"
    @AppStorage("isDarkMode") private var isDarkMode = false


    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else {
                HStack {
                    HomeSearchBar(viewModel: viewModel)
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Image(systemName: "line.horizontal.3.decrease")
                            .font(.system(size: 24, weight: .semibold))
                            .padding(.horizontal)
                            .padding(.vertical, 1)
                            .foregroundColor(isDarkMode ? Color.white : Color.black)
                    })
                    .sheet(isPresented: $isPresented, content: {
                        FilterBottomSheet(viewModel: viewModel)
                            .presentationDetents([.medium], selection: $settingsDetents)
                    })
                }
                Divider().background(isDarkMode ? Color.white : Color.black)
                FilterBar(viewModel: viewModel)
                CategoryProducts(products: viewModel.filteredProducts)
            }
        }
        .padding(.bottom,60)
        .onAppear {
            viewModel.fetchProducts()
        }.onDisappear{
            selectedOption = "ALL"
            selectedCollection = "ALL"
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}


