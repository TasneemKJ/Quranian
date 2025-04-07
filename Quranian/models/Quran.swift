//
//  Quran.swift
//  Quranian
//
//  Created by Tasnim Almousa on 07/04/2025.
//

struct QuranData: Codable {
    let surahs: [Surah]
    
    enum CodingKeys: String, CodingKey {
        case surahs = ""
    }
}

struct Surah: Codable, Identifiable {
    let number: Int
    let name: SurahName
    let verses: [Verse]

    var id: Int { number }
}

struct SurahName: Codable {
    let ar: String
    let en: String
    let transliteration: String
}

struct Verse: Codable, Identifiable {
    let number: Int
    let text: VerseText
    let page: Int
    let juz: Int
    let sajda: Sajda
    
    var surahName: SurahName?
    
    var id: Int { number }
}

struct VerseText: Codable {
    let ar: String
    let en: String
}

enum Sajda: Codable {
    case flag(Bool)
    case detail(SajdaDetail)

    struct SajdaDetail: Codable {
        let recommended: Bool?
        let obligatory: Bool?
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let boolValue = try? container.decode(Bool.self) {
            self = .flag(boolValue)
        } else if let detail = try? container.decode(SajdaDetail.self) {
            self = .detail(detail)
        } else {
            throw DecodingError.typeMismatch(
                Sajda.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                debugDescription: "Sajda must be Bool or SajdaDetail")
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .flag(let boolValue):
            try container.encode(boolValue)
        case .detail(let detail):
            try container.encode(detail)
        }
    }
}
