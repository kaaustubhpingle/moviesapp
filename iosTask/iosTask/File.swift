//
//  File.swift
//  iosTask
//
//  Created by kaustubh.pingle on 27/08/24.
//

import Foundation

struct MovieDetailsResponse: Codable {
    let search: [Movie]?
    let totalResults: String?
    let response: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

struct Movie: Codable {
    let title: String?
    let year: String?
    let imdbID: String?
    let type: String?
    let poster: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
    }
}
