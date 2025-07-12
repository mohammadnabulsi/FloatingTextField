//
//  OutlinedFloatingStyle.swift
//  FloatingTextFieldSwiftUI
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// Outlined floating text field style with colored borders
public struct OutlinedFloatingStyle: @preconcurrency FloatingTextFieldStyle {
    public init() {}
    
    @MainActor
    public func makeBody(configuration: FloatingTextFieldStyleConfiguration) -> some View {
        FloatingTextFieldContent(
            configuration: configuration,
            accentColor: .green,
            backgroundColor: .clear,
            borderColor: .green.opacity(0.5),
            textColor: .primary,
            labelColor: .green.opacity(0.8),
            cornerRadius: 8
        )
    }
}
