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
                    v.surahNumber = surah.number
                    return v
                }
            }

        } catch {
            fatalError("Decoding error: \(error)")
        }
    }
    
    static func getSurahList() -> [SurahInfo] {
        guard let url = Bundle.main.url(forResource: "database", withExtension: "json") else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let surahs = try decoder.decode([Surah].self, from: data)

            return surahs.map {
                SurahInfo(
                    id: $0.number,
                    nameAr: $0.name.ar,
                    nameEn: $0.name.en,
                    page: $0.verses.first?.page ?? 1
                )
            }
        } catch {
            print("Failed to load surah list: \(error)")
            return []
        }
    }
}
