//
//  CustomSectionHeader.swift
//  MidtermRemoveItem
//
//  Created by Zoë Klapman on 10/27/21.
//

import UIKit

class CustomSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    var mealType: MealTypes!
    var delegate: CustomSectionHeaderDelegate?
    //var selectedIndexPath: IndexPath?

    @IBAction func addItem(_ sender: UIButton) {
        
        //delegate?.addItemToCategory(mealType: self.mealType)
        //performSegue(withIdentifier: searchSegue, sender: UIButton)
        //prepare(for: UITableViewController, sender: sender)
        delegate?.pickItemToCategory(mealType: self.mealType)
        
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if selectedIndexPath != nil {
            if(segue.identifier == "searchSegue") {
                _ = segue.destination as! SearchTableViewController
            }
        }
    }*/

}
