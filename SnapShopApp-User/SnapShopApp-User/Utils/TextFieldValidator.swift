import Foundation

protocol FieldValidatorProtocol {
    func validateField(value: String) -> String?
}

struct FieldModel {
    var value: String
    var error: String?
    var fieldType: TextfieldType
    
    init(value: String, error: String? = nil, fieldType: TextfieldType) {
        self.value = value
        self.error = error
        self.fieldType = fieldType
    }
    
    mutating func onValidate() -> Bool {
        error = fieldType.validateField(value: value)
        return error == nil
    }
    
    mutating func onSubmitError() {
        error = fieldType.validateField(value: value)
    }
}

enum TextfieldType: FieldValidatorProtocol {
    case email
    case password
    case confirmPass
    case city
    case country
    case address
    case phoneNum
    case firstName
    case lastName
    
    var placeHolder: String {
        switch self {
        case .email:
            return "Email"
        case .password:
            return "Password"
        case .confirmPass:
            return "Confirm Password"
        case .city:
            return "City"
        case .country:
            return "Country"
        case .address:
            return "Address"
        case .phoneNum:
            return "Phone Number"
        case .firstName:
            return "First Name"
        case .lastName:
            return "Last Name"
        }
    }
    
    func validateField(value: String) -> String? {
        switch self {
        case .email:
            return validateEmail(email: value)
        case .password:
            return validatePassword(password: value)
        case .confirmPass:
            return validateConfirmPassword(confirmPass: value)
        case .city:
            return validateCity(city: value)
        case .country:
            return validateCountry(country: value)
        case .address:
            return validateAddress(address: value)
        case .phoneNum:
            return validatePhoneNumber(phoneNum: value)
        case .firstName:
            return validateFirstName(firstName: value)
        case .lastName:
            return validateLastName(lastName: value)
        }
    }
    
    private func validateEmail(email: String) -> String? {
        if email.isEmpty {
            return "Email cannot be empty"
        } else {
            let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            return emailPredicate.evaluate(with: email) ? nil : "Please enter a valid email"
        }
    }
    
    private func validatePassword(password: String) -> String? {
        if password.isEmpty {
            return "Password cannot be empty"
        } else if password.count < 8 {
            return "Password must be at least 6 characters long"
        }
        return nil
    }
    
    private func validateConfirmPassword(confirmPass: String) -> String? {
        // Implement custom logic for confirm password if needed
        if confirmPass.isEmpty {
            return "Confirm password cannot be empty"
        }
        return nil
    }
    
    private func validateCity(city: String) -> String? {
        if city.isEmpty {
            return "City cannot be empty"
        }
        return nil
    }
    
    private func validateCountry(country: String) -> String? {
        if country.isEmpty {
            return "Country cannot be empty"
        }
        return nil
    }
    
    private func validateAddress(address: String) -> String? {
        if address.isEmpty {
            return "Address cannot be empty"
        }
        return nil
    }
    
    private func validatePhoneNumber(phoneNum: String) -> String? {
        if phoneNum.isEmpty {
            return "Phone number cannot be empty"
        } else {
            let phoneRegEx = "^\\+?[0-9]{12}$"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
            return phonePredicate.evaluate(with: phoneNum) ? nil : "Please enter a valid phone number starting with '+' and containing exactly 12 digits"
        }
    }
    
    private func validateFirstName(firstName: String) -> String? {
        if firstName.isEmpty {
            return "First name cannot be empty"
        }
        return nil
    }
    
    private func validateLastName(lastName: String) -> String? {
        if lastName.isEmpty {
            return "Last name cannot be empty"
        }
        return nil
    }
}
