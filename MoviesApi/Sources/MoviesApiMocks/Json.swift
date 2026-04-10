//
//  Json.swift
//

import Foundation

public extension Data {
    static func validList(range: Range<Int> = 1..<3, total: Int = 5) -> Self {
        let list = range.map {
            """
            {
                "id": \($0),
                "title": "Test Movie \($0)",
                "overview": "A test movie",
                "poster_path": "/test.jpg",
                "release_date": "2025-01-01",
                "vote_average": 7.5
            }
            """
        }.joined(separator: ", ")
        return """
        {
            "results": [\(list)],
            "total_pages": \(total)
        }
        """.data(using: .utf8)!
    }

    static var validList: Self {
    """
    {
        "results": [
            {
                "id": 1,
                "title": "Test Movie 1",
                "overview": "A test movie",
                "poster_path": "/test.jpg",
                "release_date": "2025-01-01",
                "vote_average": 7.5
            }
        ],
        "total_pages": 5
    }
    """.data(using: .utf8)!
    }
    
    static var lowDataList: Self {
    """
    {
        "results": [
            {
                "id": 2,
                "title": "No Poster",
                "overview": "Missing fields",
                "poster_path": null,
                "release_date": null,
                "vote_average": 6.0
            }
        ],
        "total_pages": 1
    }
    """.data(using: .utf8)!
    }
    
    static var invalidDataList: Self {
    """
    {
        "results": [
            {
                "id": 1,
                "overview": "Missing title",
                "vote_average": 5.0
            }
        ],
        "total_pages": 1
    }
    """.data(using: .utf8)!
    }
}
