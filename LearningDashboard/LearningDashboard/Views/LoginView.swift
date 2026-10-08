import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        Spacer().frame(height: 60)
                        
                        // App Logo or Icon
                        Image(systemName: "graduationcap.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                            .padding(.bottom, 5)
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("Sign in to continue your learning journey")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                        
                        // Input Fields
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                TextField("Email", text: $viewModel.email)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                SecureField("Password", text: $viewModel.password)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal, 24)
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 5)
                        }
                        
                        // Login Button
                        Button(action: {
                            // Dismiss keyboard
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            viewModel.login()
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Login")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(colors: [Color.blue, Color.indigo], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 24)
                        .padding(.top, 10)
                        .disabled(viewModel.isLoading)
                        .opacity(viewModel.isLoading ? 0.7 : 1.0)
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                CourseDashboardView()
            }
        }
    }
}
