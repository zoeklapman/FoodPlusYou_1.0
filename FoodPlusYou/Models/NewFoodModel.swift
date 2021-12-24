//
//  NewFoodModel.swift
//  APIRequest
//
//  Created by Zoë Klapman on 11/29/21.
//

import Foundation
import UIKit

struct RequestFailed: Codable {
    let message: String
    let id: String
}

class NewFoodModel {
    static let sharedInstance = NewFoodModel()
    let apiEndpointSearchInstant = "https://trackapi.nutritionix.com/v2/search/instant"
    let apiEndpointNaturalNutrients = "https://trackapi.nutritionix.com/v2/natural/nutrients"
    let apiEndpointSearchItem = "https://trackapi.nutritionix.com/v2/search/item"
    
    let headers = ["Content-Type": "application/json", "x-app-id": "1c11352e", "x-app-key": "927be355d19616796371419746776761", "x-remote-user-id": "0"]
    
    var fetchedFoodItems: FoodItems?
    var allFoods:[Food] {
        guard let fetchedFoodItems = fetchedFoodItems else {
            return []
        }
        return fetchedFoodItems.common + fetchedFoodItems.branded
    }
    
    var selectedFoodItem: FoodItemsDetails?
    
    private init() {
        // call function defined in this class
    }
    
    // GET request /search/instant
    func fetchFoodItems(searchFor query: String, completion: @escaping (Bool) -> Void ) {
        guard let htmlString = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlAndQuery = "\(apiEndpointSearchInstant)?query=\(htmlString)"
        print(urlAndQuery)
        guard let url = URL(string: urlAndQuery) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            if let error = error {
                print(error)
            }
            if let data = data {
                do {
                    self.fetchedFoodItems = try JSONDecoder().decode(FoodItems.self, from: data)
                    print(self.fetchedFoodItems)
                    completion(true)
                    
                    // let json = try JSONSerialization.jsonObject(with: data, options: [])
                    // print(json)
                } catch {
                    print(error)
                    do {
                        let errorMessage = try JSONDecoder().decode(RequestFailed.self, from: data)
                        print(errorMessage)
                    } catch {
                        print(error)
                    }
                    completion(false)
                }
            }
        }
        task.resume()
    }
    
    func getFoodAtIndex(forIndex index: Int) -> Food? {
        return allFoods[index]
    }
    
    // POST request /natural/nutrients - for common food
    func getCommonFoodNutrients(searchFor query: String, completion: @escaping (Bool) -> Void) {
        // parameters for POST request
        // replacing "query" value with "food_name" value
        let parameters = ["query":query]
        
        guard let url = URL(string: apiEndpointNaturalNutrients) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // make the parameters into a JSON obj
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        // make session
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            if let error = error {
                print(error)
            }
            if let data = data {
                do {
                    let fetchedFoodNutrients = try JSONDecoder().decode(NutrientsRequestResponse.self, from: data)
                    self.selectedFoodItem = fetchedFoodNutrients.foods[0]
                    // print(self.selectedFoodItem)
                    completion(true)
                } catch {
                    print(error)
                    do {
                        let errorMessage = try JSONDecoder().decode(RequestFailed.self, from: data)
                        print(errorMessage)
                    } catch {
                        print(error)
                    }
                    completion(false)
                }
            }
        }
        session.resume()
    }
    
    // GET request /search/item - for branded food
    func getBrandedFoodNutrients(searchFor query: String, completion: @escaping (Bool) -> Void) {
        // replacing "query" value with "nix_item_id" value
        let htmlString = query
        let urlAndQuery = "\(apiEndpointSearchItem)?nix_item_id=\(htmlString)"
        print(urlAndQuery)
        guard let url = URL(string: urlAndQuery) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response) 
            }
            if let error = error {
                print(error)
            }
            if let data = data {
                do {
                    let fetchedFoodNutrients = try JSONDecoder().decode(NutrientsRequestResponse.self, from: data)
                    self.selectedFoodItem = fetchedFoodNutrients.foods[0]
                    completion(true)
                } catch {
                    print(error)
                    do {
                        let errorMessage = try JSONDecoder().decode(RequestFailed.self, from: data)
                        print(errorMessage)
                    } catch {
                        print(error)
                    }
                    completion(false)
                }
            }
        }
        task.resume()
    }
}
