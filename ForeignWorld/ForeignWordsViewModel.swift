//
//  ForeignWordsView.swift
//  ForeignWorld
//
//  Created by Jonas Sollmann on 16.06.20.
//  Copyright © 2020 Jonas Sollmann. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ForeignWordsViewModel: ObservableObject {
    @Published var ForeignWords = [ForeignWord]()
        
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("ForeignWords").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.ForeignWords = documents.map { (queryDocumentSnapshot) -> ForeignWord in
                let data = queryDocumentSnapshot.data()
                
                let synonym = data["synonym"] as? String ?? ""
                let sentence = data["sentence"] as? String ?? ""
                let spelling = data["spelling"] as? String ?? ""
                let word = data["word"] as? String ?? ""
                
                return ForeignWord(synonym: synonym, sentence: sentence, spelling: spelling, word: word)
            }
        }
    }
}

