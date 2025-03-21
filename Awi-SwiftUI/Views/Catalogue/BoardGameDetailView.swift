import SwiftUI

struct BoardGameDetailView: View {
    let bgDetail: BGDetail
    
    // Formatter that formats the year without grouping separators.
    private var yearFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = false
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                Text(bgDetail.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Description
                Text(bgDetail.description)
                    .font(.body)
                
                Divider()
                
                // Fixed layout for additional details
                HStack {
                    Text("Year Published:")
                    Spacer()
                    let yearString = bgDetail.yearPublished.flatMap { yearFormatter.string(from: NSNumber(value: $0)) } ?? "N/A"
                    Text(yearString)
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                HStack {
                    Text("Players:")
                    Spacer()
                    if let minP = bgDetail.minPlayers, let maxP = bgDetail.maxPlayers {
                        Text("\(minP) - \(maxP)")
                    } else {
                        Text("N/A")
                    }
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                HStack {
                    Text("Min Age:")
                    Spacer()
                    Text(bgDetail.minAge.map { "\($0)" } ?? "N/A")
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                HStack {
                    Text("Playtime:")
                    Spacer()
                    if let playtime = bgDetail.minPlaytime {
                        Text("\(playtime) mins")
                    } else {
                        Text("N/A")
                    }
                }
                .font(.caption)
                .foregroundColor(.gray)
                
                HStack {
                    Text("Editor:")
                    Spacer()
                    Text(bgDetail.editorName ?? "N/A")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding()
        }
        .navigationTitle(bgDetail.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BoardGameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleDetail = BGDetail(
            name: "7 Wonders",
            description: "A card drafting game where players lead a civilization to victory by constructing buildings and wonders.",
            yearPublished: 2010,
            minPlayers: 2,
            maxPlayers: 7,
            minAge: 10,
            minPlaytime: 30,
            idEditorPublic: "31d44f77-1dba-4d46-99c5-3dd54c8caf0a",
            editorName: "Repos Production"
        )
        NavigationView {
            BoardGameDetailView(bgDetail: sampleDetail)
        }
    }
}