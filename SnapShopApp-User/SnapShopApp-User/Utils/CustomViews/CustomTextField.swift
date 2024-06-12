//
//  CustomTextField.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import SwiftUI

struct CustomTextField: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField()
    }
}


struct AppTextField: View {
    var fieldModel :Binding<FieldModel>
    var text:Binding<String>
    var body: some View {
        VStack(alignment: .leading){
            
            TextField(fieldModel.fieldType.wrappedValue.placeHolder, text: text ).foregroundStyle(Color.gray)
                      .padding(10)
                       .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Theme.strokeColor, lineWidth: 1.5)
                       ).padding(.bottom,10)
            if let error = fieldModel.error.wrappedValue{
                Text(error).foregroundStyle(Color.red).font(.system(size: 15)).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/).padding([.horizontal],0)
            }
        }
    }
}
