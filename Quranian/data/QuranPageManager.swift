//
//  QuranPageManager.swift
//  Quranian
//
//  Created by Tasnim Almousa on 07/04/2025.
//

import Foundation

class QuranPageManager: ObservableObject {
    private(set) var pages: [Int: [Verse]] = [:]

    init(verses: [Verse]) {
        for verse in verses {
            pages[verse.page, default: []].append(verse)
        }
    }

    var totalPages: Int {
        pages.keys.max() ?? 0
    }

    func getPage(_ number: Int) -> [Verse]? {
        return pages[number]
    }
}
