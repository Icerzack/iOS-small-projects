//
//  ViewController.swift
//  Recipes
//
//  Created by Max Kuznetsov on 21.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let sectionInsets = UIEdgeInsets(
        top: 50.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0)
    
    private let itemsPerRow: CGFloat = 3
    private var recipes: [Recipe] = []
    
    let realmDbInstance = RealmStorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        realmDbInstance.deleteData(recipeToDelete: Recipe(name: "C1", description: "C2", cookingMethod: "C3", image: nil))
        recipes = realmDbInstance.readAllData() ?? []
        navigationItem.rightBarButtonItem?.title = ""
    }

}

// MARK: UICollectionView setup

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        cell.backgroundColor = .systemGray6
        cell.nameLabel.text = recipes[indexPath.item].name
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 170, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

