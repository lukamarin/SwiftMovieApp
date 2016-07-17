//
//  MovieTableViewController.swift
//  MovieApp
//
//  Created by Shah, Vipul A (US - Mumbai) on 14/09/15.
//  Copyright (c) 2015 Edureka. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke
import UIKit

class MovieTableViewController: UITableViewController {
    
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api-v2launch.trakt.tv/movies/trending?page=1&limit=50&extended=full,images"
        
        let headers   = ["trakt-api-version":"2","trakt-api-key":"a0c9e1842e5b4bd2fa07bd814a13659b5e6561b9d556144a6ddb73c838844a6b"]
        
        Alamofire.request(Method.GET, urlString,headers: headers).responseJSON {
            (_,_,result) -> Void in
            switch result {
            case .Success(let data):
                self.parseMovieJson(SwiftyJSON.JSON(data))
            case .Failure(_, let error):
                print((error as NSError).localizedDescription)
            }
        }
    }
    
    func parseMovieJson(json:SwiftyJSON.JSON){
        print(json.type)
        if let moviesArray = json.array {
            for movie in moviesArray {
                let movieClass = Movie()
                if let movieParentDictonary = movie.dictionary {
                    if let movieInfo = movieParentDictonary["movie"]?.dictionary {
                        if let title = movieInfo["title"]?.string {
                            movieClass.title = title
                        }
                        if let year = movieInfo["year"]?.int {
                            movieClass.year = year
                        }
                        if let tagline = movieInfo["tagline"]?.string {
                            movieClass.tagline = tagline
                        }
                        if let overview = movieInfo["overview"]?.string {
                            movieClass.overview = overview
                        }
                        if let released = movieInfo["released"]?.string {
                            movieClass.released = released
                        }
                        if let runtime = movieInfo["runtime"]?.int {
                            movieClass.runtime = runtime
                        }
                        if let rating = movieInfo["rating"]?.int {
                            movieClass.rating = rating
                        }
                        if let imagesDictionary = movieInfo["images"]?.dictionary {
                            if let fanartDictionary = imagesDictionary["fanart"]?.dictionary {
                                if let fanArtUrl = fanartDictionary["medium"]?.string {
                                    movieClass.imageUrl = fanArtUrl
                                }
                            }
                        }
                    }
                }
                self.movies.append(movieClass)
            }
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCellTableViewCell
        movieCell.movieTitle.text = movies[indexPath.row].title
        
        if let url = movies[indexPath.row].imageUrl {
            movieCell.moviePosterImageView.hnk_setImageFromURL((NSURL(string:url)!), placeholder: UIImage(named: "placeholder.png"))
        }
        
        return movieCell
    }
    
}
