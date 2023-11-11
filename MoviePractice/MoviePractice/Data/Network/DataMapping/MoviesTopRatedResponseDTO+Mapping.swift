//
//  MoviesTopRatedResponseDTO+Mapping.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/11/10.
//

import Foundation

struct MoviesTopRatedResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
    
    let page: Int
    let totalPages: Int
    let movies: [MovieTopRatedDTO]
}

extension MoviesTopRatedResponseDTO {
    struct MovieTopRatedDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case posterPath = "poster_path"
            case overview
            case releaseDate = "release_date"
            case rating = "vote_average"
            case ratingCount = "vote_count"
        }
        let id: Int
        let title: String?
        let posterPath: String?
        let overview: String?
        let releaseDate: String?
        let rating: Double?
        let ratingCount: Int
    }
}

extension MoviesTopRatedResponseDTO {
    func toDomain() -> MoviesTopRatedPage {
        return .init(page: page, totalPages: totalPages, movies: movies.map { $0.toDomain() })
    }
}

extension MoviesTopRatedResponseDTO.MovieTopRatedDTO {
    func toDomain() -> MovieWhenTopRated {
        return .init(
            id: MovieWhenTopRated.Identifier(id),
            title: title,
            posterPath: posterPath,
            overview: overview,
            releaseDate: dateFormatter.date(from: releaseDate ?? ""),
            rating: rating,
            ratingCount: ratingCount
        )
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
