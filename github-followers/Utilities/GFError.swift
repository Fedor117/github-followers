//
//  GFError.swift
//  github-followers
//
//  Created by Theodor Valiavko on 07/01/2020.
//  Copyright © 2020 Theodor Valiavko. All rights reserved.
//

import Foundation

enum GFError: String, Error {

    case invalidUrl = "There was an error constructing URL. Please try again."
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user."
}
