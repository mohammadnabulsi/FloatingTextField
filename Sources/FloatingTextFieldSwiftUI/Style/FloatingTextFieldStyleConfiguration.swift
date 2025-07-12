//
//  FloatingTextFieldStyleConfiguration.swift
//  FloatingTextField
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// Contains the configuration data needed to style a floating text field.
/// This structure is passed to FloatingTextFieldStyle implementations.
public struct FloatingTextFieldStyleConfiguration {
    /// The label text that floats above the field
    public let label: String
    
    /// Binding to the text value of the field
    public let text: Binding<String>
    
    /// Indicates whether the field is currently being edited
    public let isEditing: Bool
    
    /// Indicates whether the field currently has focus
    public let isFocused: Bool
    
    /// Optional helper text to display below the field
    public let helperText: String?
    
    /// Indicates whether the field should mask input (for passwords)
    public let isSecure: Bool
    
    /// Optional SF Symbol name for a leading icon
    public let leadingIcon: String?
    
    /// Optional custom view content for the trailing area
    public let trailingContent: AnyView?
    
    /// Optional custom view content for the leading area
    public let leadingContent: AnyView?
    
    /// The keyboard type to display when editing
    public let keyboardType: UIKeyboardType
    
    /// Indicates whether the field is enabled for user interaction
    public let isEnabled: Bool
    
    /// The validation state containing error information
    public let validationState: ValidationState
}
