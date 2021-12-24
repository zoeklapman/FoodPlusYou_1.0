//
//  SideMenuViewController.swift
//  SideMenu
//
//  Created by Zoë Klapman on 11/23/21.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var creditsButton: UIButton!
    
    var menuItems: [String] = []
    var selectedIndexPath: IndexPath?
    var rowSelected: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.menuTableView.dataSource = self
        self.menuTableView.delegate = self
        
        self.title = "Menu"
        
        menuItems = ["Customize Diet Goals", "About"]
        menuTableView.reloadData()
        
        imageView.image = UIImage(named: "LaunchScreenImage")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // reload selective rows or refresh the table data
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return menuItems.count
        return menuItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
            cell.textLabel?.text = menuItems[indexPath.row]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath)
            cell.textLabel?.text = menuItems[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell", for: indexPath)
            cell.textLabel?.text = menuItems[indexPath.row]
            return cell
        }
        
        
        /*let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
        
        cell.textLabel?.text = menuItems[indexPath.row]
        
        return cell*/
    }
    
    @IBAction func creditsButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "http://www.nutritionix.com/api") {
            UIApplication.shared.open(url)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        /*if segue.identifier == "goalSegue" {
            let dvc = segue.destination as! GoalSetupTableViewController
            dvc.title = menuItems[0]
        }*/
        
        if let indexPath = selectedIndexPath {
            if(segue.identifier == "goalSegue") {
                print("Performing goalSegue in prepare function...")
                let dvc = segue.destination as! GoalSetupTableViewController
                dvc.title = menuItems[indexPath.row]
            }
            if(segue.identifier == "aboutSegue") {
                print("Performing aboutSegue in prepare function...")
                let dvc = segue.destination as! AboutPageViewController
                dvc.title = menuItems[indexPath.row]
            }
        }
    }

}
