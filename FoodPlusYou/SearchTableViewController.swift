//
//  SearchTableViewController.swift
//  DayAndSearch
//
//  Created by Zoë Klapman on 10/11/21.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchResultsBar: UISearchBar!

    let newFoodModel = NewFoodModel.sharedInstance
    
    var selectedIndexPath: IndexPath?
    var searchResultsController = UISearchBar()
    
    var delegate: CustomSectionHeaderDelegate?
    var currentDate: Date?
    var currentDateString: String?
    
    var mealInput: MealTypes?
    
    var query = "Cookies `n Cream"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Search"
        
        searchResultsBar.delegate = self
        searchResultsBar.searchTextField.textColor = UIColor(named: "TextColor")
        searchResultsBar.searchTextField.backgroundColor = UIColor(named: "TextColor2")
        
        // API
        //getSearchInstant()
        // postNaturalNutrients()
        // getSearchItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // reload selective rows or refresh the table data
        // tableView.reloadData()
    }
    
    // MARK: API
    func getSearchInstant(searchFor search: String) {
        // running asynchronously
        newFoodModel.fetchFoodItems(searchFor: search) {
            result in
            if result {
                // update UI
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.postNaturalNutrients(searchFor: self.newFoodModel.fetchedFoodItems!.common[0].food_name)
                }
            }
        }
    }
    
    // POST request for /v2/natural/nutrients
    // "common food" - use "food_name" as "query"
    func postNaturalNutrients(searchFor query: String) {
        newFoodModel.getCommonFoodNutrients(searchFor: query) {
            result in
            if result {
                print("Completion worked")
            }
        }
    }
    
    // GET request for /v2/search/item
    // "branded" food - use "nix_item_id" as search item endpoint
    func getSearchItem() {
        newFoodModel.getBrandedFoodNutrients(searchFor: query) {
            result in
            if result {
                print("Completion worked")
            }
        }
    }
    
    // search functions
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // api call
        guard let search = searchBar.text else { return }
        getSearchInstant(searchFor: search)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (newFoodModel.fetchedFoodItems?.common.count ?? 0) + (newFoodModel.fetchedFoodItems?.branded.count ?? 0)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // set UITableViewCells properties
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodSearchCell", for: indexPath) as! FoodSearchTableViewCell
                
        let thisFood = newFoodModel.allFoods[indexPath.row]
        
        cell.foodName.text = thisFood.brand_name_item_name ?? thisFood.food_name
        cell.foodImage.loadRemote(urlString: thisFood.photo.thumb)
        
        return cell
    }
    
    // set row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - TableView Delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Performing detailSegue in tableView function...")
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "detailSegue", sender: self)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = selectedIndexPath {
            // let selectedFood = foodModel.foodItems[indexPath.row]
            // let detailFood = foodModel.getFoodInfo(forFoodId: selectedFood.properties.foodId)
            
            // let selectedFood = items[indexPath.row]
            // let detailFood = items[indexPath.row].macros
            
            if(segue.identifier == "detailSegue") {
                print("Performing detailSegue in prepare function...")
                let dvc = segue.destination as! FoodDetailViewController
                // dvc.selectedFood = detailFood
                dvc.selectedFood = newFoodModel.allFoods[indexPath.row]
                dvc.delegate = delegate
                dvc.currentDate = currentDate
                dvc.currentDateString = currentDateString
                dvc.mealInput = mealInput
            }
        }
    }

}

// TODO: get image from URL
extension UIImageView {
    func loadRemote(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
