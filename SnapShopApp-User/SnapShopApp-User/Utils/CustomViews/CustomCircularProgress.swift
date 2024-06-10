//
//  CustomCircularProgress.swift
//  SnapShopApp-User
//
//  Created by husayn on 10/06/2024.
//

import SwiftUI
import Combine
struct CustomCircularProgress: View {
    @State private var progress: CGFloat = 0.0
    
    @State private var timer: AnyCancellable?
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5.0)
                .opacity(0.3)
                .foregroundColor(Color.blue)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.black)
                .rotationEffect(Angle(degrees: -90))
        }
        .onAppear {
            // Start the timer when the view appears
            self.timer = Timer.publish(every: 0.1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    withAnimation(.linear) {
                        if self.progress < 1.0 {
                            self.progress += 0.01
                        }
                    }
                }
        }
        .onDisappear {
            // Cancel the timer when the view disappears
            self.timer?.cancel()
        }
        .frame(width: 50, height: 50)
    }

}

struct CustomCircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        CustomCircularProgress()
    }
}
