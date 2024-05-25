//
//  ProductGrid.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 25/05/2024.
//

import SwiftUI


struct ProductGrid: View {
    
    private let
    adaptiveColumns = [
        GridItem(.adaptive (minimum: 170))
    ]
    
    var body: some View {
        VStack(alignment:.leading ){
            Text("Products").bold()
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.screenWidth/2-35,maximum: UIScreen.screenWidth/2-5))]) {
                    ForEach(0..<20) { index in
                        ProductCell()
                    }
                }
            }
        }.padding(.all,8)
        
    }
}
extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
#Preview {
    ProductGrid()
}
