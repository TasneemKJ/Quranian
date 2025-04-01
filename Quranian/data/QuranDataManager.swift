//
//  QuranDataManager.swift
//  Quranian
//
//  Created by Tasnim Almousa on 01/04/2025.
//


import Foundation

class QuranDataManager: ObservableObject {
    @Published var surahs: [Surah] = []
    @Published var isLoading = false
    @Published var error: Error?
    
    init() {
        loadSurahs()
    }
    
    func loadSurahs() {
        isLoading = true
        DispatchQueue.global(qos: .userInitiated).async {
            guard let url = Bundle.main.url(forResource: "quran", withExtension: "json") else {
                DispatchQueue.main.async {
                    self.error = NSError(domain: "", code: 0,
                                       userInfo: [NSLocalizedDescriptionKey: "لم يتم العثور على بيانات القرآن"])
                    self.isLoading = false
                }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let surahs = try decoder.decode([Surah].self, from: data)
                
                DispatchQueue.main.async {
                    self.surahs = surahs
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
}
