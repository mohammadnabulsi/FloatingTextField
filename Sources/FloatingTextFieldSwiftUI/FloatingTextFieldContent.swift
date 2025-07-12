//
//  FloatingTextFieldContent.swift
//  FloatingTextFieldSwiftUI
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// The internal content view that renders the floating text field
struct FloatingTextFieldContent: View {
    /// The configuration data for the text field
    let configuration: FloatingTextFieldStyleConfiguration
    
    /// Style properties
    let accentColor: Color
    let backgroundColor: Color
    let borderColor: Color
    let textColor: Color
    let labelColor: Color
    let cornerRadius: CGFloat
    
    /// Manages the focus state of the text field
    @FocusState private var isFocused: Bool
    
    /// Determines if the label should float
    private var shouldFloat: Bool {
        !configuration.text.wrappedValue.isEmpty || configuration.isEditing
    }
    
    /// Determines the current border color based on state
    private var currentBorderColor: Color {
        if configuration.validationState.currentError != nil {
            return .red
        }
        return configuration.isEditing ? accentColor : borderColor
    }
    
    /// Determines the current label color based on state
    private var currentLabelColor: Color {
        if configuration.validationState.currentError != nil {
            return .red
        }
        return configuration.isEditing ? accentColor : labelColor
    }
    
    /// Determines if the validation success icon should be shown
    private var shouldShowValidationIcon: Bool {
        configuration.validationState.hasBeenValidated && 
        !configuration.text.wrappedValue.isEmpty &&
        configuration.validationState.isValid
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Main Input Container
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(currentBorderColor, lineWidth: configuration.isEditing ? 2 : 1)
                    )
                
                // Content
                HStack(spacing: 12) {
                    
                    // Trailing Content
                    if let leadingContent = configuration.leadingContent {
                        leadingContent
                    }
                    
                    // Leading Icon
                    if let leadingIcon = configuration.leadingIcon {
                        Image(systemName: leadingIcon)
                            .foregroundColor(currentLabelColor)
                            .font(.title3)
                    }
                    
                    // Text Field Stack - FIXED LAYOUT
                    ZStack(alignment: .leading) {
                        // Floating Label
                        Text(configuration.label)
                            .font(shouldFloat ? .caption : .body)
                            .foregroundColor(shouldFloat ? currentLabelColor : labelColor.opacity(0.7))
                            .offset(y: shouldFloat ? -15 : 0)
                            .scaleEffect(shouldFloat ? 0.8 : 1, anchor: .leading)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: shouldFloat)
                        
                        // Input Field
                        Group {
                            if configuration.isSecure {
                                SecureField("", text: configuration.text)
                            } else {
                                TextField("", text: configuration.text)
                            }
                        }
                        .focused($isFocused)
                        .keyboardType(configuration.keyboardType)
                        .disabled(!configuration.isEnabled)
                        .foregroundColor(textColor)
                        .font(.body)
                        .padding(.top, 5)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: shouldFloat)
                    }
                    
                    // Validation Success Icon
                    if shouldShowValidationIcon {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                            .transition(.opacity.combined(with: .scale))
                    }
                    
                    // Trailing Content
                    if let trailingContent = configuration.trailingContent {
                        trailingContent
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .frame(height: 56)
            .onTapGesture {
                isFocused = true
            }
            .onChange(of: isFocused) { _ in
                // This will trigger the parent's onChange
            }
            .opacity(configuration.isEnabled ? 1 : 0.6)
            
            // Helper/Error Text
            if let errorMessage = configuration.validationState.currentError {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                    
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                    
                    Spacer()
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            } else if let helperText = configuration.helperText {
                Text(helperText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .synchronize($isFocused, with: configuration.isFocused)
    }
}
