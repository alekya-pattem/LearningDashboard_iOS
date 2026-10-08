import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email        = ""
    @Published var password     = ""
    @Published var isLoading    = false
    @Published var errorMessage : String?
    @Published var isLoggedIn   = false
    
    private func validateInputs() -> Bool {
        guard !email.isEmpty else {
            errorMessage = "Email is required."
            return false
        }
        guard Validator.isValidEmail(email) else {
            errorMessage = "Please enter a valid email."
            return false
        }
        guard !password.isEmpty else {
            errorMessage = "Password is required."
            return false
        }
        guard Validator.isValidPassword(password) else {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        
        errorMessage = nil
        return true
    }
    
    func login() {
        guard validateInputs() else { return }
        isLoading = true
        
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            isLoading = false
            isLoggedIn = true
        }
    }
}
