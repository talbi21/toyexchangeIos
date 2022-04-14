//
//  AddController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 7/11/2021.
//

import UIKit
import SwiftUI

class AddController: UIViewController ,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    //var
    var clientId : String?
    var postImage : Image?
    //widgets

    @IBOutlet weak var IMVPost: UIImageView!
    
    @IBOutlet weak var TFName: UITextField!
    @IBOutlet weak var TFDescription: UITextField!
    @IBOutlet weak var TFSize: UITextField!
    @IBOutlet weak var TFPrice: UITextField!
    
    @IBOutlet weak var AddPhotoOutlet: UIButton!
    
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide navigation back button
        self.navigationItem.setHidesBackButton(true, animated: true)
    
        
        //Style Name TestField
        TFName.layer.cornerRadius = 10.0
        TFName.layer.borderWidth = 1.0
        TFName.layer.masksToBounds = true
        
        //Style Description TestField
        TFDescription.layer.cornerRadius = 10.0
        TFDescription.layer.borderWidth = 1.0
        TFDescription.layer.masksToBounds = true
        
        //Style Size TestField
        TFSize.layer.cornerRadius = 10.0
        TFSize.layer.borderWidth = 1.0
        TFSize.layer.masksToBounds = true
        
        //Style Price TestField
        TFPrice.layer.cornerRadius = 10.0
        TFPrice.layer.borderWidth = 1.0
        TFPrice.layer.masksToBounds = true
        
        IMVPost.layer.cornerRadius = 10.0
        IMVPost.layer.borderWidth = 1.0
        IMVPost.layer.borderColor = UIColor.clear.cgColor
        IMVPost.layer.shadowColor = UIColor.gray.cgColor
        IMVPost.layer.shadowRadius = 9.0
        IMVPost.layer.shadowOpacity = 0.5
        IMVPost.layer.shadowPath = UIBezierPath(roundedRect: IMVPost.bounds, cornerRadius: IMVPost.layer.cornerRadius).cgPath
        IMVPost.clipsToBounds = true
        IMVPost.layer.masksToBounds = true
        
        let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
    
        if (IsDark == true){
            overrideUserInterfaceStyle = .dark

        }else{
            overrideUserInterfaceStyle = .light
           
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
    
        if (IsDark == true){
            overrideUserInterfaceStyle = .dark

        }else{
            overrideUserInterfaceStyle = .light
           
        }
    }
    
    //IBAction
        //releted to the button Add
        @IBAction func BtnAddPost(_ sender: Any) {
            var toy = Toy()
            
            toy.Name = self.TFName.text
            toy.Description = self.TFDescription.text
            toy.Price = self.TFPrice.text
            toy.Size = self.TFSize.text
            toy.OwnerId = UserDefaults.standard.string(forKey:"_id")!
            
            if toy.Name == nil || toy.Description == nil || toy.Price == nil || toy.Size == nil  {
                self.alertMethod(titre: "Warning", message: "all fields are required !!!")
            }else{
                if let image = IMVPost.image {

                ToyViewModal().addToys(Image: image, toy: toy, successHandler:{
                    self.TFName.text = ""
                    self.TFDescription.text = ""
                    self.TFPrice.text = ""
                    self.TFSize.text = ""
                    self.alertMethod(titre: "Success", message: "toy added successfully!")
                    
                }, errorHandler: {
                    self.alertMethod(titre: "Warning", message: "toy wouldn't added !")
                }, noResponseHandler: {})
                    
                }else {
                    self.alertMethod(titre: "warning", message: "toy wouldn't added it needs a photo !")

                }
            }
            
        }
    
    @IBAction func AddPhotoAction(_ sender: Any) {
        showActionSheet()
    }
    
    //methods
    
    func camera()
    {
        let myPickerControllerCamera = UIImagePickerController()
        myPickerControllerCamera.delegate = self
        myPickerControllerCamera.sourceType = UIImagePickerController.SourceType.camera
        myPickerControllerCamera.allowsEditing = true
        self.present(myPickerControllerCamera, animated: true, completion: nil)

    }
  
  
  func gallery()
  {

      let myPickerControllerGallery = UIImagePickerController()
      myPickerControllerGallery.delegate = self
      myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
      myPickerControllerGallery.allowsEditing = true
      self.present(myPickerControllerGallery, animated: true, completion: nil)

  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      
      guard let selectedImage = info[.originalImage] as? UIImage else {
         
          return
     }
      
      self.IMVPost.image = selectedImage
      
      
      self.dismiss(animated: true, completion: nil)
  }
  
  
  func showActionSheet(){

      let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
      actionSheetController.view.tintColor = UIColor.black
      let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
          print("Cancel")
      }
      actionSheetController.addAction(cancelActionButton)

      let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
      { action -> Void in
          self.camera()
      }
      actionSheetController.addAction(saveActionButton)

      let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
      { action -> Void in
          self.gallery()
      }
      
      actionSheetController.addAction(deleteActionButton)
      self.present(actionSheetController, animated: true, completion: nil)
  }

    
}
