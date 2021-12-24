//
//  GoalSetupTableViewController.swift
//  APIRequest
//
//  Created by Zoë Klapman on 12/2/21.
//

import UIKit

class GoalSetupTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var sexCellTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var activityLevelTextField: UITextField!
    @IBOutlet weak var dietGoalTextField: UITextField!
    
    let consumpModel = ConsumptionModel.sharedInstance
    
    var sexOptions: [String] = ["Female", "Male"]
    var activityLevelOptions: [String] = ["Sedentary - little/no exercise",
                                          "Lightly Active - light exercise 1-3 days/week",
                                          "Moderately Active - moderate exercise 3-5 days/week",
                                          "Very Active - hard exercise 6-7 days/week",
                                          "Extra Active - very hard exercise & physical job or 2x training"]
    var dietGoalOptions: [String] = ["Lose Weight", "Maintain Weight", "Gain Weight"]
    
    let sexPickerView = UIPickerView()
    let activityLevelPickerView = UIPickerView()
    let dietGoalPickerView = UIPickerView()
    
    var newAlert:UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Customize Diet Goals"
        
        saveButton = self.navigationItem.rightBarButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        sexCellTextField.inputView = sexPickerView
        activityLevelTextField.inputView = activityLevelPickerView
        dietGoalTextField.inputView = dietGoalPickerView
        
        sexPickerView.delegate = self
        sexPickerView.dataSource = self
        activityLevelPickerView.delegate = self
        activityLevelPickerView.dataSource = self
        dietGoalPickerView.delegate = self
        dietGoalPickerView.dataSource = self
        
        sexPickerView.tag = 1
        activityLevelPickerView.tag = 2
        dietGoalPickerView.tag = 3
        
        saveButton = self.navigationItem.rightBarButtonItem
        
        // createGoal()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return sexOptions.count
        case 2:
            return activityLevelOptions.count
        case 3:
            return dietGoalOptions.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        /* var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "System 17.0", size: 12)
            pickerLabel?.textAlignment = .center
        }*/
        
        switch pickerView.tag {
        case 1:
            return sexOptions[row]
        case 2:
            return activityLevelOptions[row]
        case 3:
            return dietGoalOptions[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        pickerView.backgroundColor = UIColor(named: "TextColor2")
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Monterrat-Regular", size: 12)
            pickerLabel?.textAlignment = .center
            pickerLabel?.adjustsFontSizeToFitWidth = true
            pickerLabel?.minimumScaleFactor = 0.5
            pickerView.backgroundColor = UIColor(named: "TextColor")
        }
        
        switch pickerView.tag {
        case 1:
            pickerLabel?.text = sexOptions[row]
            pickerLabel?.resignFirstResponder()
            return pickerLabel!
        case 2:
            pickerLabel?.text = activityLevelOptions[row]
            pickerLabel?.resignFirstResponder()
            return pickerLabel!
        case 3:
            pickerLabel?.text = dietGoalOptions[row]
            pickerLabel?.resignFirstResponder()
            return pickerLabel!
        default:
            return pickerLabel!
        }
        
        
        // pickerLabel?.text = activityLevelOptions[row]
        // pickerLabel?.textColor = UIColor.blue

        // return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            sexCellTextField.text = sexOptions[row]
            sexCellTextField.resignFirstResponder()
        case 2:
            activityLevelTextField.text = activityLevelOptions[row]
            activityLevelTextField.resignFirstResponder()
        case 3:
            dietGoalTextField.text = dietGoalOptions[row]
            dietGoalTextField.resignFirstResponder()
        default:
            return
        }
    }
    
    func createGoal() {
        print("Creating goal...")
        
        // calculation for macros breakdown
        // get inputs
        let sex: String = sexCellTextField.text!
        let weight: Double? = Double(weightTextField.text!)
        let height: Double? = Double(heightTextField.text!)
        let age: Double? = Double(ageTextField.text!)
        let activityLevel: String = activityLevelTextField.text!
        let dietGoal: String = dietGoalTextField.text!
        
        // values
        var BMR: Double
        var activityLevelResult: Double
        var finalCalorieResult: Double
        var finalCarbResult: Double
        var finalFatResult: Double
        var finalProteinResult: Double
        
        // 1. calculate BMR
        if sex == "Female" {
            if(weight != nil && height != nil && age != nil) {
                BMR = 655 + (4.3 * weight!) + (4.7 * height!) - (4.7 * age!)
            } else {
                BMR = 0
            }
        } else {
            if(weight != nil && height != nil && age != nil) {
                BMR = 66 + (6.3 * weight!) + (12.9 * height!) - (6.8 * age!)
            } else {
                BMR = 0
            }
        }
        
        // 2. multiply BMR by activity level
        switch activityLevel {
        case activityLevelOptions[0]:
            activityLevelResult = BMR * 1.2
        case activityLevelOptions[1]:
            activityLevelResult = BMR * 1.375
        case activityLevelOptions[2]:
            activityLevelResult = BMR * 1.55
        case activityLevelOptions[3]:
            activityLevelResult = BMR * 1.725
        case activityLevelOptions[4]:
            activityLevelResult = BMR *  1.9
        default:
            activityLevelResult = BMR
        }
        
        // 3. change macros based on diet goal
        // switch statement bc will add in more options later
        switch dietGoal {
        case dietGoalOptions[0]:
            // Lose Weight
            finalCalorieResult = activityLevelResult
            finalCarbResult = (finalCalorieResult * 0.5) / 4
            finalFatResult = (finalCalorieResult * 0.2) / 9
            finalProteinResult = (finalCalorieResult * 0.3) / 4
        case dietGoalOptions[1]:
            // Maintain Weight
            finalCalorieResult = activityLevelResult
            finalCarbResult = (finalCalorieResult * 0.5) / 4
            finalFatResult = (finalCalorieResult * 0.25) / 9
            finalProteinResult = (finalCalorieResult * 0.25) / 4
        case dietGoalOptions[2]:
            // Gain Weight
            finalCalorieResult = activityLevelResult
            finalCarbResult = (finalCalorieResult * 0.5) / 4
            finalFatResult = (finalCalorieResult * 0.3) / 9
            finalProteinResult = (finalCalorieResult * 0.2) / 4
        default:
            finalCalorieResult = 0.0
            finalCarbResult = 0.0
            finalFatResult = 0.0
            finalProteinResult = 0.0
        }
        
        print("Final goal results: \(finalCalorieResult) calories, \(finalCarbResult) carbs, \(finalFatResult) fat, \(finalProteinResult) protein")
        
        consumpModel.setMyTarget(goal: FoodItemsDetails(food_name: "", brand_name: "", photo: PhotoUrl(thumb: ""), nf_calories: finalCalorieResult, nf_total_carbohydrate: finalCarbResult, nf_total_fat: finalFatResult, nf_protein: finalProteinResult))
    }
    
    @IBAction func save(_ sender: UIButton) {
        /*let clickResult = sender.isSelected
        // alert setup
        // if menu item clicked, then show alert
        if(clickResult) {
            self.createGoal()       // not getting called
            showAlert("Saved!")
        } else {
            showAlert("Not Saved")
        }*/
        
        showAlert("Saved!")
    }
    
    // construct an AlertController, its actions, and present
    func showAlert(_ message: String) {
        /*let alert = UIAlertController(title: "Goals saved", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Go back to home page", style: .default, handler: { _ in
            
            self.createGoal()
            self.performSegue(withIdentifier: "unwindToHome", sender: self)
        })
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)*/
        
        if newAlert == nil {
            newAlert = UIAlertController(title: "Goals saved", message: message, preferredStyle: .alert)
            if let newAlert = newAlert {
                newAlert.addAction(UIAlertAction(title: "Go back to home page", style: .default, handler: { action in
                    self.newAlert = nil
                    return
                }))
                
                self.createGoal()
                self.performSegue(withIdentifier: "unwindToHome", sender: self)
                self.present(newAlert, animated: true, completion: nil)
             }
        }
        
        /*// delays execution of code to dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
          alert.dismiss(animated: true, completion: nil)
        })*/
    }
    
    func autoDismiss() {
        newAlert?.dismiss(animated: false, completion: nil)
        newAlert = nil
    }


    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
