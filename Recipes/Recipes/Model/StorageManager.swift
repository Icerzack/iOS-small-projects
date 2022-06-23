//
//  StorageManager.swift
//  Recipes
//
//  Created by Max Kuznetsov on 21.06.2022.
//

import Foundation
import RealmSwift

protocol StorageManagerProtocol: AnyObject{
    static var shared: StorageManagerProtocol {get}
    
    func writeData(recipeToWrite: Recipe)
    func getData(recipeToRetrieve: Recipe) -> Recipe?
    func readAllData() -> [Recipe]?
    func modifyData(recipeToModify: Recipe, newRecipe: Recipe)
    func deleteData(recipeToDelete: Recipe)
}

class RealmStorageManager: StorageManagerProtocol{
    
    static let shared: StorageManagerProtocol = RealmStorageManager()
    
    private let localRealm = try! Realm()
    var retrievedRecipes: [Recipe] = []
    
    func writeData(recipeToWrite: Recipe) {
        try! localRealm.write {
            localRealm.add(recipeToWrite)
        }
    }
    
    func getData(recipeToRetrieve: Recipe) -> Recipe? {
       //TODO: add getData
        return nil
    }
    
    func readAllData() -> [Recipe]? {
        let recipes = localRealm.objects(Recipe.self)
        retrievedRecipes = Array(recipes)
        return retrievedRecipes
    }
    
    func modifyData(recipeToModify: Recipe, newRecipe: Recipe) {
        try! localRealm.write {
            recipeToModify.name = newRecipe.name
            recipeToModify.desc = newRecipe.desc
            recipeToModify.cookingMethod = newRecipe.cookingMethod
            recipeToModify.image = newRecipe.image
        }
    }
    
    func deleteData(recipeToDelete: Recipe){
        try! localRealm.write {
            localRealm.delete(recipeToDelete)
        }
    }
    
}
