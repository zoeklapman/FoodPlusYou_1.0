//
//  AboutPageViewController.swift
//  APIRequest
//
//  Created by Zoë Klapman on 12/6/21.
//

import UIKit

class AboutPageViewController: UIViewController {

    @IBOutlet weak var creditsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "About"
    }
    
    @IBAction func creditsButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://github.com/zoeklapman") {
            UIApplication.shared.open(url)
        }
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
