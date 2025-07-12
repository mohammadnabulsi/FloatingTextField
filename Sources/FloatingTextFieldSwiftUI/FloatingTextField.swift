//
//  FloatingTextField.swift
//  FloatingTextField
//
//  Created by Mohammad Nabulsi on 12.07.25.
//
//
//  FloatingTextField.swift
//  FloatingTextField
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// A customizable floating label text field for SwiftUI that provides Material Design-like behavior
/// with built-in validation, styling options, and various configuration modifiers.
///
/// Example usage:
/// ```swift
/// FloatingTextField($email, label: "Email")
///     .email()
///     .required()
///     .leadingIcon("envelope")
///     .floatingTextFieldStyle(MaterialFloatingStyle())
/// ```
public struct FloatingTextField: View {
    /// The binding to the text value of the field
    @Binding var text: String
    
    /// The label text that floats above the field when focused or filled
    let label: String
    
    /// Tracks whether the field is currently being edited
    @State private var isEditing = false
    
    /// Manages the focus state of the text field
    @FocusState private var isFocused: Bool
    
    /// Manages the validation state and error messages
    @StateObject private var validationState = ValidationState()
    
    // MARK: - Configuration Properties
    
    /// Determines if the field should mask input (for passwords)
    var isSecure: Bool = false
    
    /// The keyboard type to display when editing
    var keyboardType: UIKeyboardType = .default
    
    /// Optional SF Symbol name for the leading icon
    var leadingIcon: String? = nil
    
    /// Optional custom view content for the trailing area
    var trailingContent: AnyView? = nil
    
    /// Optional custom view content for the leading area
    var leadingContent: AnyView? = nil
    
    /// Helper text displayed below the field when no validation errors exist
    var helperText: String? = nil
    
    /// Controls whether the field accepts user input
    var isEnabled: Bool = true
    
    /// The style configuration for the field's appearance
    var style: AnyFloatingTextFieldStyle = AnyFloatingTextFieldStyle(DefaultFloatingStyle())
    
    /// Array of validation rules to apply to the field
    var validationRules: [ValidationRule] = []
    
    /// When true, validates the field as the user types
    var validateRealTime: Bool = false
    
    /// Callback fired when validation state changes
    var onValidationChange: ((Bool) -> Void)? = nil
    
    /// Creates a new floating text field
    /// - Parameters:
    ///   - text: Binding to the field's text value
    ///   - label: The label text for the field
    public init(_ text: Binding<String>, label: String) {
        self._text = text
        self.label = label
    }
    
    public var body: some View {
        style.makeBody(configuration: FloatingTextFieldStyleConfiguration(
            label: label,
            text: $text,
            isEditing: isEditing,
            isFocused: isFocused,
            helperText: helperText,
            isSecure: isSecure,
            leadingIcon: leadingIcon,
            trailingContent: trailingContent,
            leadingContent: leadingContent,
            keyboardType: keyboardType,
            isEnabled: isEnabled,
            validationState: validationState
        ))
        .onChange(of: isFocused) { newValue in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isEditing = newValue
            }
            
            // Validate when focus is lost
            if !newValue && !text.isEmpty {
                validationState.validate(text)
                onValidationChange?(validationState.isValid)
            }
        }
        .onChange(of: text) { newValue in
            // Real-time validation if enabled
            if validateRealTime || (validationState.hasBeenValidated && !validationRules.isEmpty) {
                validationState.validate(newValue, isEditing: true)
                onValidationChange?(validationState.isValid)
            }
        }
        .onAppear {
            validationState.setValidationRules(validationRules, validateRealTime: validateRealTime)
        }
    }
}

// MARK: - FloatingTextField Modifiers
public extension FloatingTextField {
    /// Applies a custom style to the floating text field
    /// - Parameter style: The style to apply
    /// - Returns: A styled floating text field
    func floatingTextFieldStyle<S: FloatingTextFieldStyle>(_ style: S) -> FloatingTextField {
        var field = self
        field.style = AnyFloatingTextFieldStyle(style)
        return field
    }
    
    /// Configures the field as a secure text entry field
    /// - Parameter isSecure: Whether to mask the input
    /// - Returns: A configured floating text field
    func secure(_ isSecure: Bool = true) -> FloatingTextField {
        var field = self
        field.isSecure = isSecure
        return field
    }
    
    /// Sets the keyboard type for the field
    /// - Parameter type: The UIKeyboardType to use
    /// - Returns: A configured floating text field
    func keyboardType(_ type: UIKeyboardType) -> FloatingTextField {
        var field = self
        field.keyboardType = type
        return field
    }
    
    /// Adds a leading icon to the field
    /// - Parameter iconName: SF Symbol name for the icon
    /// - Returns: A configured floating text field
    func leadingIcon(_ iconName: String?) -> FloatingTextField {
        var field = self
        field.leadingIcon = iconName
        return field
    }
    
    /// Adds custom trailing content to the field
    /// - Parameter content: A view builder that creates the trailing content
    /// - Returns: A configured floating text field
    func trailingContent<Content: View>(@ViewBuilder _ content: @escaping () -> Content) -> FloatingTextField {
        var field = self
        field.trailingContent = AnyView(content())
        return field
    }
    
    /// Adds custom leading content to the field
    /// - Parameter content: A view builder that creates the leading content
    /// - Returns: A configured floating text field
    func leadingContent<Content: View>(@ViewBuilder _ content: @escaping () -> Content) -> FloatingTextField {
        var field = self
        field.leadingContent = AnyView(content())
        return field
    }
    
    /// Sets helper text to display below the field
    /// - Parameter text: The helper text
    /// - Returns: A configured floating text field
    func helperText(_ text: String?) -> FloatingTextField {
        var field = self
        field.helperText = text
        return field
    }
    
    /// Controls whether the field is enabled for user interaction
    /// - Parameter isEnabled: Whether the field is enabled
    /// - Returns: A configured floating text field
    func enabled(_ isEnabled: Bool) -> FloatingTextField {
        var field = self
        field.isEnabled = isEnabled
        return field
    }
    
    // MARK: - Validation Modifiers
    
    /// Adds validation rules using variadic parameters
    /// - Parameter rules: One or more validation rules
    /// - Returns: A configured floating text field
    func validation(_ rules: ValidationRule...) -> FloatingTextField {
        var field = self
        field.validationRules = rules
        return field
    }
    
    /// Adds validation rules from an array
    /// - Parameter rules: Array of validation rules
    /// - Returns: A configured floating text field
    func validation(_ rules: [ValidationRule]) -> FloatingTextField {
        var field = self
        field.validationRules = rules
        return field
    }
    
    /// Enables or disables real-time validation
    /// - Parameter validate: Whether to validate in real-time
    /// - Returns: A configured floating text field
    func validateRealTime(_ validate: Bool = true) -> FloatingTextField {
        var field = self
        field.validateRealTime = validate
        return field
    }
    
    /// Sets a callback for validation state changes
    /// - Parameter callback: Closure called with validation state (true if valid)
    /// - Returns: A configured floating text field
    func onValidationChange(_ callback: @escaping (Bool) -> Void) -> FloatingTextField {
        var field = self
        field.onValidationChange = callback
        return field
    }
    
    // MARK: - Convenience Validation Modifiers
    
    /// Makes the field required
    /// - Parameter errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func required(_ errorMessage: String = "This field is required") -> FloatingTextField {
        var field = self
        field.validationRules.append(ValidationRule(
            condition: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
            errorMessage: errorMessage
        ))
        return field
    }
    
    /// Validates the field as an email address
    /// - Parameter errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func email(_ errorMessage: String = "Please enter a valid email address") -> FloatingTextField {
        var field = self
        field.validationRules.append(ValidationRule(
            condition: { text in
                let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
                return emailPredicate.evaluate(with: text)
            },
            errorMessage: errorMessage
        ))
        return field
    }
    
    /// Sets a minimum length requirement
    /// - Parameters:
    ///   - length: Minimum character count
    ///   - errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func minLength(_ length: Int, errorMessage: String? = nil) -> FloatingTextField {
        var field = self
        let message = errorMessage ?? "Must be at least \(length) characters long"
        field.validationRules.append(ValidationRule(
            condition: { $0.count >= length },
            errorMessage: message
        ))
        return field
    }
    
    /// Sets a maximum length requirement
    /// - Parameters:
    ///   - length: Maximum character count
    ///   - errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func maxLength(_ length: Int, errorMessage: String? = nil) -> FloatingTextField {
        var field = self
        let message = errorMessage ?? "Must be no more than \(length) characters long"
        field.validationRules.append(ValidationRule(
            condition: { $0.count <= length },
            errorMessage: message
        ))
        return field
    }
    
    /// Restricts input to alphanumeric characters only
    /// - Parameter errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func alphanumeric(_ errorMessage: String = "Only letters and numbers are allowed") -> FloatingTextField {
        var field = self
        field.validationRules.append(ValidationRule(
            condition: { text in
                let alphanumericRegex = "^[a-zA-Z0-9]+$"
                let alphanumericPredicate = NSPredicate(format: "SELF MATCHES %@", alphanumericRegex)
                return alphanumericPredicate.evaluate(with: text)
            },
            errorMessage: errorMessage
        ))
        return field
    }
    
    /// Restricts input to alphabetic characters only
    /// - Parameter errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func alphabetic(_ errorMessage: String = "Only letters are allowed") -> FloatingTextField {
        var field = self
        field.validationRules.append(ValidationRule(
            condition: { text in
                let alphabeticRegex = "^[a-zA-Z\\s]+$"
                let alphabeticPredicate = NSPredicate(format: "SELF MATCHES %@", alphabeticRegex)
                return alphabeticPredicate.evaluate(with: text)
            },
            errorMessage: errorMessage
        ))
        return field
    }
    
    /// Restricts input to numeric values only
    /// - Parameter errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func numeric(_ errorMessage: String = "Only numbers are allowed") -> FloatingTextField {
        var field = self
        field.validationRules.append(ValidationRule(
            condition: { text in
                return Double(text) != nil
            },
            errorMessage: errorMessage
        ))
        return field
    }
    
    /// Validates the field as a phone number
    /// - Parameter errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func phoneNumber(_ errorMessage: String = "Please enter a valid phone number") -> FloatingTextField {
        var field = self
        field.validationRules.append(ValidationRule(
            condition: { text in
                let phoneRegex = "^[+]?[1-9]?[0-9]{7,15}$"
                let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
                return phonePredicate.evaluate(with: text)
            },
            errorMessage: errorMessage
        ))
        return field
    }
    
    /// Validates the field as a URL
    /// - Parameter errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func url(_ errorMessage: String = "Please enter a valid URL") -> FloatingTextField {
        var field = self
        field.validationRules.append(ValidationRule(
            condition: { text in
                if let url = URL(string: text) {
                    return UIApplication.shared.canOpenURL(url)
                }
                return false
            },
            errorMessage: errorMessage
        ))
        return field
    }
    
    /// Validates the field as a password with configurable requirements
    /// - Parameters:
    ///   - minLength: Minimum password length
    ///   - requireNumbers: Whether numbers are required
    ///   - requireSpecialChars: Whether special characters are required
    ///   - errorMessage: Custom error message
    /// - Returns: A configured floating text field
    func password(minLength: Int = 8, requireNumbers: Bool = true, requireSpecialChars: Bool = true, errorMessage: String? = nil) -> FloatingTextField {
        var field = self
        let message = errorMessage ?? "Password must be at least \(minLength) characters long\(requireNumbers ? ", include numbers" : "")\(requireSpecialChars ? ", and include special characters" : "")"
        
        field.validationRules.append(ValidationRule(
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
            errorMessage: message
        ))
        return field
    }
}

extension View {
    /// Synchronizes a binding with a remote value
    /// - Parameters:
    ///   - local: The local binding to synchronize
    ///   - remote: The remote value to sync with
    /// - Returns: A view that synchronizes the values
    func synchronize<T: Equatable>(_ local: Binding<T>, with remote: T) -> some View {
        self.onChange(of: remote) { newValue in
            if local.wrappedValue != newValue {
                local.wrappedValue = newValue
            }
        }
    }
    
    /// Synchronizes a FocusState binding with a remote value
    /// - Parameters:
    ///   - local: The local FocusState binding
    ///   - remote: The remote value to sync with
    /// - Returns: A view that synchronizes the values
    func synchronize<T: Equatable>(_ local: FocusState<T>.Binding, with remote: T) -> some View {
        self.onChange(of: remote) { newValue in
            if local.wrappedValue != newValue {
                local.wrappedValue = newValue
            }
        }
    }
}
