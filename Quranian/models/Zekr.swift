//
//  ZekrItem.swift
//  Quranian
//
//  Created by Tasnim Almousa on 03/04/2025.
//

import Foundation

struct Zekr: Codable, Identifiable {
    var id: UUID { UUID() }
    var title: String
    var content: [ZekrItem]
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
    }
}

struct ZekrItem: Identifiable, Codable {
    var id: Int
    let zekr: String
    let repeatCount: Int
    let bless: String

    enum CodingKeys: String, CodingKey {
        case id, zekr, bless
        case repeatCount = "repeat"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id =  try container.decode(Int.self, forKey: .id)
        self.zekr = try container.decode(String.self, forKey: .zekr)
        self.repeatCount = try container.decode(Int.self, forKey: .repeatCount)
        self.bless = try container.decode(String.self, forKey: .bless)
    }

    init(id: Int, zekr: String, repeatCount: Int, bless: String) {
        self.id = id
        self.zekr = zekr
        self.repeatCount = repeatCount
        self.bless = bless
    }
}

struct ZekrCategory {
    let title: String
    let fileName: String
}
