//
//  TextFieldValidator.swift
//  SnapShop
//
//  Created by Abdullah Essam on 02/06/2024.
//

import Foundation


protocol FieldValidatorProtocol{
    func validateField(value : String)->String?
}


struct FieldModel {
    var value :String
    var error : String?
    var fieldType : TextfieldType
    
    init(value: String, error: String? = nil, fieldType: TextfieldType) {
        self.value = value
        self.error = error
        self.fieldType = fieldType
    }
    mutating func onValidate() ->Bool{
        error = fieldType.validateField(value: value)
        return error == nil
        
    }
    mutating func onSubmitError(){
        error = fieldType.validateField(value: value)
    }
}


enum TextfieldType :FieldValidatorProtocol{
    case email
    case password
    case def
    var placeHolder :String {
 
        switch self {
        case .email:
            return "Email"
        case .password:
            return "Password"
        case .def:
            return ""
            
        }
    }
    
    func validateField(value: String) -> String? {
        return nil
    }
    
    private func validateEmail(email:String) -> String?{
        if email.isEmpty{
            return "Empty Value"
        }else{
            let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPredicate.evaluate(with: email) ? nil : "Please Enter a valid email"
        }
    }
    
    
}
