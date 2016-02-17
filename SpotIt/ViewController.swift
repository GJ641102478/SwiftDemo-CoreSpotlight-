//
//  ViewController.swift
//  SpotIt
//
//  Created by Gabriel Theodoropoulos on 11/11/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblMovies: UITableView!
    var movieInfo: NSMutableArray!
    var selectedMovieInfoIndex: Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadMovieInfoData()
        print(self.movieInfo)
        configureTableView()
        navigationItem.title = "Movies"
        setupSearchableContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
// MARK: - spotlightFuntions
    func setupSearchableContent(){
        var searchableItems = [CSSearchableItem]()
        for i in 0...(movieInfo.count - 1) {
            let movie = movieInfo[i] as! [String:String]
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            //Set the title.
            searchableItemAttributeSet.title = movie["Title"]!
            //Set the movie image.
            let imgPath = movie["Image"]!.componentsSeparatedByString(".")
            searchableItemAttributeSet.thumbnailURL = NSBundle.mainBundle().URLForResource(imgPath[0], withExtension: imgPath[1])
            // Set the description.
            searchableItemAttributeSet.contentDescription = movie["Description"]!
            
            // Set the SearchKey
            var keyWords = [String]()
            let movieCategories = movie["Category"]!.componentsSeparatedByString(",")
            for movieCategory in movieCategories{
                keyWords.append(movieCategory)
            }
            let stars = movie["Stars"]!.componentsSeparatedByString(",")
            for star in stars{
                keyWords.append(star)
            }
            searchableItemAttributeSet.keywords = keyWords
            let searchableItem = CSSearchableItem(uniqueIdentifier: "com.appcoda.SpotIt.\(i)", domainIdentifier: "movies", attributeSet: searchableItemAttributeSet)
            searchableItems.append(searchableItem)
        }
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(searchableItems) { (error) -> Void in
            if error != nil{
                print(error?.localizedDescription)
            }
        }
    }
    //handleEvenOfEntermovieDetailVC
    override func restoreUserActivityState(activity: NSUserActivity) {
        if activity.activityType == CSSearchableItemActionType{
            if let userInfo = activity.userInfo{
                let seletedMovie = userInfo[CSSearchableItemActivityIdentifier] as! String
                self.selectedMovieInfoIndex = Int(seletedMovie.componentsSeparatedByString(".").last!)
                self.performSegueWithIdentifier("idSegueShowMovieDetails", sender: self)
            }
        }
    }
    // MARK: Custom Functions
    
    func configureTableView() {
        tblMovies.delegate = self
        tblMovies.dataSource = self
        tblMovies.tableFooterView = UIView(frame: CGRectZero)
        tblMovies.registerNib(UINib(nibName: "MovieSummaryCell", bundle: nil), forCellReuseIdentifier: "idCellMovieSummary")
    }
    // MARK: - loadDataFunctions
    func loadMovieInfoData(){
        if let path = NSBundle.mainBundle().pathForResource("MoviesData", ofType: "plist"){
          movieInfo = NSMutableArray(contentsOfFile: path)
        }
    }
    
    // MARK:  UITableView Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.movieInfo != nil{
            return self.movieInfo.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellMovieSummary", forIndexPath: indexPath) as! MovieSummaryCell
        let movieInfoDic = self.movieInfo[indexPath.row] as! [String:String]
        cell.setupCell(movieInfoDic)
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.selectedMovieInfoIndex = indexPath.row
        self.performSegueWithIdentifier("idSegueShowMovieDetails", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifity = segue.identifier{
            if identifity == "idSegueShowMovieDetails"{
              let movieDetailVC = segue.destinationViewController as! MovieDetailsViewController
                movieDetailVC.movieInfoDic = self.movieInfo[self.selectedMovieInfoIndex] as! [String:String]
        }
        }
    }
}

