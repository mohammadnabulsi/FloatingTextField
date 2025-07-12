//
//  ContentView.swift
//  Example
//
//  Created by Mohammad Nabulsi on 12.07.25.
//

import SwiftUI
import FloatingTextFieldSwiftUI

// MARK: - Example Usage with Custom Error Messages
struct FloatingTextFieldValidationDemo: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var username = ""
    @State private var phone = ""
    @State private var website = ""
    @State private var age = ""
    @State private var fullName = ""
    
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var isFormValid = false
    @State private var validationResults: [String: Bool] = [:]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Custom Error Messages Demo")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Full name with custom error messages
                FloatingTextField($fullName, label: "Full Name")
                    .leadingIcon("person")
                    .required("Please enter your full name")
                    .alphabetic("Name should only contain letters")
                    .minLength(2, errorMessage: "Name must be at least 2 characters")
                    .validateRealTime()
                    .onValidationChange { isValid in
                        validationResults["fullName"] = isValid
                        updateFormValidation()
                    }
                
                // Email with custom error message
                FloatingTextField($email, label: "Email Address")
                    .floatingTextFieldStyle(MaterialFloatingStyle())
                    .leadingIcon("envelope")
                    .keyboardType(.emailAddress)
                    .required("Email address is required")
                    .email("Please enter a valid email format (e.g., user@domain.com)")
                    .onValidationChange { isValid in
                        validationResults["email"] = isValid
                        updateFormValidation()
                    }
                
                // Username with detailed validation messages
                FloatingTextField($username, label: "Username")
                    .floatingTextFieldStyle(OutlinedFloatingStyle())
                    .leadingIcon("at")
                    .validation([
                        ValidationRule(
                            condition: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
                            errorMessage: "Username cannot be empty"
                        ),
                        ValidationRule(
                            condition: { $0.count >= 3 },
                            errorMessage: "Username must be at least 3 characters long"
                        ),
                        ValidationRule(
                            condition: { $0.count <= 20 },
                            errorMessage: "Username cannot exceed 20 characters"
                        ),
                        ValidationRule(
                            condition: { text in
                                let alphanumericRegex = "^[a-zA-Z0-9_]+$"
                                let alphanumericPredicate = NSPredicate(format: "SELF MATCHES %@", alphanumericRegex)
                                return alphanumericPredicate.evaluate(with: text)
                            },
                            errorMessage: "Username can only contain letters, numbers, and underscores"
                        )
                    ])
                    .onValidationChange { isValid in
                        validationResults["username"] = isValid
                        updateFormValidation()
                    }
                
                // Password with custom error message
                FloatingTextField($password, label: "Password")
                    .leadingIcon("lock")
                    .secure(!isPasswordVisible)
                    .password(
                        minLength: 8,
                        requireNumbers: true,
                        requireSpecialChars: true,
                        errorMessage: "Password must be 8+ characters with numbers and special characters (!@#$%^&*)"
                    )
                    .trailingContent {
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                    }
                    .onValidationChange { isValid in
                        validationResults["password"] = isValid
                        updateFormValidation()
                    }
                
                // Confirm password with custom validation
                FloatingTextField($confirmPassword, label: "Confirm Password")
                    .leadingIcon("lock")
                    .secure(!isConfirmPasswordVisible)
                    .validation([
                        ValidationRule(
                            condition: { !$0.isEmpty },
                            errorMessage: "Please confirm your password"
                        ),
                        ValidationRule(
                            condition: { $0 == password },
                            errorMessage: "Passwords don't match. Please try again."
                        )
                    ])
                    .trailingContent {
                        Button(action: { isConfirmPasswordVisible.toggle() }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.secondary)
                        }
                    }
                    .onValidationChange { isValid in
                        validationResults["confirmPassword"] = isValid
                        updateFormValidation()
                    }
                
                // Phone number with custom error
                FloatingTextField($phone, label: "Phone Number")
                    .floatingTextFieldStyle(FilledFloatingStyle())
                    .leadingIcon("phone")
                    .keyboardType(.phonePad)
                    .phoneNumber("Please enter a valid phone number (e.g., +1234567890)")
                    .onValidationChange { isValid in
                        validationResults["phone"] = isValid
                        updateFormValidation()
                    }
                
                // Website with custom error
                FloatingTextField($website, label: "Website")
                    .leadingIcon("globe")
                    .keyboardType(.URL)
                    .url("Please enter a valid URL (e.g., https://example.com)")
                    .helperText("Optional: Enter your website or portfolio URL")
                    .onValidationChange { isValid in
                        validationResults["website"] = isValid
                        updateFormValidation()
                    }
                
                // Age with detailed custom validation
                FloatingTextField($age, label: "Age")
                    .floatingTextFieldStyle(MinimalFloatingStyle())
                    .leadingIcon("calendar")
                    .keyboardType(.numberPad)
                    .validation([
                        ValidationRule(
                            condition: { !$0.isEmpty },
                            errorMessage: "Age is required"
                        ),
                        ValidationRule(
                            condition: { Double($0) != nil },
                            errorMessage: "Please enter a valid number"
                        ),
                        ValidationRule(
                            condition: { Int($0) ?? 0 >= 18 },
                            errorMessage: "You must be at least 18 years old to register"
                        ),
                        ValidationRule(
                            condition: { Int($0) ?? 0 <= 120 },
                            errorMessage: "Please enter a realistic age (under 120)"
                        )
                    ])
                    .onValidationChange { isValid in
                        validationResults["age"] = isValid
                        updateFormValidation()
                    }
                
                // Submit Button
                Button(action: submitForm) {
                    HStack {
                        if isFormValid {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                        }
                        Text("Create Account")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!isFormValid)
                .animation(.easeInOut(duration: 0.2), value: isFormValid)
                
                // Form Status
                if !validationResults.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Field Validation Status")
                            .font(.headline)
                            .padding(.top)
                        
                        ForEach(validationResults.keys.sorted(), id: \.self) { key in
                            HStack {
                                Image(systemName: validationResults[key] == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(validationResults[key] == true ? .green : .red)
                                
                                Text(key.capitalized.replacingOccurrences(of: "([A-Z])", with: " $1", options: .regularExpression))
                                    .font(.caption)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Custom Error Messages")
    }
    
    private func updateFormValidation() {
        // Form is valid if all required fields are valid
        let requiredFields = ["fullName", "email", "username", "password", "confirmPassword", "phone", "age"]
        isFormValid = requiredFields.allSatisfy { validationResults[$0] == true }
    }
    
    private func submitForm() {
        print("Account created successfully!")
        print("Full Name: \(fullName)")
        print("Email: \(email)")
        print("Username: \(username)")
        print("Phone: \(phone)")
        print("Website: \(website)")
        print("Age: \(age)")
    }
}

// MARK: - Simple Validation Example
struct SimpleValidationExample: View {
    @State private var email = ""
    @State private var isEmailValid = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Simple Email Validation")
                .font(.title2)
                .fontWeight(.bold)
            
            FloatingTextField($email, label: "Email Address")
                .leadingIcon("envelope")
                .email("Please enter a valid email address")
                .required("Email is required")
                .validateRealTime(true)
                .onValidationChange { isValid in
                    isEmailValid = isValid
                }
            
            Text("Email is \(isEmailValid ? "valid" : "invalid")")
                .foregroundColor(isEmailValid ? .green : .red)
                .font(.caption)
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Style Showcase
struct FloatingTextFieldStyleShowcase: View {
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
    @State private var text4 = ""
    @State private var text5 = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("FloatingTextField Styles")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Default Style")
                        .font(.headline)
                    FloatingTextField($text1, label: "Enter your name")
                        .leadingIcon("person")
                        .required()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Material Style")
                        .font(.headline)
                    FloatingTextField($text2, label: "Email Address")
                        .floatingTextFieldStyle(MaterialFloatingStyle())
                        .leadingIcon("envelope")
                        .email()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Outlined Style")
                        .font(.headline)
                    FloatingTextField($text3, label: "Username")
                        .floatingTextFieldStyle(OutlinedFloatingStyle())
                        .leadingIcon("at")
                        .alphanumeric()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Filled Style")
                        .font(.headline)
                    FloatingTextField($text4, label: "Phone Number")
                        .floatingTextFieldStyle(FilledFloatingStyle())
                        .leadingIcon("phone")
                        .phoneNumber()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Minimal Style")
                        .font(.headline)
                    FloatingTextField($text5, label: "Notes")
                        .floatingTextFieldStyle(MinimalFloatingStyle())
                        .helperText("Optional additional information")
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Custom Style")
                        .font(.headline)
                    FloatingTextField($text1, label: "Custom Field")
                        .floatingTextFieldStyle(CustomFloatingStyle(accent: .mint, background: .mint.opacity(0.1), border: .mint.opacity(0.3)))
                        .leadingIcon("star")
                }
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Style Showcase")
    }
}

// MARK: - Main Demo App
struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Custom Error Messages", destination: FloatingTextFieldValidationDemo())
                NavigationLink("Simple Validation", destination: SimpleValidationExample())
                NavigationLink("Style Showcase", destination: FloatingTextFieldStyleShowcase())
            }
            .navigationTitle("FloatingTextField Demo")
        }
    }
}

#Preview("Validation Demo") {
    NavigationView {
        FloatingTextFieldValidationDemo()
    }
}

#Preview("Simple Example") {
    NavigationView {
        SimpleValidationExample()
    }
}

#Preview("Style Showcase") {
    NavigationView {
        FloatingTextFieldStyleShowcase()
    }
}

#Preview("Demo App") {
    ContentView()
}
