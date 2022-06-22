//
//  ViewController.swift
//  Recipes
//
//  Created by Max Kuznetsov on 21.06.2022.
//

import UIKit

class RecipesListViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(
        top: 50.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0)
    
    private let itemsPerRow: CGFloat = 3
    
    private var recipeToModify: Recipe!
    
    private var recipes: [Recipe] = [] {
        didSet {
            recipes.sort { recipe1, recipe2 in
                recipe1.name < recipe2.name
            }
            collectionView.reloadData()
        }
    }
    
    private let realmDbInstance = RealmStorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipes = realmDbInstance.readAllData() ?? []
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        setupRightBarButtonItem(title: "Add")
    }
    
}

// MARK: UINavigationBar setup

extension RecipesListViewController{
    
    private func setupRightBarButtonItem(title: String){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(performAddAction))
        navigationItem.rightBarButtonItem?.title = title
        
    }
    
    @objc private func performAddAction(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditRecipeViewController") as? EditRecipeViewController
        vc?.doAfterFinish = { recipe in
            self.realmDbInstance.writeData(recipeToWrite: recipe)
            self.recipes.append(recipe)
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

// MARK: Gesture recognition setup
//extension RecipesListViewController: UIGestureRecognizerDelegate, UIContextMenuInteractionDelegate{
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//
//        let modify = UIAction(title: "Изменить", image: UIImage(systemName: "pencil")) { action in
//            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditRecipeViewController") as? EditRecipeViewController
//            vc?.isEditingMode = true
//            vc?.recipe = self.recipeToModify.1
//            vc?.doAfterFinish = { recipe in
//                self.realmDbInstance.modifyData(recipeToModify: self.recipeToModify.1, newRecipe: recipe)
//                self.recipes[self.recipeToModify.0] = recipe
//            }
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
//
//        let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash.fill"), attributes: [.destructive]) { action in
//
//        }
//
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
//            UIMenu(title: "", children: [modify, delete])
//        }
//    }
//
//    private func setupLongPressGestureRecognizer(){
//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler))
//        self.view.addGestureRecognizer(longPressRecognizer)
//    }
//
//    @objc private func longPressHandler(gestureRecognizer : UILongPressGestureRecognizer){
//        if (gestureRecognizer.state != UIGestureRecognizer.State.ended){
//            let p = gestureRecognizer.location(in: self.collectionView)
//
//            if let indexPath = self.collectionView.indexPathForItem(at: p) {
//                let cell = self.collectionView.cellForItem(at: indexPath)
//                let interaction = UIContextMenuInteraction(delegate: self)
//                recipeToModify = (indexPath.item, recipes[indexPath.item])
//                print(recipeToModify)
//                cell?.addInteraction(interaction)
//            } else {
//                print("couldn't find index path")
//            }
//        }
//
//    }
//}

// MARK: UICollectionView and ContextualMenu setup

extension RecipesListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        configureContextMenu(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditRecipeViewController") as? EditRecipeViewController
        recipeToModify = recipes[index]
        vc?.isEditingMode = true
        vc?.recipe = recipeToModify
        vc?.doAfterFinish = { [self] recipe in
            realmDbInstance.modifyData(recipeToModify: recipeToModify, newRecipe: recipe)
            recipes[index] = recipe
        }
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            
            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash.fill"), attributes: [.destructive]) { [self] _ in
                realmDbInstance.deleteData(recipeToDelete: recipes[index])
                recipes.remove(at: index)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [delete])
            
        }
        return context
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        
        let currentRecipe = recipes[indexPath.item]
        
        cell.nameLabel.text = currentRecipe.name
        cell.recipeImage.image = UIImage(data: currentRecipe.image!)
        cell.recipeImage.layer.cornerRadius = 15
        cell.descriptionLabel.text = currentRecipe.desc
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.backgroundColor = .systemGray6
        
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
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

