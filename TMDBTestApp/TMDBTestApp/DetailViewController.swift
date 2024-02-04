//
//  DetailViewController.swift
//  TMDBTestApp
//
//  Created by dev on 04/02/2024.
//

import UIKit
import SDWebImage
import JGProgressHUD

class DetailViewController: UIViewController {
    
    var movieId = 0;
    var movieDetailObj = MovieDetail()
    
    let imgeBaseURL = "https://image.tmdb.org/t/p/w300"
    let hud = JGProgressHUD()
    
    @IBOutlet weak var mainImg : UIImageView!
    
    @IBOutlet weak var duration : UILabel!
    @IBOutlet weak var titlee : UILabel!
    @IBOutlet weak var status : UILabel!
    @IBOutlet weak var language : UILabel!
    @IBOutlet weak var overView : UILabel!
    @IBOutlet weak var tagline : UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hud.show(in: self.view)
        getMovieDetail()
    }
    
    
    func getMovieDetail()
    {
        var popularMoviesApiURL = "https://api.themoviedb.org/3/movie/\(self.movieId)?api_key=4512c6c555c83c726395858731cb59a4"
        
        guard let url = URL(string: popularMoviesApiURL) else {
            return
        }
        
        print("making api call.... ")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                print(response)
                if let responseObj = response as? [String:Any]
                {
                    
                    self.movieDetailObj = MovieDetail(json: responseObj)
                    print(self.movieDetailObj)
                    
                    
                    DispatchQueue.main.async {
                        
//                        let imgURL = "https://i.pinimg.com/736x/00/48/a4/0048a42a46657305365b66511e289ae7.jpg"
//                        image poster form TMBD take time due to load
                        
                        let imgURL = "\(self.imgeBaseURL)\(self.movieDetailObj.backdrop_path)"
                        self.mainImg.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "imgPlaceholder.png"))
                        
                        self.titlee.text = self.movieDetailObj.title
                        self.tagline.text = self.movieDetailObj.tagline
                        self.duration.text = String(self.movieDetailObj.runtime)
                        self.language.text = self.movieDetailObj.original_language
                        self.status.text = self.movieDetailObj.status
                        self.overView.text = self.movieDetailObj.overview
                        self.hud.dismiss()
                    }
                }
                
            }
            catch {
                print(error)
            }
        }
        
//        self.moviesCollectionView.reloadData()
        task.resume()
    }
}
