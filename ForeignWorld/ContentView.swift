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

    func getUser(){
        session.listen()
    }
    
    
    
    var body: some View {
        
            Group {
                if (session.session != nil) {
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
                  }.onAppear(perform: getUser)

      
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
        
    }
}

