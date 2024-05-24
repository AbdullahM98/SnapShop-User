//
//  ContentView.swift
//  SnapShop
//
//  Created by Abdullah Essam on 21/05/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            AppButton(text: "confirm",width: 100,height: 50,bgColor: Color.black,isFilled:  true)

        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
