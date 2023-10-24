//
//  MoviesResponseDTO+Mapping.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

struct MoviesResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
}

extension MoviesResponseDTO {
    struct MovieDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case genre
            case posterPath = "poster_path"
            case overview
            case releaseDate = "release_date"
        }
        enum GenreDTO: String, Decodable {
            case adventure
            case scienceFiction = "science_fiction"
        }
        let id: Int
        let title: String?
        let genre: GenreDTO?
        let posterPath: String?
        let overview: String?
        let releaseDate: String?
    }
}

extension MoviesResponseDTO {
    func toDomain() -> MoviesPage {
        return .init(page: page, totalPages: totalPages, movies: movies.map { $0.toDomain() })
    }
}

extension MoviesResponseDTO.MovieDTO {
    func toDomain() -> Movie {
        return .init(
            id: Movie.Identifier(id),
            title: title,
            genre: genre?.toDomain(),
            posterPath: posterPath,
            overview: overview,
            releaseDate: dateFormatter.date(from: releaseDate ?? ""))
    }
}

extension MoviesResponseDTO.MovieDTO.GenreDTO {
    func toDomain() -> Movie.Genre {
        switch self {
        case .adventure: return .adventure
        case .scienceFiction: return .scienceFiction
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "ko_KR")
    return formatter
}()
