//
//  ContentView.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        SignUpScreen(viewModel: SignUpViewModel())
    }
}

#Preview {
    ContentView()
}
