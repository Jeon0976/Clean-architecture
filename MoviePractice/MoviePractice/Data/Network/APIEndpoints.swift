//
//  APIEndpoints.swift
//  MoviePractice
//
//  Created by 전성훈 on 2023/10/23.
//

import Foundation

struct APIEndpoints {
    static func getSearchMovies(with moviesRequestDTO: MoviesSearchRequestDTO
    ) -> EndPoint<MoviesSearchResponseDTO> {
        return EndPoint(
            path: "3/search/movie",
            method: .get,
            queryParametersEncodable: moviesRequestDTO
        )
    }
    
    static func getTopRatedMovies(with moviesRequestDTO: MoviesTopRateRequestDTO) -> EndPoint<MoviesTopRatedResponseDTO> {
        return EndPoint(
            path: "3/movie/top_rated",
            method: .get,
            queryParametersEncodable: moviesRequestDTO
        )
    }
    
    static func getMoviePoster(path: String, width: Int) -> EndPoint<Data> {
        let sizes = [92, 154, 185, 342, 500, 780]
        let closestWidth = sizes
            .enumerated()
            .min { abs($0.1 - width) < abs($1.1 - width) }?
            .element ?? sizes.first!
        
        return EndPoint(
            path: "t/p/w\(closestWidth)\(path)",
            method: .get,
            responseDecoder: RawDataResponseDecoder()
        )
    }
}
