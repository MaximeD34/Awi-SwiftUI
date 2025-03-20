import Foundation

struct CatalogueResponse: Decodable {
    let data: [Game]
    let pagination: Pagination
}

struct Pagination: Decodable {
    let current_page: Int
    let total_pages: Int
    let page_size: String
    let total_items: Int
}
