//
//  CategoryAppBar.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//
//
//import SwiftUI
//
//struct CategoryAppBar: View {
//    @State var isPresented : Bool = false
//    @State var settingsDetents = PresentationDetent.medium
//    var body: some View {
//        HStack{
//            HomeSearchBar()
//            Button(action: {
//                isPresented.toggle()
//            }, label: {
//                Image(systemName: "line.horizontal.3.decrease")
//                    .font(.system(size: 24, weight: .semibold))
//                    .padding(.horizontal)
//                    .padding(.vertical,1)
//                    .foregroundColor(.black)
//            })
//            .sheet(isPresented: $isPresented, content: {
//                FilterButtomSheet().presentationDetents([.medium], selection: $settingsDetents)
//            })
//        }
//        
//    }
//}
//
//#Preview {
//    CategoryAppBar()
//}
