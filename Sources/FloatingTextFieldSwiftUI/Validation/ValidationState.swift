//
//  ValidationState.swift
//  FloatingTextField
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI
/// Manages the validation state of a floating text field.
/// This class tracks validation rules, errors, and the overall validity of the field.
public class ValidationState: ObservableObject {
    /// Indicates whether the current text is valid according to all rules
    @Published public var isValid: Bool = true
    
    /// Array of current validation error messages
    @Published public var errors: [String] = []
    
    /// Indicates whether validation has been performed at least once
    @Published public var hasBeenValidated: Bool = false
    
    /// The validation rules to apply
    private var validationRules: [ValidationRule] = []
    
    /// Whether to validate in real-time as the user types
    private var validateRealTime: Bool = false
    
    /// Sets the validation rules for this state
    /// - Parameters:
    ///   - rules: Array of validation rules to apply
    ///   - validateRealTime: Whether to validate as the user types
    func setValidationRules(_ rules: [ValidationRule], validateRealTime: Bool = false) {
        self.validationRules = rules
        self.validateRealTime = validateRealTime
    }
    
    /// Validates the given text against all rules
    /// - Parameters:
    ///   - text: The text to validate
    ///   - isEditing: Whether the user is currently editing
    func validate(_ text: String, isEditing: Bool = false) {
        hasBeenValidated = true
        errors.removeAll()
        
        for rule in validationRules {
            // Skip real-time validation for rules that shouldn't validate on edit
            if isEditing && !rule.validateOnEdit && !validateRealTime {
                continue
            }
            
            if !rule.condition(text) {
                errors.append(rule.errorMessage)
                // Stop at first error for cleaner UX
                break
            }
        }
        
        isValid = errors.isEmpty
    }
    
    /// Resets the validation state
    func reset() {
        isValid = true
        errors.removeAll()
        hasBeenValidated = false
    }
    
    /// The current error message to display (first error if any)
    var currentError: String? {
        errors.first
    }
}
