//
//  AuthView.swift
//  ForeignWorld
//
//  Created by Jonas Sollmann on 15.06.20.
//  Copyright © 2020 Jonas Sollmann. All rights reserved.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit

struct signInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    
    func signIn() {
        Auth.auth().currentUser?.reload{(error) in}
        session.signIn(email: email, password: password) { (result, error) in if let error = error {
                self.error = error.localizedDescription
        } else {
            self.email = ""
            self.password = ""
            }
        }
    }
    
    var body: some View {
        VStack{
            Text("Welcome Back!")
                .font(.system(size: 32, weight: .heavy))
            
            Text("Sign in to continue")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
            
            VStack(spacing: 18) {
                TextField("Email address", text: $email)
                    .font(.system(size: 18))
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    
                
                SecureField("Password", text: $password)
                    .font(.system(size: 18))
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                    
            }
            .padding()
            .padding(.top, 30)
            
            NavigationLink(destination: ForgotPassword()) {
                HStack {
                    Text ("Forgot Password")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(Color(.black))
        
                }
            }
            
            Button(action: signIn) {
                Text("Sign in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(Color.black)
                    .cornerRadius(35.0)
                    .padding(.top, 20)
            }
            
            if (error != "") {
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
            
            NavigationLink(destination: SignUpView()) {
                HStack {
                    Text ("I'm a new user.")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(Color(.gray))
                    
                    Text ("Create an account")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                        
                    
                }
                .padding(.bottom, 30)
            }
        }
    }
}

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @EnvironmentObject var session: SessionStore
    
        func signUp() {
        session.signUp(email: email, password: password)
        { (result, error) in if let error = error {
            self.error = error.localizedDescription
        } else {
            self.email = ""
            self.password = ""
            
            }
        }
    }
    
    
    
    var body: some View{
        VStack {
            Text("Create Account")
                .font(.system (size: 32, weight: .heavy))
                .padding(.top, -160)
            
            Text("Sign up to get started")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color.gray)
                .padding(.top, -100)
            
            VStack(spacing: 18) {
                TextField("Email address", text: $email)
                .font(.system(size: 18))
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                
            SecureField("Password", text: $password)
                .font(.system(size: 18))
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                
            }
            .padding()
            .padding(.top, -40)
            
            Button(action: signUp) {
                Text("Create Account")
                      .font(.headline)
                      .foregroundColor(.white)
                      .padding()
                      .frame(width: 220, height: 60)
                      .background(Color.black)
                      .cornerRadius(35.0)
                      .padding(.top, 40)
                      
            }
            
            if (error != "") {
                Text(error)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
                    .padding()
                
            }
        }
    }
}

struct AuthView: View {
    var body: some View{
        NavigationView {
            signInView()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(SessionStore())
    }
}

struct ForgotPassword: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var email: String = ""
    @State private var showAlert = false
    @State private var errString: String?
    
    func resetPassword(email:String, resetCompletion:@escaping (Result<Bool,Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in if let error = error {
            resetCompletion(.failure(error))
        } else {
            resetCompletion(.success(true))
            }
        }
    )}
    
    var body: some View{
        VStack{
            Text("Type in your Email adress and you will recieve an Email where you can reset your password")
            .multilineTextAlignment(.center)
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(.black)
            
            TextField("Email address", text: $email)
            .font(.system(size: 18))
            .padding(20)
            .background(Color(.systemGray6))
            .cornerRadius(5.0)
            
            Button (action: {
                self.resetPassword(email: self.email) {(result) in
                    switch result {
                    case .failure(let error):
                        self.errString = error.localizedDescription
                    case .success( _):
                        break
                    }
                    self.showAlert = true
                }
            }) {
            Text("Reset My Password")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.black)
            .cornerRadius(35.0)
            .padding(.top, 30)
            
            
            
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Reset"),
                  message: Text(self.errString ?? "Success. Reet email sent successfully. Check your email"),
                  dismissButton: .default(Text("OK")){ self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
