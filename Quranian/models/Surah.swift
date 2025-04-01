//
//  Surah.swift
//  Quranian
//
//  Created by Tasnim Almousa on 01/04/2025.
//


import Foundation

struct Surah: Codable, Identifiable {
    let id: Int
    let name: String
    let ayahs: [Verse]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case ayahs = "verses"
    }
}

struct Verse: Codable, Identifiable {
    let id: Int
    let text: String
}
