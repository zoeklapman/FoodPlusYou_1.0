# FoodPlusYou - Food Tracking App

## Introduction

This is my semester project for my CSSE337 Enterprise Mobile Apps class for college. With FoodPlusYou, the client can create custom diet goals and track their daily calorie and macros consumption. This app is powered by [Nutritionix](https://developer.nutritionix.com/docs/v2), a rest API.

## Description

The app’s main/home page reflects the progress of the client’s calorie and macro consumption for the current day based on their custom diet goal set in the side menu. The client can add or delete items to the day’s meals. When adding a meal item, the client sets a search query on the search page and an http client request is sent to the Nutritionix API to get a list of food items to choose from. The client can then click on a single food item to set off another API request to get the food item’s details. The client can then set their preferred serving size and add the item to the chosen meal.

<img src="/Screenshots/side_menu.png" height="1000">
<img src="/Screenshots/goal_setup.png" height="1000">
<img src="/Screenshots/empty_main_page.png" height="1000">
<img src="/Screenshots/search.png" height="1000">
<img src="/Screenshots/detail.png" height="1000">
<img src="/Screenshots/main_page.png" height="1000">
