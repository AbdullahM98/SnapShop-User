//
//  CarouselSlider.swift
//  SnapShop
//
//  Created by husayn on 24/05/2024.
//

import SwiftUI
import Combine

struct CarouselSlider: View {
    var adsImages: [String] = ["ADS1","ADS2","ADS3","ADS4"]
    @State private var timer: AnyCancellable?
    
    // Boolean flag to track navigation
    @State private var didNavigate = false
    
    // Manage selected index
    @State private var selectedImageIndex: Int = 0
    
    var body: some View {
        NavigationLink(destination: CouponsPage(), isActive: $didNavigate) {
            ZStack{
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<adsImages.count, id: \.self) { index in
                        ZStack(alignment: .topLeading){
                            Image("\(adsImages[index])")
                                .resizable()
                                .tag(index)
                                .frame(height: 150)
                        }
                    }
                }
                .frame(height: UIScreen.screenHeight/4)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea()
                
                // Dots
                HStack{
                    ForEach(0..<adsImages.count,id:\.self){index in
                        Capsule()
                            .fill(Color.black.opacity(selectedImageIndex == index ? 0.7 : 0.2))
                            .frame(width: 8,height: 8)
                            .onTapGesture {
                                selectedImageIndex = index
                            }
                    }.offset(y:90)
                }
            }
            .frame(height: 150).padding(.bottom,16)
            .onDisappear {
                didNavigate = true // Set the flag to true when the view disappears
                timer?.cancel() // Cancel the timer when the view disappears
            }
        }
        .onAppear {
            // Create the timer when the view appears
            timer = Timer.publish(every: 60, on: .main, in: .common)
                .autoconnect()
                .sink(receiveValue: { _ in
                    if !didNavigate { // Check if navigation has occurred
                        withAnimation(.default){
                            selectedImageIndex = (selectedImageIndex+1) % adsImages.count
                        }
                    }
                })
        }
    }
}

struct CarouselSlider_Previews: PreviewProvider {
    static var previews: some View {
        CarouselSlider()
    }
}
