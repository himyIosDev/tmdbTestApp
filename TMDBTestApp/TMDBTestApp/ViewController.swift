//
//  ViewController.swift
//  TMDBTestApp
//
//  Created by dev on 03/02/2024.
//

import UIKit
import SDWebImage
import JGProgressHUD


/// Due to unavailbility of mac book because i dont own macbook as i mentioned it to the HR of SWIPBox .. it took me tonger then expected .. i got mac book on sunday morning and due to short time
/// i have done my best shot .. plesae do consider this short time effort .. thanks
///
/// there are 2 coapods used for the handling of the image and loader during the api request
///
/// one them is sd web image which automatically handles the image catche and shows the image on the image view with placeholder
/// the other one is progress loader so that user get to know taking is under process,


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var moviesCollectionView : UICollectionView!
    
    var movieList = [PopularMovies]()
    let hud = JGProgressHUD()
    
    let imgeBaseURL = "https://image.tmdb.org/t/p/w300"
    let apiKey = "4512c6c555c83c726395858731cb59a4"
    
    let popularMoviesApiURL = "https:api.themoviedb.org/3/movie/popular?api_key=4512c6c555c83c726395858731cb59a4&page=1"

    // **************************************************************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPopularMovies()
    }
    
    // **************************************************************
    
    override func viewDidAppear(_ animated: Bool) {
        
        hud.show(in: self.view)
        self.moviesCollectionView.reloadData()
        hud.dismiss()
    }
 
    // **************************************************************
    
    func getPopularMovies()
    {
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
                
                if let responseObj = response as? [String:Any]
                {
                    if let arr = responseObj["results"] as? [[String : Any]]
                    {
                        for mov in arr
                        {
                            /// i created a class of popular movies so that we can have single object or array of movies object to show on the table or collection view
                            /// same thing spereate class for the movei detail also created
                            let movObj = PopularMovies(json: mov)
                            self.movieList.append(movObj)
                        }
                    }
                }
                
            }
            catch {
                print(error)
            }
        }
        
        self.moviesCollectionView.reloadData()
        hud.dismiss()
        task.resume()
    }
    
    // **************************************************************
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieList.count;
    }
    
    // **************************************************************
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let moiveObj = self.movieList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviesCollectionViewCell", for: indexPath) as! MoviesCollectionViewCell
        
        cell.titleLbl.text = moiveObj.title
        cell.subtitile.text = moiveObj.release_date
        cell.detail.text = moiveObj.original_language
        
//        let imgURL = "https://image.tmdb.org/t/p/original/2e853FDVSIso600RqAMunPxiZjq.jpg"
        // image poster form TMBD takes time to load due to high resoultion but i tried to make them smaller in size inshallah it will work enough for test purpose
        
        let imgURL = "\(self.imgeBaseURL)\(moiveObj.poster_path)"
        cell.img.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "imgPlaceholder.png"))
        
        print(imgURL)
        
        return cell
    }
    
    // **************************************************************
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.size.width - 40 , height: 200);
    }
    
    // **************************************************************
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // pusing the selected id of the movei to the next screen for the detail api to fetch data
        let obj = self.movieList[indexPath.item]
        vc.movieId = obj.id
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
