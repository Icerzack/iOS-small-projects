//
//  Recipe.swift
//  Recipes
//
//  Created by Max Kuznetsov on 21.06.2022.
//

import Foundation
import RealmSwift

protocol RecipeProtocol: Object{
    var image: Data? {get set}
    var name: String {get set}
    var desc: String? {get set}
    var cookingMethod: String {get set}
}

class Recipe: Object, RecipeProtocol{
    @Persisted var image: Data?
    @Persisted var name: String = ""
    @Persisted var desc: String?
    @Persisted var cookingMethod: String = ""
    
    convenience init(name: String, description: String?, cookingMethod: String, image: Data?) {
        self.init()
        self.name = name
        self.desc = description
        self.cookingMethod = cookingMethod
        self.image = image
    }
}
