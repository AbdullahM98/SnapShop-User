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
                            .frame(height: 150)
                        VStack(alignment: .center){
                            Text("Up to 50%")
                                .offset(.init(width: 20, height: 20))
                            Text("On everything today")
                                .offset(.init(width: 20, height: 20))
                            Text("With code: Hadir2001")
                                .offset(.init(width: 20, height: 20))
                            Button {
                                print("Cart")
                            } label: {
                                RoundedRectangle(cornerRadius: 30)
                                    .overlay {
                                        Text("Click Me")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                    }
                            }
                            .frame(width: 80, height: 36)
                            .tint(.black.opacity(0.9))
                            .offset(.init(width: 28, height: 28))

                        }
                    }
                    
                }
            }
            .frame(height: UIScreen.screenHeight/4)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            HStack{
                ForEach(0..<adsImages.count,id:\.self){index in
                    Capsule()
                        .fill(Color.black.opacity(selectedImageIndex == index ? 0.7 : 0.2))
                        .frame(width: 8,height: 8)
                        .onTapGesture {
                            selectedImageIndex = index
                        }
                }.offset(y:90)
            }.onReceive(timer) { _ in
                withAnimation(.default){
                    selectedImageIndex = (selectedImageIndex+1) % adsImages.count
                }
            }
        }.frame(height: 150)
    }
}

struct CarouselSlider_Previews: PreviewProvider {
    static var previews: some View {
        CarouselSlider(adsImages: ["1","2"])
    }
}
