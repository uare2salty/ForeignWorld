//
//  ContentView.swift
//  ForeignWorld
//
//  Created by Jonas Sollmann on 15.06.20.
//  Copyright © 2020 Jonas Sollmann. All rights reserved.
//

import SwiftUI
import Firebase
import Combine
import FirebaseAuth
import AuthenticationServices
import CryptoKit

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject private var viewModel = ForeignWordsViewModel()
    
    var user = Auth.auth().currentUser
    
    func EmailVerification() {
        user?.sendEmailVerification { (error) in
            
        }
    }
    func getUser(){
        Auth.auth().currentUser?.reload{(error) in}
        session.listen()
    }
    
    
    
    var body: some View {
        
            Group {
                if (user?.isEmailVerified == false && session.session != nil) {
                VStack{
                    Text("Verify Your Email now")
                    
                    Button(action: EmailVerification) {
                    Text("Verify Email Adress")
                          .font(.headline)
                          .foregroundColor(.white)
                          .padding()
                          .frame(width: 220, height: 60)
                          .background(Color.black)
                          .cornerRadius(35.0)
                          .padding(.top, 40)
                        
                    Button(action: session.signOut){
                        Text("Sign Out")
                                }
                            }
                        }
                
                


                } else {
                    if (user?.isEmailVerified == true && session.session != nil) {
                        TabView {
                              List(viewModel.ForeignWords) {ForeignWord in
                                  VStack {
                                      Text(ForeignWord.word)
                                          .font(.headline)
                                      Text(ForeignWord.spelling)
                                          .font(.subheadline)
                                      Text(ForeignWord.sentence)
                                  
                              }
                              }.onAppear() { self.viewModel.fetchData()
                              }
                                  
                                  
                                  .tabItem{
                                       Image(systemName: "house.fill")
                                       Text("Home")
                               
                              
                              }
                               
                              Text("Library")
                                  .tabItem {
                                      Image(systemName: "book.fill")
                                      Text("Library")
                                  
                              }
                              VStack {
                              Text("settings")
                                  
                                  Button(action: session.signOut){
                                      Text("Sign Out")
                                  }
                              }
                                  .tabItem{
                                      Text("settings")
                                  
                              }
                        }
                    } else {
                        AuthView()
                    }
                }
                  }.onAppear(perform: getUser)

      
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
        
    }
}

struct VerifyEmail: View {
    var user = Auth.auth().currentUser
    func EmailVerification() {
        user?.sendEmailVerification { (error) in
            
        }
    }
    
    var body: some View{
        VStack {
        Button(action: EmailVerification) {
        Text("Verify Email Adress")
              .font(.headline)
              .foregroundColor(.white)
              .padding()
              .frame(width: 220, height: 60)
              .background(Color.black)
              .cornerRadius(35.0)
              .padding(.top, 40)
            }
            
            
        }
    }
}
