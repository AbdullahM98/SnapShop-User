//
//  CarouselSlider.swift
//  SnapShop
//
//  Created by husayn on 24/05/2024.
//

import SwiftUI

struct CarouselSlider: View {
    var adsImages: [String]
    let timer = Timer.publish(every: 3.0, on: .main, in: .common).autoconnect()
    //manage selected index
    @State private var selectedImageIndex: Int = 0
    var body: some View {
        ZStack{
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<adsImages.count, id: \.self) { index in
                    ZStack(alignment: .topLeading){
                        
                        Image("\(adsImages[index])")
                            .resizable()
                            .tag(index)
                            .frame(height: 200)
                    }
                  
                }
            }
            .frame(height: 300)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            HStack{
                ForEach(0..<adsImages.count,id:\.self){index in
                    Capsule()
                        .fill(Color.black.opacity(selectedImageIndex == index ? 0.88 : 0.22))
                        .frame(width: 8,height: 8)
                        .onTapGesture {
                            selectedImageIndex = index
                        }
                }.offset(y:130)
            }.onReceive(timer) { _ in
                withAnimation(.default){
                    selectedImageIndex = (selectedImageIndex+1) % adsImages.count
                }
            }
        }
    }
}

struct CarouselSlider_Previews: PreviewProvider {
    static var previews: some View {
        CarouselSlider(adsImages: ["1","2"])
    }
}
