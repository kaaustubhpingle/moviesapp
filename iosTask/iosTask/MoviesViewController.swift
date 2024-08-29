//
//  MoviesViewController.swift
//  iosTask
//
//  Created by kaustubh.pingle on 27/08/24.
//

import UIKit

class MoviesViewController: UIViewController, UISearchBarDelegate, MovieTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    private var movies: [Movie] = []
      private var filteredMovies: [Movie] = []
      private let movieService = MovieService()
      private var isLoading = false {
          didSet {
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }
          }
      }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
                tableView.dataSource = self
                tableView.delegate = self
                searchBar.text = ""
                searchMovies(query: "Don")
        
    }
    
    private func searchMovies(query: String) {
           isLoading = true
        movieService.fetchMovieDetails(query: query) { [weak self] result in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   switch result {
                   case .success(let response):
                       self?.movies = response.search ?? []
                       self?.filteredMovies = self?.movies ?? []
                       self?.tableView.reloadData()
                   case .failure(let error):
                       print("Error fetching movies: \(error.localizedDescription)")
                       // Optionally, you can show an alert or an error message here
                   }
               }
           }
       }
       
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          filterMovies(with: searchText)
      }
      
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          searchBar.resignFirstResponder()
          if let query = searchBar.text, !query.isEmpty {
              searchMovies(query: query)
          }
      }
    
    private func filterMovies(with query: String) {
            if query.isEmpty {
                filteredMovies = movies
            } else {
                filteredMovies = movies.filter { movie in
                    movie.title?.localizedCaseInsensitiveContains(query) ?? false
                }
            }
            tableView.reloadData()
        }
   
    
    func didTapFavoriteButton(on cell: MovieTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let movie = filteredMovies[indexPath.row]
        saveMovieToFavorites(movie)
    }
    
    private func saveMovieToFavorites(_ movie: Movie) {
        var favorites = loadFavorites()
        if let imdbID = movie.imdbID {
            if favorites.contains(imdbID) {
                // Remove from favorites if it's already added
                favorites.removeAll { $0 == imdbID }
            } else {
                // Add to favorites
                favorites.append(imdbID)
            }
            // Save the updated favorites list
            UserDefaults.standard.set(favorites, forKey: "FavoriteMovies")
        }
    }
    
    private func loadFavorites() -> [String] {
        
        return UserDefaults.standard.stringArray(forKey: "FavoriteMovies") ?? []
    }
}
    
//       private func filterMovies() {
//           let query = searchBar.text ?? ""
//           if query.isEmpty {
//               filteredMovies = movies
//           } else {
//               filteredMovies = movies.filter { movie in
//                   movie.Title?.localizedCaseInsensitiveContains(query) ?? false
//               }
//           }
//           tableView.reloadData()
//       }
 


extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
               return UITableViewCell()
           }
           
           let movie = filteredMovies[indexPath.row]
           
        cell.titleLabel.text = movie.title
           cell.yearLabel.text = movie.year
           
           if let posterURL = movie.poster, let url = URL(string: posterURL) {
               URLSession.shared.dataTask(with: url) { data, _, _ in
                   if let data = data {
                       DispatchQueue.main.async {
                           cell.posterImageView.image = UIImage(data: data)
                           cell.setNeedsLayout()
                       }
                   }
               }.resume()
           }
        cell.delegate = self
                // Optionally update the button state if needed
                if let imdbID = movie.imdbID, loadFavorites().contains(imdbID) {
                    cell.ButtonFav.setImage(UIImage(named: "fav"), for: .normal)
                } else {
                    cell.ButtonFav.setImage(UIImage(named: "unfav"), for: .normal)
                    
                }
           return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let moviee = filteredMovies[indexPath.row]
        showMovieDetail(for: moviee)
        }
    private func showMovieDetail(for movie: Movie) {
        print("Navigating to detail view controller")
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           guard let detailVC = storyboard.instantiateViewController(withIdentifier: "MoviesDetailViewController") as? MoviesDetailViewController else {
               
               return
           }

        detailVC.movieID = movie.imdbID

           navigationController?.pushViewController(detailVC, animated: true)
       }
}
