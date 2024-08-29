//
//  FetchDetails.swift
//  iosTask
//
//  Created by kaustubh.pingle on 27/08/24.
//

import Foundation

class MovieService {
    func fetchMovieDetails(query: String, completion: @escaping (Result<MovieDetailsResponse, Error>) -> Void) {
        let apiKey = "ba6111b3"
        let urlString = "https://www.omdbapi.com/?apikey=\(apiKey)&type=movie&s=\(query)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            print(data)
            do {
                let decoder = JSONDecoder()
                            let movieDetails = try decoder.decode(MovieDetailsResponse.self, from: data)
                            completion(.success(movieDetails))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
  
      

    
    func fetchMovieDetailss(movieID: String, completion: @escaping (Result<Movies, Error>) -> Void) {
        
            let    apiKey = "ba6111b3"
            let baseURL = "https://www.omdbapi.com/"

            let urlString = "\(baseURL)?i=\(movieID)&apikey=\(apiKey)"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let movieDetails = try decoder.decode(Movies.self, from: data)
                    completion(.success(movieDetails))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    

