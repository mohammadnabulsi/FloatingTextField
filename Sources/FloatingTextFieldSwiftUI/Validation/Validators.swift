//
//  Validators.swift
//  FloatingTextField
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import Foundation
import UIKit

/// A collection of pre-built validation rules for common use cases.
/// These can be used with the validation() modifier or accessed directly.
public struct Validators {
    /// Creates an email validation rule
    /// - Returns: A validation rule that checks for valid email format
    public static func email() -> ValidationRule {
        ValidationRule(
            condition: { text in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: text)
            },
            errorMessage: "Please enter a valid email address"
        )
    }
    
    /// Creates a minimum length validation rule
    /// - Parameter length: The minimum number of characters required
    /// - Returns: A validation rule that checks minimum length
    public static func minLength(_ length: Int) -> ValidationRule {
        ValidationRule(
            condition: { $0.count >= length },
            errorMessage: "Must be at least \(length) characters long"
        )
    }
    
    /// Creates a maximum length validation rule
    /// - Parameter length: The maximum number of characters allowed
    /// - Returns: A validation rule that checks maximum length
    public static func maxLength(_ length: Int) -> ValidationRule {
        ValidationRule(
            condition: { $0.count <= length },
            errorMessage: "Must be no more than \(length) characters long"
        )
    }
    
    /// Creates a required field validation rule
    /// - Returns: A validation rule that ensures the field is not empty
    public static func required() -> ValidationRule {
        ValidationRule(
            condition: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
            errorMessage: "This field is required"
        )
    }
    
    /// Creates an alphanumeric validation rule
    /// - Returns: A validation rule that allows only letters and numbers
    public static func alphanumeric() -> ValidationRule {
        ValidationRule(
            condition: { text in
                let alphanumericRegex = "^[a-zA-Z0-9]+$"
                let alphanumericPredicate = NSPredicate(format: "SELF MATCHES %@", alphanumericRegex)
                return alphanumericPredicate.evaluate(with: text)
            },
            errorMessage: "Only letters and numbers are allowed"
        )
    }
    
    /// Creates an alphabetic validation rule
    /// - Returns: A validation rule that allows only letters and spaces
    public static func alphabetic() -> ValidationRule {
        ValidationRule(
            condition: { text in
                let alphabeticRegex = "^[a-zA-Z\\s]+$"
                let alphabeticPredicate = NSPredicate(format: "SELF MATCHES %@", alphabeticRegex)
                return alphabeticPredicate.evaluate(with: text)
            },
            errorMessage: "Only letters are allowed"
        )
    }
    
    /// Creates a numeric validation rule
    /// - Returns: A validation rule that allows only numeric values
    public static func numeric() -> ValidationRule {
        ValidationRule(
            condition: { text in
                return Double(text) != nil
            },
            errorMessage: "Only numbers are allowed"
        )
    }
    
    /// Creates a phone number validation rule
    /// - Returns: A validation rule that checks for valid phone number format
    public static func phoneNumber() -> ValidationRule {
        ValidationRule(
            condition: { text in
                let phoneRegex = "^[+]?[1-9]?[0-9]{7,15}$"
                let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
                return phonePredicate.evaluate(with: text)
            },
            errorMessage: "Please enter a valid phone number"
        )
    }
    
    /// Creates a URL validation rule
    /// - Returns: A validation rule that checks for valid URL format
    @MainActor
    public static func url() -> ValidationRule {
        ValidationRule(
            condition: { text in
                if let url = URL(string: text) {
                    return UIApplication.shared.canOpenURL(url)
                }
                return false
            },
            errorMessage: "Please enter a valid URL"
        )
    }
    
    /// Creates a password validation rule with configurable requirements
    /// - Parameters:
    ///   - minLength: Minimum password length (default: 8)
    ///   - requireNumbers: Whether to require at least one number
    ///   - requireSpecialChars: Whether to require at least one special character
    /// - Returns: A validation rule that checks password requirements
    public static func password(minLength: Int = 8, requireNumbers: Bool = true, requireSpecialChars: Bool = true) -> ValidationRule {
        ValidationRule(
            condition: { text in
                guard text.count >= minLength else { return false }
                
                if requireNumbers {
                    let numberRegex = ".*[0-9]+.*"
                    let numberPredicate = NSPredicate(format: "SELF MATCHES %@", numberRegex)
                    guard numberPredicate.evaluate(with: text) else { return false }
                }
                
                if requireSpecialChars {
                    let specialCharRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]+.*"
                    let specialCharPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharRegex)
                    guard specialCharPredicate.evaluate(with: text) else { return false }
                }
                
                return true
            },
            errorMessage: "Password must be at least \(minLength) characters long\(requireNumbers ? ", include numbers" : "")\(requireSpecialChars ? ", and include special characters" : "")"
        )
    }
    
    /// Creates a custom validation rule
    /// - Parameters:
    ///   - condition: The validation condition closure
    ///   - errorMessage: The error message to display on failure
    ///   - validateOnEdit: Whether to validate while editing
    /// - Returns: A custom validation rule
    public static func custom(condition: @escaping (String) -> Bool, errorMessage: String, validateOnEdit: Bool = true) -> ValidationRule {
        ValidationRule(condition: condition, errorMessage: errorMessage, validateOnEdit: validateOnEdit)
    }
}
