//
//  MovieParser.swift
//

import Foundation
import os

nonisolated struct MovieParser: Sendable {
    private let decoder = JSONDecoder.decoder()

    func parseMovieResponse(from data: Data) throws -> MovieResponse {
        do {
            return try decoder.decode(MovieResponse.self, from: data)
        } catch {
            let logger = Logger(subsystem: "org.kurkin.neugelb", category: "MovieParser")
            logger.error("Failed to parse MovieResponse: \(error)")
            throw error
        }
    }
}

nonisolated extension JSONDecoder {
    static func decoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
