//
//  FloatingTextFieldStyle.swift
//  FloatingTextField
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI

/// A protocol that defines the appearance and behavior of a floating text field.
/// Conform to this protocol to create custom floating text field styles.
///
/// Example:
/// ```swift
/// struct MyCustomStyle: FloatingTextFieldStyle {
///     func makeBody(configuration: FloatingTextFieldStyleConfiguration) -> some View {
///         // Custom implementation
///     }
/// }
/// ```
public protocol FloatingTextFieldStyle {
    /// The type of view produced by this style
    associatedtype Body: View
    
    /// Creates a view that represents the body of a floating text field
    /// - Parameter configuration: The properties of the floating text field
    /// - Returns: A view that represents the styled floating text field
    func makeBody(configuration: FloatingTextFieldStyleConfiguration) -> Body
}
