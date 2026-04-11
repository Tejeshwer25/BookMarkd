import Foundation

#if canImport(FoundationModels)
import FoundationModels
#endif

public struct BookMetadata: Codable, Equatable {
    public let title: String
    public let author: String
    public let description: String
    public let genres: [String]

    public init(title: String, author: String, description: String, genres: [String]) {
        self.title = title
        self.author = author
        self.description = description
        self.genres = genres
    }
}

public final class BookMetadataExtractor {
    public static let shared = BookMetadataExtractor()

    private init() {}

    public func extract(from ocrText: String) async -> BookMetadata {
#if canImport(FoundationModels)
        do {
            if #available(macOS 14, iOS 17, tvOS 17, watchOS 10, *) {
                let promptSystem = """
                You are a helpful assistant that extracts book metadata from raw OCR text.
                The response must be strict JSON with the following structure:
                {"title":"","author":"","description":"","genres":[""]}
                Return only the JSON, no explanations.
                """
                let promptUser = """
                Extract book metadata from the following OCR text:
                \"\"\"
                \(ocrText)
                \"\"\"
                """

                let conversation = [
                    ChatMessage(role: .system, content: promptSystem),
                    ChatMessage(role: .user, content: promptUser)
                ]

                let chat = try ChatModel.shared.chat()
                let response = try await chat.send(conversation: conversation)

                guard let jsonData = response.choices.first?.message.content.data(using: .utf8) else {
                    return heuristicExtract(from: ocrText)
                }

                let decoded = try JSONDecoder().decode(BookMetadata.self, from: jsonData)
                return decoded
            } else {
                return heuristicExtract(from: ocrText)
            }
        } catch {
            return heuristicExtract(from: ocrText)
        }
#else
        return heuristicExtract(from: ocrText)
#endif
    }

    private func heuristicExtract(from text: String) -> BookMetadata {
        // Simple heuristic:
        // - Title: first non-empty line
        // - Author: first line containing "by " or second non-empty line
        // - Description: first paragraph after first two lines
        // - Genres: detect common genres present in text

        let lines = text
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        // Title
        let title = lines.first ?? ""

        // Author
        var author = ""
        if lines.count > 1 {
            for line in lines[1...min(lines.count-1, 5)] {
                if line.lowercased().contains("by ") {
                    author = line.replacingOccurrences(of: "by ", with: "", options: .caseInsensitive)
                    break
                }
            }
            if author.isEmpty {
                author = lines.count > 1 ? lines[1] : ""
            }
        }

        // Description heuristic: lines after first 2 lines joined until empty line or max 1000 chars
        var descriptionLines: [String] = []
        if lines.count > 2 {
            for line in lines[2...] {
                if line.isEmpty { break }
                if descriptionLines.joined(separator: " ").count > 1000 { break }
                descriptionLines.append(line)
            }
        }
        let description = descriptionLines.joined(separator: " ")

        // Genres heuristic - common genres to detect
        let commonGenres = [
            "Fantasy", "Science Fiction", "Romance", "Thriller", "Mystery",
            "Historical", "Horror", "Non-Fiction", "Biography", "Self-Help",
            "Adventure", "Young Adult", "Children", "Classic", "Drama"
        ]
        var genres: [String] = []
        let loweredText = text.lowercased()
        for genre in commonGenres {
            if loweredText.contains(genre.lowercased()) {
                genres.append(genre)
            }
        }

        return BookMetadata(
            title: title,
            author: author,
            description: description,
            genres: genres
        )
    }
}
