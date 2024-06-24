//
//  SplashScreen.swift
//  SnapShopApp-User
//
//  Created by husayn on 23/06/2024.
//

import SwiftUI

struct SplashScreen: View {
    @State var startAnimation:Bool = false
    @State var circleAnimation1:Bool = false
    @State var circleAnimation2:Bool = false
    @Binding var endAnimation: Bool 
    var body: some View {
        ZStack{
            Color(.black)
            Group{
                SplashShape()
                    .trim(from: 0,to: startAnimation ? 1 : 0)
                    .stroke( Color.white, style: StrokeStyle(lineWidth: 30,lineCap: .round, lineJoin: .round))
                
                Circle()
                    .fill(.white)
                    .frame(width: 35,height: 35)
                    .scaleEffect(circleAnimation1 ? 1 : 0)
                    .offset(x: -80,y: 22)
                Circle()
                    .fill(.white)
                    .frame(width: 35,height: 35)
                    .scaleEffect(circleAnimation2 ? 1 : 0)
                    .offset(x: 80,y: -22)
            }
            .frame(width: 220,height: 130)
                .scaleEffect(endAnimation ? 0.15 : 0.9)
                .rotationEffect(.init(degrees: endAnimation ?  85 : 0))
            VStack{
                Text("Powered by")
                    .font(.callout)
                    .fontWeight(.semibold)
                
                Text("MAD ISM-44")
                    .font(.title2)
                    .fontWeight(.semibold)
            }.frame(maxHeight: .infinity,alignment: .bottom)
            .foregroundColor(Color.white.opacity(0.8))
                .padding(.bottom,getSafeArea().bottom == 0 ? 15: getSafeArea().bottom )
                .opacity(startAnimation ? 1 : 0)
                .opacity(endAnimation ? 0 : 1)
        }.offset(y: endAnimation ? -(getRect().height * 1.5) : 0)
        .ignoresSafeArea()
            .onAppear{
                withAnimation(.spring().delay(0.15)){
                    circleAnimation1.toggle()
                }
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1.05, blendDuration: 1.05).delay(0.3)){
                    startAnimation.toggle()
                }
                withAnimation(.spring().delay(0.7)){
                    circleAnimation2.toggle()
                }
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1.05, blendDuration: 1.05).delay(1.2)){
                    endAnimation.toggle()
                }
            }
    }
}

extension View{
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
    
    func getSafeArea()->UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        return safeArea
    }
}

struct SplashShape: Shape{
    func path(in rect: CGRect) -> Path {
        return Path{
            path in
            let mid = rect.width / 2
            let height = rect.height
            path.move(to: CGPoint(x: mid - 80, y: height))
            path.addArc(center: CGPoint(x: mid - 40, y: height), radius: 40, startAngle: .init(degrees: 180), endAngle: .zero, clockwise: true)
            
            path.move(to: CGPoint(x: mid, y: height))
            path.addLine(to: CGPoint(x: mid, y: 0))
            
            path.addArc(center: CGPoint(x: mid + 40, y: 0), radius: 40, startAngle: .init(degrees: -180), endAngle: .zero, clockwise: false)
        }
    }
}
