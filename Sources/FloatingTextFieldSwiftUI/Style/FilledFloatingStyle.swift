//
//  FilledFloatingStyle.swift
//  FloatingTextFieldSwiftUI
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// Filled floating text field style with colored background
public struct FilledFloatingStyle: @preconcurrency FloatingTextFieldStyle {
    public init() {}
    
    @MainActor
    public func makeBody(configuration: FloatingTextFieldStyleConfiguration) -> some View {
        FloatingTextFieldContent(
            configuration: configuration,
            accentColor: .orange,
            backgroundColor: .orange.opacity(0.1),
            borderColor: .clear,
            textColor: .primary,
            labelColor: .orange.opacity(0.8),
            cornerRadius: 12
        )
    }
}
