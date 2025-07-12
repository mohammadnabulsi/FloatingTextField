//
//  AnyFloatingTextFieldStyle.swift
//  FloatingTextField
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// A type-erased wrapper for FloatingTextFieldStyle implementations.
/// This allows for dynamic style selection at runtime while maintaining protocol conformance.
struct AnyFloatingTextFieldStyle: FloatingTextFieldStyle {
    /// The type-erased function that creates the styled view
    private let _makeBody: (FloatingTextFieldStyleConfiguration) -> AnyView
    
    /// Creates a type-erased style from any concrete FloatingTextFieldStyle
    /// - Parameter style: The concrete style to wrap
    init<S: FloatingTextFieldStyle>(_ style: S) {
        _makeBody = { configuration in
            AnyView(style.makeBody(configuration: configuration))
        }
    }
    
    /// Creates the view for this style
    /// - Parameter configuration: The configuration data for the text field
    /// - Returns: The styled view wrapped in AnyView
    func makeBody(configuration: FloatingTextFieldStyleConfiguration) -> some View {
        _makeBody(configuration)
    }
}
