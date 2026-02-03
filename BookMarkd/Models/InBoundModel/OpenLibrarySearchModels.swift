import Foundation

struct OpenLibrarySearchResponse: Decodable {
    let numFound: Int?
    let start: Int?
    let numFoundExact: Bool?
    let numFoundAlt: Int? // maps from num_found
    let documentationURL: String?
    let query: String?
    let offset: Int?
    let docs: [OpenLibraryDoc]

    private enum CodingKeys: String, CodingKey {
        case numFound
        case start
        case numFoundExact
        case numFoundAlt = "num_found"
        case documentationURL = "documentation_url"
        case query = "q"
        case offset
        case docs
    }
}

struct OpenLibraryDoc: Decodable {
    let authorKeys: [String]?
    let authorNames: [String]?
    let coverEditionKey: String?
    let coverID: Int?
    let ebookAccess: String?
    let editionCount: Int?
    let firstPublishYear: Int?
    let hasFullText: Bool?
    let workKey: String?
    let languages: [String]?
    let publicScan: Bool?
    let title: String?

    private enum CodingKeys: String, CodingKey {
        case authorKeys = "author_key"
        case authorNames = "author_name"
        case coverEditionKey = "cover_edition_key"
        case coverID = "cover_i"
        case ebookAccess = "ebook_access"
        case editionCount = "edition_count"
        case firstPublishYear = "first_publish_year"
        case hasFullText = "has_fulltext"
        case workKey = "key"
        case languages = "language"
        case publicScan = "public_scan_b"
        case title
    }
}
