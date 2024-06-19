//
//  SnackBar.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 19/06/2024.
//

import Foundation
import SwiftUI
import SnackBar_swift

class SnackBarHelper {
    static func showSnackBar(isConnected:Bool) {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        let message = isConnected ? "Connected to the internet" : "No internet connection"
        let backgroundColor: UIColor = isConnected ? .green : .red
        let snackBar = SnackBar.make(in: keyWindow,
                                     message: message,
                                     duration: .lengthShort)
        
        snackBar.backgroundColor = backgroundColor
        snackBar.show()
    }
}
