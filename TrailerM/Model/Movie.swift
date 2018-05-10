//
//  Movie.swift
//  TrailerM
//
//  Created by gisu kim on 2018-05-03.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

class Movie: NSObject {
    var adult                   : Bool?
    var id                      : Int?
    var original_title          : String?
    var popularity              : Double?
    var video                   : Bool?
    var poster_path             : String?
    var backdrop_path           : String?
    var belongs_to_collection   : [String : Any]?
    var genre                   : Genre?
    var imdb_id                 : String?
    var overview                : String?
    var release_date            : String?
    var runtime                 : Double?
    var vote_average            : Double?
    var video_key               : String?
    
    override init() {
        
    }
    
    init(dictionary: [String : Any]) {
        if dictionary["adult"] != nil {
            adult = dictionary["adult"] as? Bool
        }
        if dictionary["id"] != nil {
            id = dictionary["id"] as? Int
        }
        if dictionary["original_title"] != nil {
            original_title = dictionary["original_title"] as? String
        }
        if dictionary["popularity"] != nil {
            popularity = dictionary["popularity"] as? Double
        }
        if dictionary["video"] != nil {
            video = dictionary["video"] as? Bool
        }
        if dictionary["poster_path"] != nil {
            poster_path = dictionary["poster_path"] as? String
        }
        if dictionary["backdrop_path"] != nil {
            backdrop_path = dictionary["backdrop_path"] as? String
        }
        if dictionary["belongs_to_collection"] != nil {
            belongs_to_collection = dictionary["belongs_to_collection"] as? [String : Any]
        }
        if dictionary["genres"] != nil {   
            if let genreData = dictionary["genres"] as? [AnyObject], genreData.count != 0 {
                genre = Genre(dictionary: genreData[0] as! [String : Any])
            }
        }
        
        if dictionary["imdb_id"] != nil {
            imdb_id = dictionary["imdb_id"] as? String
        }
        if dictionary["overview"] != nil {
            overview = dictionary["overview"] as? String
        }
        if dictionary["release_date"] != nil {
            release_date = dictionary["release_date"] as? String
        }
        
        if dictionary["runtime"] != nil {
            runtime = dictionary["runtime"] as? Double
        }
        if dictionary["vote_average"] != nil {
            vote_average = dictionary["vote_average"] as? Double
        }
    }
}







