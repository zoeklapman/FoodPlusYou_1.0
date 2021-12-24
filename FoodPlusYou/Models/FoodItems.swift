//
//  FoodItems.swift
//  APIRequest
//
//  Created by Zoë Klapman on 11/29/21.
//

import Foundation

// let instead of var
// GET /search/instant
struct PhotoUrl: Codable {
    var thumb: String
}

struct Food: Codable {
    var food_name: String
    var brand_name_item_name: String?
    var nix_item_id: String?
    var photo: PhotoUrl
}

struct FoodItems: Codable {
    var common: [Food]
    var branded: [Food]
}

// POST /natural/nutrients and GET /search/item
struct FoodItemsDetails: Codable {
    var item_id: String?         // if branded, assign nix_item_id
                                // if common, assign UUID.uuid
                                // optional bc not in API response, but need to store in CoreData
    var food_name: String
    var brand_name: String?
    var photo: PhotoUrl
    var nf_calories: Double
    var nf_total_carbohydrate: Double
    var nf_total_fat: Double
    var nf_protein: Double
}

struct NutrientsRequestResponse: Codable {
    var foods: [FoodItemsDetails]
}
