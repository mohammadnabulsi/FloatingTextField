//
//  DefaultFloatingStyle.swift
//  FloatingTextField
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// The default floating text field style with customizable colors and corner radius
public struct DefaultFloatingStyle: @preconcurrency FloatingTextFieldStyle {
    /// The accent color used when the field is focused
    public var accentColor: Color = .blue
    
    /// The background color of the field
    public var backgroundColor: Color = Color(.systemGray6)
    
    /// The border color when the field is not focused
    public var borderColor: Color = Color(.systemGray4)
    
    /// The color of the input text
    public var textColor: Color = .primary
    
    /// The color of the label text
    public var labelColor: Color = .secondary
    
    /// The corner radius of the field
    public var cornerRadius: CGFloat = 12
    
    /// Creates a default floating style with optional customization
    public init(
        accentColor: Color = .blue,
        backgroundColor: Color = Color(.systemGray6),
        borderColor: Color = Color(.systemGray4),
        textColor: Color = .primary,
        labelColor: Color = .secondary,
        cornerRadius: CGFloat = 12
    ) {
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.textColor = textColor
        self.labelColor = labelColor
        self.cornerRadius = cornerRadius
    }
    
    @MainActor
    public func makeBody(configuration: FloatingTextFieldStyleConfiguration) -> some View {
        FloatingTextFieldContent(
            configuration: configuration,
            accentColor: accentColor,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            textColor: textColor,
            labelColor: labelColor,
            cornerRadius: cornerRadius
        )
    }
}
