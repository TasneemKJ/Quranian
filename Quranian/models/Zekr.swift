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
    var id: UUID { UUID() }
    let zekr: String
    let repeatCount: Int
    let bless: String

    enum CodingKeys: String, CodingKey {
        case zekr, bless
        case repeatCount = "repeat"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.zekr = try container.decode(String.self, forKey: .zekr)
        self.repeatCount = try container.decode(Int.self, forKey: .repeatCount)
        self.bless = try container.decode(String.self, forKey: .bless)
    }

    init(zekr: String, repeatCount: Int, bless: String) {
        self.zekr = zekr
        self.repeatCount = repeatCount
        self.bless = bless
    }
}

struct ZekrCategory {
    let title: String
    let fileName: String
}
