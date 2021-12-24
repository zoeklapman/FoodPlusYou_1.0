//
//  HistoryViewController.swift
//  CoreDataWithAPI
//
//  Created by Zoë Klapman on 12/15/21.
//
//  TO BE IMPLEMENTED IN FUTURE VERSION
//

/*import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var histMacroTableView: UITableView!
    @IBOutlet weak var histFoodTableView: UITableView!
    
    let consumpModel = ConsumptionModel.sharedInstance
    
    let datePicker = UIDatePicker()
    var date: Date = Date()
    var dateString: String = ""
    var chosenConsumption: Consumption?
    
    var mealTypes: [MealTypes] = MealTypes.allCases
    var rowsInSection: [Int] = Array(repeating: 0, count: MealTypes.allCases.count)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        consumpModel.loadConsumptionModel()         // not sure if need to reload model if done on MainPageVC
        
        // setup UIDatePicker
        createDatePicker()
        
        self.histMacroTableView.dataSource = self
        self.histMacroTableView.delegate = self
        self.histFoodTableView.dataSource = self
        self.histFoodTableView.delegate = self
        self.title = "History"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "TextColor") as Any]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        histMacroTableView.reloadData()
        histFoodTableView.reloadData()
    }
    
    // MARK: date picker setup
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolbar
        datePicker.maximumDate = Date()
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        dateTextField.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: datePicker.date)
    }
    
    // when there is a date set, update the date, dateString, and chosenConsumption
    @objc func donePressed() {
        // formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        dateTextField.text = formatter.string(from: datePicker.date)
        
        // update global variables
        date = datePicker.date
        dateString = date.asYearMonthDay(forDate: date)
        chosenConsumption = consumpModel.getConsumption(forDate: dateString)
        print("Date: \(String(describing: chosenConsumption?.date))")
        
        self.view.endEditing(true)
    }
    
    // MARK: tableviews setup
    func numberOfSections(in tableView: UITableView) -> Int {
        if(tableView == histMacroTableView) {
            return 1
        }
        return mealTypes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == histMacroTableView) {
            return 4
        }
        
        let mealItems = consumpModel.getMeal(forDate: dateString, forMeal: mealTypes[section])
        return mealItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(tableView == histMacroTableView) {
            return nil
        } else {
            let header = self.histFoodTableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
            header?.textLabel?.text = mealTypes[section].rawValue
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    // TODO: cell creation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // SETUP MACROSTABLEVIEW CELLS
        if(tableView == histMacroTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "histMacroCell", for: indexPath)
            
            switch(indexPath.row) {
            case 0:
                cell.textLabel?.text = "Calories: "
                if let calories = consumpModel.getMealMacros(forDate: dateString, forMeal: .breakfast)?.calories, let goal = consumpModel.getGoal() {
                    cell.detailTextLabel?.text = String(lround(calories)) + " / " + String(lround(goal.calorieGoal))
                }
            case 1:
                cell.textLabel?.text = "Carbs: "
                if let carbs = consumpModel.getMealMacros(forDate: dateString, forMeal: .breakfast)?.carbs, let goal = consumpModel.getGoal() {
                    cell.detailTextLabel?.text = String(lround(carbs)) + " / " + String(lround(goal.carbGoal))
                }
            case 2:
                cell.textLabel?.text = "Fat: "
                if let fat = consumpModel.getMealMacros(forDate: dateString, forMeal: .breakfast)?.fat, let goal = consumpModel.getGoal() {
                    cell.detailTextLabel?.text = String(lround(fat)) + " / " + String(lround(goal.fatGoal))
                }
            case 3:
                cell.textLabel?.text = "Protein: "
                if let protein = consumpModel.getMealMacros(forDate: dateString, forMeal: .breakfast)?.protein, let goal = consumpModel.getGoal() {
                    cell.detailTextLabel?.text = String(lround(protein)) + " / " + String(lround(goal.proteinGoal))
                }
            default:
                cell.textLabel?.text = "?"
                cell.detailTextLabel?.text = "?"
            }
            
            return cell
        } else {
            // SETUP FOODSTABLEVIEW CELLS
            let cell = tableView.dequeueReusableCell(withIdentifier: "histFoodCell", for: indexPath)
            
            if let mealList = consumpModel.getMeal(forDate: dateString, forMeal: mealTypes[indexPath.section]) {
                let lastMealItem = mealList[indexPath.row]
                var lastItemName: String
                
                if(lastMealItem.food?.food_name != "") {
                    lastItemName = (lastMealItem.food?.brand_name ?? "") + (lastMealItem.food?.food_name ?? "")
                } else {
                    lastItemName = (lastMealItem.food?.brand_name ?? "") + (lastMealItem.food?.food_name ?? "")
                }
                
                cell.textLabel?.text = lastItemName
            } else {
                cell.textLabel?.text = UUID().uuidString
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if(tableView == histMacroTableView) {
            return
        } else {
            let footer = view as? UITableViewHeaderFooterView
            // footer?.textLabel?.font = UIFont.init(name: "Monterrat", size: 2)
            footer?.textLabel?.adjustsFontSizeToFitWidth
            footer?.textLabel?.textColor = UIColor(named: "TextColor2")     // .lightGray
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(tableView == histMacroTableView) {
            return 0
        } else {
            return 35
        }
    }
    
    // TODO: setup footer
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let mealType = mealTypes[section]
        let mealMacros = consumpModel.getMealMacros(forDate: dateString, forMeal: mealType)
        
        //print(mealMacros?.nf_calories)
        return "Calories: \(String(describing: lround(mealMacros?.calories ?? 0))) Carbs: \(String(describing: lround(mealMacros?.carbs ?? 0))) Fat: \(String(describing: lround(mealMacros?.fat ?? 0))) Protein: \(String(describing: lround(mealMacros?.protein ?? 0)))"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

*/
