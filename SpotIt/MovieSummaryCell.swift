//
//  MovieSummaryCell.swift
//  SpotIt
//
//  Created by Gabriel Theodoropoulos on 11/11/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

class MovieSummaryCell: UITableViewCell {

    @IBOutlet weak var imgMovieImage: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    
    // MARK: - setupCell
    func setupCell(movieInfoDic: [String:String]){
        self.imgMovieImage.image = UIImage(named: movieInfoDic["Image"]!)
        self.lblTitle.text = movieInfoDic["Title"]!
        self.lblRating.text = movieInfoDic["Rating"]
        self.lblDescription.text = movieInfoDic["Description"]
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblRating.layer.cornerRadius = lblRating.frame.size.width/2
        lblRating.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
