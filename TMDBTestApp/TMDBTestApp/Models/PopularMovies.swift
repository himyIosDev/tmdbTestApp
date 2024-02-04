//
//  PopularMovies.swift
//  TMDBTestApp
//
//  Created by dev on 04/02/2024.
//

import UIKit

class PopularMovies: NSObject {
    
    var adult : Bool
    var id : Int
    var original_title : String
    var overview : String
    var poster_path : String
    var release_date : String
    var title : String
    var backdrop_path : String
    var original_language : String
    var popularity : Double
    
    override init()
    {
        self.adult = false
        self.id = 0
        self.original_title = ""
        self.overview = ""
        self.poster_path = ""
        self.release_date = ""
        self.title = ""
        self.backdrop_path = ""
        self.original_language = ""
        self.popularity = 0.0
    }
    
    init(json : [String :Any])
    {
        self.adult     = (json["adult"] as? Bool ?? false)
        self.id     = (json["id"] as? Int ?? 0)
        self.original_title   = json["original_title"] as? String ?? ""
        self.overview   = json["overview"] as? String ?? ""
        self.poster_path   = json["poster_path"] as? String ?? ""
        self.release_date   = json["release_date"] as? String ?? ""
        self.title   = json["title"] as? String ?? ""
        self.backdrop_path   = json["backdrop_path"] as? String ?? ""
        self.original_language   = json["original_language"] as? String ?? ""
        self.popularity   = json["popularity"] as? Double ?? 0.0
    }
}
