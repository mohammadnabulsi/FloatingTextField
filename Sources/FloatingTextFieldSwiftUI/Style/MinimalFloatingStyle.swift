//
//  MinimalFloatingStyle.swift
//  FloatingTextFieldSwiftUI
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// Minimal floating text field style with underline only
public struct MinimalFloatingStyle: FloatingTextFieldStyle {
    public init() {}
    
    public func makeBody(configuration: FloatingTextFieldStyleConfiguration) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                // Floating Label
                Text(configuration.label)
                    .font(configuration.text.wrappedValue.isEmpty && !configuration.isFocused ? .body : .caption)
                    .foregroundColor(configuration.validationState.currentError != nil ? .red : (configuration.isFocused ? .blue : .secondary))
                    .offset(y: configuration.text.wrappedValue.isEmpty && !configuration.isFocused ? 0 : -20)
                    .scaleEffect(configuration.text.wrappedValue.isEmpty && !configuration.isFocused ? 1 : 0.8, anchor: .leading)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isFocused)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.text.wrappedValue.isEmpty)
                
                // Text Field
                Group {
                    if configuration.isSecure {
                        SecureField("", text: configuration.text)
                    } else {
                        TextField("", text: configuration.text)
                    }
                }
                .keyboardType(configuration.keyboardType)
                .disabled(!configuration.isEnabled)
                .padding(.top, configuration.text.wrappedValue.isEmpty && !configuration.isFocused ? 0 : 16)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isFocused)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.text.wrappedValue.isEmpty)
            }
            .padding(.vertical, 12)
            .background(
                Rectangle()
                    .fill(.clear)
                    .overlay(
                        Rectangle()
                            .frame(height: configuration.isFocused ? 2 : 1)
                            .foregroundColor(configuration.validationState.currentError != nil ? .red : (configuration.isFocused ? .blue : .secondary.opacity(0.5)))
                            .animation(.easeInOut(duration: 0.2), value: configuration.isFocused),
                        alignment: .bottom
                    )
            )
            
            // Error/Helper Text
            if let errorMessage = configuration.validationState.currentError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            } else if let helperText = configuration.helperText {
                Text(helperText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .opacity(configuration.isEnabled ? 1 : 0.6)
    }
}
