//
//  CarouselSlider.swift
//  SnapShop
//
//  Created by husayn on 24/05/2024.
//

import SwiftUI
import Combine

struct CarouselSlider: View {
    var adsImages: [String] = ["ADS1", "ADS2", "ADS3", "ADS4"]
    @State private var timer: AnyCancellable?
    @State private var selectedImageIndex: Int = 0
    @State private var navigateToCoupons = false

    var body: some View {
        VStack {
            ZStack {
                TabView(selection: $selectedImageIndex) {
                    ForEach(0..<adsImages.count, id: \.self) { index in
                        Image(adsImages[index])
                            .resizable()
                            .padding(.trailing,-3)
                            .padding(.leading,-2)
                            .tag(index)
                            .frame(height: 150)
                            .onTapGesture {
                                navigateToCoupons = true
                            }
                    }
                }
                .frame(height: UIScreen.main.bounds.height / 4)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .ignoresSafeArea()

                HStack {
                    ForEach(0..<adsImages.count, id: \.self) { index in
                        Capsule()
                            .fill(Color.black.opacity(selectedImageIndex == index ? 0.7 : 0.2))
                            .frame(width: 8, height: 8)
                            .onTapGesture {
                                selectedImageIndex = index
                            }
                    }
                    .offset(y: 90)
                }
            }
            .frame(height: 150)
            .padding(.bottom, 16)
            .onAppear {
                timer = Timer.publish(every: 60, on: .main, in: .common)
                    .autoconnect()
                    .sink(receiveValue: { _ in
                        withAnimation(.default) {
                            selectedImageIndex = (selectedImageIndex + 1) % adsImages.count
                        }
                    })
            }
            .onDisappear {
                timer?.cancel()
            }

            NavigationLink(destination: CouponsPage(), isActive: $navigateToCoupons) {
                EmptyView()
            }
        }
    }
}

struct CarouselSlider_Previews: PreviewProvider {
    static var previews: some View {
        CarouselSlider()
    }
}
