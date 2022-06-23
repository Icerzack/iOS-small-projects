//
//  EditRecipeViewController.swift
//  Recipes
//
//  Created by Max Kuznetsov on 22.06.2022.
//

import UIKit

class EditRecipeViewController: UITableViewController {
    
    @IBOutlet var cookingMethodView: UITextView!
    @IBOutlet var descriptionField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var recipe: Recipe!
    
    private let defaultImage = UIImage(imageLiteralResourceName: "default")
    
    var isEditingMode: Bool = false
    var barTitle: String = ""
    
    var doAfterFinish: ((Recipe) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = barTitle
        
        if(isEditingMode){
            nameField.text = recipe.name
            descriptionField.text = recipe.desc
            cookingMethodView.text = recipe.cookingMethod
            imageView.image = UIImage(data: recipe.image ?? defaultImage.pngData()!)
            isEditingMode = false
        }
        
        setupRightBarButtonItem(title: "Save")
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Камера", style: .default) { _ in
                self.useCamera()
            }
            
            let galleryAction = UIAlertAction(title: "Галерея", style: .default) { _ in
                self.usePhotoLibrary()
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            ac.addAction(cameraAction)
            ac.addAction(galleryAction)
            ac.addAction(cancelAction)
            
            present(ac, animated: true)
        }
    }
}
// MARK: UITextFieldDelegate setup
extension EditRecipeViewController: UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameField.text?.isEmpty == false {
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

// MARK: UIImagePickerControllerDelegate setup
extension EditRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true)
    }
    
    private func useCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    private func usePhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
}

// MARK: UINavigationBar setup
extension EditRecipeViewController{
    
    private func setupRightBarButtonItem(title: String){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(saveNewRecipe))
        navigationItem.rightBarButtonItem?.title = title
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func saveNewRecipe(){
        let recipeToSave = Recipe(name: nameField.text!, description: descriptionField.text, cookingMethod: cookingMethodView.text, image: imageView.image?.pngData())
        doAfterFinish?(recipeToSave)
        self.navigationController?.popViewController(animated: true)
    }
    
}
