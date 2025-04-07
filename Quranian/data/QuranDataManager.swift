//
//  QuranDataManager.swift
//  Quranian
//
//  Created by Tasnim Almousa on 01/04/2025.
//


import Foundation

class QuranDataManager {
    static func loadFromJSON() -> [Verse] {
        guard let url = Bundle.main.url(forResource: "database", withExtension: "json") else {
            fatalError("Missing database.json in Bundle.")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let surahs = try decoder.decode([Surah].self, from: data)
            return surahs.flatMap { surah in
                surah.verses.map { verse in
                    var v = verse
                    v.surahName = surah.name
                    return v
                }
            }

        } catch {
            fatalError("Decoding error: \(error)")
        }
    }
}
