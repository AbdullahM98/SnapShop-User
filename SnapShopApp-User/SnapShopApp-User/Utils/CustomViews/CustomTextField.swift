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
    @Binding var fieldModel: FieldModel
    var text: Binding<String>
    var compareTo: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            if fieldModel.fieldType == .password || fieldModel.fieldType == .confirmPass {
                SecureField(fieldModel.fieldType.placeHolder, text: text)
                    .foregroundColor(.gray)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                    )
                    .padding(.bottom, 10)
                    .onChange(of: text.wrappedValue) { newValue in
                        fieldModel.value = newValue
                        fieldModel.onSubmitError(comparedTo: compareTo)
                    }
            } else {
                TextField(fieldModel.fieldType.placeHolder, text: text)
                    .foregroundColor(.gray)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1.5).opacity(0.5)
                    )
                    .padding(.bottom, 10)
                    .onChange(of: text.wrappedValue) { newValue in
                        fieldModel.value = newValue
                        fieldModel.onSubmitError()
                    }
            }

            if let error = fieldModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.system(size: 15))
                    .multilineTextAlignment(.leading)
                    .padding([.horizontal], 0)
            }
        }
    }
}
