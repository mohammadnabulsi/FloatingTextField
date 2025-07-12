//
//  MaterialFloatingStyle.swift
//  FloatingTextFieldSwiftUI
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// Material Design inspired floating text field style
public struct MaterialFloatingStyle: @preconcurrency FloatingTextFieldStyle {
    public init() {}
    
    @MainActor
    public func makeBody(configuration: FloatingTextFieldStyleConfiguration) -> some View {
        FloatingTextFieldContent(
            configuration: configuration,
            accentColor: .indigo,
            backgroundColor: .clear,
            borderColor: .gray.opacity(0.3),
            textColor: .primary,
            labelColor: .secondary,
            cornerRadius: 8
        )
    }
}
