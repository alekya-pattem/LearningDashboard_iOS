import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email        = ""
    @Published var password     = ""
    @Published var isLoading    = false
    @Published var errorMessage : String?
    @Published var isLoggedIn   = false
    
    func login() {
        guard Validator.isValidEmail(email) else {
            errorMessage = "Please enter a valid email."
            return
        }
        guard Validator.isValidPassword(password) else {
            errorMessage = "Password must be at least 6 characters."
            return
        }
        
        errorMessage = nil
        isLoading = true
        
        Task {
            // Simulate network call
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            isLoading = false
            isLoggedIn = true
        }
    }
}
