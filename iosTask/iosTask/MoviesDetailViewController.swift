//
//  MoviesDetailViewController.swift
//  iosTask
//
//  Created by kaustubh.pingle on 28/08/24.
//

import UIKit

class MoviesDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
        @IBOutlet weak var titleLabel: UILabel!
        @IBOutlet weak var yearLabel: UILabel!
        @IBOutlet weak var ratedLabel: UILabel!
        @IBOutlet weak var releasedLabel: UILabel!
        @IBOutlet weak var runtimeLabel: UILabel!
        @IBOutlet weak var genreLabel: UILabel!
        @IBOutlet weak var directorLabel: UILabel!
        @IBOutlet weak var writerLabel: UILabel!
        @IBOutlet weak var actorsLabel: UILabel!
        @IBOutlet weak var plotLabel: UILabel!
        @IBOutlet weak var languageLabel: UILabel!
        @IBOutlet weak var countryLabel: UILabel!
        @IBOutlet weak var awardsLabel: UILabel!
        @IBOutlet weak var imdbRatingLabel: UILabel!
        @IBOutlet weak var imdbVotesLabel: UILabel!

    var movieID: String?
    private let movieService = MovieService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movieID = movieID {
                   fetchMovieDetails(movieID: movieID)
               }
    }
    private func fetchMovieDetails(movieID: String) {
        movieService.fetchMovieDetailss(movieID: movieID) { [weak self] result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let movie):
                       self?.populateMovieDetails(movie: movie)
                   case .failure(let error):
                       print("Error fetching movie details: \(error.localizedDescription)")
                   }
               }
           }
       }

       private func populateMovieDetails(movie: Movies) {
           titleLabel.text = movie.title
           yearLabel.text = movie.year
           ratedLabel.text = movie.rated
           releasedLabel.text = movie.released
           runtimeLabel.text = movie.runtime
           genreLabel.text = movie.genre
           directorLabel.text = movie.director
           writerLabel.text = movie.writer
           actorsLabel.text = movie.actors
           plotLabel.text = movie.plot
           languageLabel.text = movie.language
           countryLabel.text = movie.country
           awardsLabel.text = movie.awards
           imdbRatingLabel.text = movie.imdbRating
           imdbVotesLabel.text = movie.imdbVotes

           if let posterURL = movie.poster, let url = URL(string: posterURL) {
               URLSession.shared.dataTask(with: url) { data, _, _ in
                   if let data = data {
                       DispatchQueue.main.async {
                           self.posterImageView.image = UIImage(data: data)
                       }
                   }
               }.resume()
           }
       }
   }



