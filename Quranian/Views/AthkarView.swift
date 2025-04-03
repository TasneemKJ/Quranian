import SwiftUI

struct AthkarView: View {
    @State private var selectedIndex = 0
    @State private var items: [ZekrItem] = []
    @State private var repeatCounts: [Int: Int] = [:]

    private let categories: [ZekrCategory] = [
        ZekrCategory(title: "أذكار الصباح", fileName: "sabah"),
        ZekrCategory(title: "أذكار المساء", fileName: "masaa"),
        ZekrCategory(title: "أذكار بعد الصلاة", fileName: "prayer")
    ]

    var body: some View {
        NavigationView {
            VStack() {
                Picker("نوع الذكر", selection: $selectedIndex) {
                    ForEach(0..<categories.count, id: \.self) { i in
                        Text(categories[i].title).tag(i)
                    }
                }
                .pickerStyle(.segmented)

                List {
                    ForEach(items) { item in
                        Button(action: {
                            let current = repeatCounts[item.id, default: 0]
                            if current < item.repeatCount {
                                repeatCounts[item.id] = current + 1
                            } else {
                                repeatCounts[item.id] = 0
                            }
                        }) {
                            VStack(spacing: 16) {
                                VStack(spacing: 8) {
                                    Text(item.zekr)
                                        .padding(.bottom, 10)
                                        .foregroundColor(.primary)
                                        .frame(
                                            maxWidth: .infinity,
                                            alignment: .leading
                                        )
                                
                                    if !item.bless.isEmpty {
                                        Text("\(item.bless)")
                                            .font(.footnote)
                                            .foregroundColor(.green)
                                            .padding(.bottom, 10)
                                            .frame(
                                                maxWidth: .infinity,
                                                alignment: .leading
                                            )
                                    }
                                
                                    Button(action: {
                                        repeatCounts[item.id] = 0
                                    }) {
                                        Text(
                                            "\(repeatCounts[item.id, default: 0])/\(item.repeatCount) 🔁"
                                        )
                                        .font(.caption)
                                        .padding(6)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(12)
                                        .frame(
                                            maxWidth: .infinity,
                                            alignment: .trailing
                                        )
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemBackground))
                                .cornerRadius(20)
                            }
                        }
                        .padding(.bottom, 8)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
                .background(Color(.systemBackground))
            }
            .navigationTitle("")
            .environment(\.layoutDirection, .rightToLeft)
            .onAppear {
                items = ZekrLoader
                    .load(fileName: categories[selectedIndex].fileName)
                repeatCounts = [:]
            }
            .onChange(of: selectedIndex) { newIndex in
                items = ZekrLoader.load(fileName: categories[newIndex].fileName)
                repeatCounts = [:]
            }
        }
    }
}

struct ZekrLoader {
    static func load(fileName: String) -> [ZekrItem] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("⚠️ File \(fileName).json not found.")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let zekr = try JSONDecoder().decode(Zekr.self, from: data)
            return zekr.content
        } catch {
            print("❌ Failed to load \(fileName): \(error)")
            return []
        }
    }
}
