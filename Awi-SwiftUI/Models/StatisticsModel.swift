import Foundation

struct Statistics: Codable {
    let totalGameSold: Int
    let totalTurnover: Double
    let totalOwedToSellers: Double
    let totalMargin: Double
    let salesData: [SalesDataItem]
}

struct SalesDataItem: Codable, Identifiable {
    let id = UUID()
    let time: Date
    let sales: Int

    enum CodingKeys: String, CodingKey {
        case time, sales
    }
}
