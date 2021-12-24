//
//  FoodSearchTableViewCell.swift
//  DayAndSearch
//
//  Created by Zoë Klapman on 10/19/21.
//

import UIKit

class FoodSearchTableViewCell: UITableViewCell {
    var foodImageURL: String = ""
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // foodImage.loadRemote(urlString: foodImageURL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
