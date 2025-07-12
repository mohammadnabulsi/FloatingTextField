//
//  ValidationRule.swift
//  FloatingTextField
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// Represents a validation rule that can be applied to a floating text field.
/// Each rule consists of a condition and an error message to display when the condition fails.
public struct ValidationRule {
    /// The validation condition closure that returns true if the input is valid
    let condition: (String) -> Bool
    
    /// The error message to display when validation fails
    let errorMessage: String
    
    /// Determines whether this rule should be evaluated during editing
    let validateOnEdit: Bool
    
    /// Creates a new validation rule
    /// - Parameters:
    ///   - condition: A closure that validates the input string
    ///   - errorMessage: The error message to display on validation failure
    ///   - validateOnEdit: Whether to validate while the user is typing (default: true)
    public init(condition: @escaping (String) -> Bool, errorMessage: String, validateOnEdit: Bool = true) {
        self.condition = condition
        self.errorMessage = errorMessage
        self.validateOnEdit = validateOnEdit
    }
}
