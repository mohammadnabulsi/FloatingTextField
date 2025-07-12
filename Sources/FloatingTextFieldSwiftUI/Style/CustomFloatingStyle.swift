//
//  CustomFloatingStyle.swift
//  FloatingTextFieldSwiftUI
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// A customizable floating text field style with configurable colors
public struct CustomFloatingStyle: @preconcurrency FloatingTextFieldStyle {
    /// The accent color for focused state
    let accentColor: Color
    
    /// The background color of the field
    let backgroundColor: Color
    
    /// The border color for unfocused state
    let borderColor: Color
    
    /// Creates a custom floating style with specified colors
    /// - Parameters:
    ///   - accent: The accent color
    ///   - background: The background color
    ///   - border: The border color
    public init(accent: Color = .purple, background: Color = Color(.systemGray6), border: Color = Color(.systemGray4)) {
        self.accentColor = accent
        self.backgroundColor = background
        self.borderColor = border
    }
    
    @MainActor
    public func makeBody(configuration: FloatingTextFieldStyleConfiguration) -> some View {
        FloatingTextFieldContent(
            configuration: configuration,
            accentColor: accentColor,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            textColor: .primary,
            labelColor: .secondary,
            cornerRadius: 16
        )
    }
}
