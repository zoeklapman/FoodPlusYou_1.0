//
//  FoodDetailViewController.swift
//  DayAndSearch
//
//  Created by Zoë Klapman on 10/19/21.
//

import UIKit

class FoodDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var servingsValue: UILabel!
    @IBOutlet weak var servingStepper: UIStepper!
    @IBOutlet weak var macrosList: UITableView!
    @IBOutlet weak var addItem: UIBarButtonItem!
    
    let consumpModel = ConsumptionModel.sharedInstance
    let newFoodModel = NewFoodModel.sharedInstance

    var selectedFood: Food?
    
    var delegate: CustomSectionHeaderDelegate?
    var mealType: MealTypes?
    
    // used to add MealItem
    var mealItem: MealItem?
    var currentDate: Date?
    var currentDateString: String?
    var mealInput: MealTypes?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.macrosList.dataSource = self
        self.macrosList.delegate = self

        self.title = selectedFood?.brand_name_item_name ?? selectedFood?.food_name
        
        setImage()
        
        // self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: nil, menu: menuItems())
        addItem = self.navigationItem.rightBarButtonItem
        // addItem.tintColor = .brown
        
        // setup UIStepper
        servingsValue.text = "1"
        servingStepper.wraps = true
        servingStepper.autorepeat = true
        servingStepper.minimumValue = 1
        servingStepper.maximumValue = 10
        servingStepper.layer.cornerRadius = 10
        
        print("mealInput: \(String(describing: mealInput))")
        
        // update macrosList with macros data for the selected food item
        if let query = selectedFood?.nix_item_id ?? selectedFood?.food_name {
            // check if query is nix_item_id or food_name
            if selectedFood?.nix_item_id != nil {
                newFoodModel.getBrandedFoodNutrients(searchFor: query) {
                    result in
                    if result {
                        // update UI
                        DispatchQueue.main.async {
                            self.macrosList.reloadData()
                        }
                    }
                }
            } else {
                newFoodModel.getCommonFoodNutrients(searchFor: query) {
                    result in
                    if result {
                        // update UI
                        DispatchQueue.main.async {
                            self.macrosList.reloadData()
                        }
                    }
                }
            }
            
        }
        
        setImage()
    }
    
    // set the foodImage based on what food was selected
    func setImage() {
        if let thisFood = selectedFood {
            // foodImage.image = UIImage(named: thisFood.image)
            foodImage.loadRemote(urlString: thisFood.photo.thumb)
        }
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        servingsValue.text = Int(sender.value).description
        
        // refresh the tableview cells if the stepperValue is changed
        print("Reloading tableView data...")
        macrosList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodItem", for: indexPath)
        
        // create meal item when adjusting for servingSize
        let servingsInt = Int(self.servingsValue.text ?? "1")
        // var mealItem: MealItem
        if let thisFood = newFoodModel.selectedFoodItem {
            self.mealItem = consumpModel.addMealItem(foodItem: thisFood, numServings: servingsInt ?? 1)
            
            switch(indexPath.row) {
            case 0:
                cell.textLabel?.text = "Calories: "
                cell.detailTextLabel?.text = String(mealItem?.adjustedMacros.nf_calories ?? 0.0)
                // cell.detailTextLabel?.text = String(thisFood.nf_calories)
            case 1:
                cell.textLabel?.text = "Carbs: "
                cell.detailTextLabel?.text = String(mealItem?.adjustedMacros.nf_total_carbohydrate ?? 0.0)
                // cell.detailTextLabel?.text = String(thisFood.nf_total_carbohydrate)
            case 2:
                cell.textLabel?.text = "Fat: "
                cell.detailTextLabel?.text = String(mealItem?.adjustedMacros.nf_total_fat ?? 0.0)
                // cell.detailTextLabel?.text = String(thisFood.nf_total_fat)
            case 3:
                cell.textLabel?.text = "Protein: "
                cell.detailTextLabel?.text = String(mealItem?.adjustedMacros.nf_protein ?? 0.0)
                // cell.detailTextLabel?.text = String(thisFood.nf_protein)
            default:
                cell.textLabel?.text = "?"
                cell.detailTextLabel?.text = "?"
            }
        }
        
        return cell
    }
    
    // show alert when add item to a meal - go back to home page refreshed
    @IBAction func add(_ sender: UIButton) {
        /*let clickResult = sender.isSelected
        // alert setup
        // if menu item clicked, then show alert
        if(clickResult) {
            consumpModel.addFoodItemToMeal(forDate: currentDateString!, mealItem: mealItem!, forMeal: .breakfast)
            showAlert("Added!")
        } else {
            showAlert("Not Added")
        }*/
        
        showAlert("Added!")
    }
    
    // construct an AlertController, its actions, and present
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Food Item", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Go back to home page", style: .default, handler: { _ in
            
            self.consumpModel.addFoodItemToMeal(forDate: self.currentDateString!, mealItem: self.mealItem!, forMeal: self.mealInput!)
            self.delegate?.addItemToCategory(mealType: self.mealInput!)  // in protocol of MainPageVC
            
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
        })
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "homeSegue" {
            _ = segue.destination as! MainPageViewController
        }
    }
}
