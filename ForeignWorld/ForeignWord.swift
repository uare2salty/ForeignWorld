//
//  ForeignWord.swift
//  ForeignWorld
//
//  Created by Jonas Sollmann on 16.06.20.
//  Copyright © 2020 Jonas Sollmann. All rights reserved.
//

import Foundation

struct ForeignWord: Identifiable {
    var id: String = UUID().uuidString
    var synonym: String
    var sentence: String
    var spelling: String
    var word: String
}
