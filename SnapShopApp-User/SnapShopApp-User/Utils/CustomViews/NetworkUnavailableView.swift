//
//  NetworkUnavailableView.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 23/06/2024.
//

import SwiftUI

struct NetworkUnavailableView: View {
    var body: some View {
        ContentUnavailableView(
            title: "No Internet Connection",
            imageName: "wifi.exclamationmark",
            description: Text("Please check your connection and try again.")
        )
    }
}

#Preview {
    NetworkUnavailableView()
}
