//
//  MainPageViewController.swift
//  MidtermRemoveItem
//
//  Created by Zoë Klapman on 10/27/21.
//
protocol CustomSectionHeaderDelegate {
    func addItemToCategory(mealType: MealTypes)
    func pickItemToCategory(mealType: MealTypes)
}

import UIKit

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomSectionHeaderDelegate {
    
    @IBOutlet weak var macrosTableView: UITableView!
    @IBOutlet weak var foodsTableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    
    var rowsInSection: [Int] = []
    
    // singleton the model object
    let consumpModel = ConsumptionModel.sharedInstance
    let newFoodModel = NewFoodModel.sharedInstance
    
    // local variables
    var selectedIndexPath: IndexPath?
    var currentDate: Date = Date()
    var currentDateString: String = ""
    var mealInput: MealTypes?
    
    var dailyConsump: DailyConsumption?
    var mealTypes: [MealTypes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Date(): \(currentDate)")
        currentDateString = currentDate.asYearMonthDay(forDate: currentDate)
        print("Current Date: \(currentDateString)")
        // let currentDateString: String = currentDate.currentDate()
        // print(currentDateString)
        consumpModel.addDailyConsumption(forDate: currentDate)
        dailyConsump = consumpModel.myDailyMeals[currentDateString]
        mealTypes = MealTypes.allCases
        
        self.macrosTableView.dataSource = self
        self.macrosTableView.delegate = self

        self.foodsTableView.dataSource = self
        self.foodsTableView.delegate = self
        // self.foodsTableView.tableFooterView = self.footerView()
        
        self.title = "Home Page"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor") as Any]
        
        let nib = UINib(nibName: "CustomSectionHeader", bundle: nil)
        foodsTableView.register(nib, forHeaderFooterViewReuseIdentifier: "customSectionHeader")
        rowsInSection = Array(repeating: 0, count: MealTypes.allCases.count)        // [0,0,0,0] start w 0 rows per section
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("Reloading tableView data...")
        macrosTableView.reloadData()
        foodsTableView.reloadData()
    }
    
    @IBAction func revealSideMenu(sender: AnyObject) {
        print("Performing segue...")
        self.performSegue(withIdentifier: "menuSegue", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == macrosTableView) {
            return 1
        }
        return mealTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == macrosTableView) {
            return 4
        }
        
        // rows in section based on size of mealList (DailyConsumption > MealTypes (section) > mealList (row)
        if let mealList = consumpModel.getMealList(forDate: currentDateString, forMeal: mealTypes[section]) {
            return mealList.items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == macrosTableView) {
            return nil
        } else {
            // Dequeue with the reuse identifier
            let header = self.foodsTableView.dequeueReusableHeaderFooterView(withIdentifier: "customSectionHeader") as! CustomSectionHeader
            
            header.mealType = mealTypes[section]
            header.titleLabel.text = mealTypes[section].rawValue
            
            header.delegate = self
            return header
        }
    }
    
    // Give a height to our table view cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    // cell creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // SETUP MACROSTABLEVIEW CELLS
        if(tableView == macrosTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "macroCell", for: indexPath)
            
            switch(indexPath.row) {
            case 0:
                cell.textLabel?.text = "Calories: "
                // cell.detailTextLabel?.text = foodModel.getCalories() + " / " + foodModel.getCalGoal()
                if let calories = consumpModel.getDaysMacroTotals(forDate: currentDateString)?.nf_calories, let goal = consumpModel.getGoal()  {
                    // cell.detailTextLabel?.text = String(calories) + " / " + String(consumpModel.myDailyTarget.goal.nf_calories)
                    // cell.detailTextLabel?.text = String(calories) + " / " + String(consumpModel.getGoal()?.nf_calories ?? 0.0)
                    cell.detailTextLabel?.text = String(lround(calories)) + " / " + String(lround(goal.nf_calories))
                }
            case 1:
                cell.textLabel?.text = "Carbs: "
                // cell.detailTextLabel?.text = foodModel.getCarbs() + " / " + foodModel.getCarbGoal()
                if let carbs = consumpModel.getDaysMacroTotals(forDate: currentDateString)?.nf_total_carbohydrate, let goal = consumpModel.getGoal() {
                    cell.detailTextLabel?.text = String(lround(carbs)) + " / " + String(lround(goal.nf_total_carbohydrate))
                }
            case 2:
                cell.textLabel?.text = "Fat: "
                // cell.detailTextLabel?.text = foodModel.getFat() + " / " + foodModel.getFatGoal()
                if let fat = consumpModel.getDaysMacroTotals(forDate: currentDateString)?.nf_total_fat, let goal = consumpModel.getGoal() {
                    cell.detailTextLabel?.text = String(lround(fat)) + " / " + String(lround(goal.nf_total_fat))
                }
            case 3:
                cell.textLabel?.text = "Protein: "
                // cell.detailTextLabel?.text = foodModel.getProtein() + " / " + foodModel.getProteinGoal()
                if let protein = consumpModel.getDaysMacroTotals(forDate: currentDateString)?.nf_protein, let goal = consumpModel.getGoal() {
                    cell.detailTextLabel?.text = String(lround(protein)) + " / " + String(lround(goal.nf_protein))
                }
            default:
                cell.textLabel?.text = "?"
                cell.detailTextLabel?.text = "?"
            }
            
            return cell
        } else {
            // SETUP FOODSTABLEVIEW CELLS
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            // mealTypes[indexPath.section] gets the corresponding MealType
            if let mealList = consumpModel.getMealList(forDate: currentDateString, forMeal: mealTypes[indexPath.section]) {
                let lastMealItem = mealList.items[indexPath.row]
                var lastItemName: String
                
                if(lastMealItem.adjustedMacros.food_name != "") {
                    lastItemName = (lastMealItem.foodItem.brand_name ?? "") + lastMealItem.adjustedMacros.food_name
                } else {
                    lastItemName = (lastMealItem.foodItem.brand_name ?? "") + lastMealItem.foodItem.food_name
                }
                
                cell.textLabel?.text = lastItemName
            } else {
                cell.textLabel?.text = UUID().uuidString
            }
            
            return cell
        }
    }
    
    // footer view function
    /*private func footerView() -> UIView {
        let view = UIView(frame: CGRect(x:0, y:0, width: self.foodsTableView.frame.width, height: 20))
        view.backgroundColor = .green
        return view
    }
     
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         return self.footerView()
    }*/
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if(tableView == macrosTableView) {
            return
        } else {
            let footer = view as? UITableViewHeaderFooterView
            // footer?.textLabel?.font = UIFont.init(name: "Monterrat", size: 2)
            footer?.textLabel?.adjustsFontSizeToFitWidth
            footer?.textLabel?.textColor = UIColor(named: "TextColor2")     // .lightGray
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(tableView == macrosTableView) {
            return 0
        } else {
            return 35
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let mealType = mealTypes[section]
        let mealMacros = consumpModel.getMealMacroTotals(forDate: currentDateString, forMeal: mealType)
        return "Calories: \(String(describing: lround(mealMacros?.nf_calories ?? 0))) Carbs: \(String(describing: lround(mealMacros?.nf_total_carbohydrate ?? 0))) Fat: \(String(describing: lround(mealMacros?.nf_total_fat ?? 0))) Protein: \(String(describing: lround(mealMacros?.nf_protein ?? 0)))"
    }
    
    // delete rows delegate methods
    // when delete item, update the calories/macros - and the footer
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(tableView == macrosTableView) {
            return
        } else {
            if editingStyle == UITableViewCell.EditingStyle.delete {
                // remove meal item from meal list
                consumpModel.removeFoodItemFromMeal(forDate: currentDateString, mealItem: indexPath.row, forMeal: mealTypes[indexPath.section])
                
                rowsInSection[indexPath.section] = rowsInSection[indexPath.section] - 1
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                print("Breakfast num rows: \(macrosTableView.numberOfRows(inSection: 0))")
                
                macrosTableView.reloadData()        // update calories/macros
                foodsTableView.reloadData()         // update footer
            }
        }
    }
    
    /*func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
        }

        let share = UITableViewRowAction(style: .normal, title: "Disable") { (action, indexPath) in
            // share item at indexPath
        }
        // share.backgroundColor = UIColor.blue

        return [delete, share]
    }*/
    
    // method for CustomSectionHeaderDelegate
    func addItemToCategory(mealType: MealTypes) {
        var indexPath: IndexPath!
        
        if let index = mealType.index {
            rowsInSection[index] = rowsInSection[index] + 1
            indexPath = IndexPath(row: rowsInSection[index]-1, section: index)
        }
        
        foodsTableView.performBatchUpdates { [unowned self] in
            foodsTableView.insertRows(at: [indexPath], with: .automatic)        // ERROR
            self.foodsTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        // perform searchSegue
        
    }
    
    func pickItemToCategory(mealType: MealTypes) {
        mealInput = mealType
        self.performSegue(withIdentifier: "searchSegue", sender: UIButton.self)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         if(segue.identifier == "menuSegue") {
             let _ = segue.destination as! SideMenuViewController
         }
         
         /*if selectedIndexPath != nil {
             if(segue.identifier == "searchSegue") {
                 let dvc = segue.destination as! SearchTableViewController
                 dvc.delegate = self
                 dvc.currentDate = currentDate
                 dvc.currentDateString = currentDateString
                 // setup the meal based on the cell clicked on
                 dvc.mealInput = mealInput
             }
         }*/
         if(segue.identifier == "searchSegue") {
             let dvc = segue.destination as! SearchTableViewController
             dvc.delegate = self
             dvc.currentDate = currentDate
             dvc.currentDateString = currentDateString
             // setup the meal based on the cell clicked on
             dvc.mealInput = mealInput
         }
     }

}
