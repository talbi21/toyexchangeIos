//
//  ProfileModificationController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 14/11/2021.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import AlamofireImage

class ProfileModificationController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate  ,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var mMapView: MKMapView!
    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"
    
    
    //widgets
    @IBOutlet weak var IMVProfileModificationImage: UIImageView!
    
    @IBOutlet weak var TFUserName: UITextField!
    
    @IBOutlet weak var TFEmail: UITextField!
    
    @IBOutlet weak var TFPhoneNumber: UITextField!
    
    @IBOutlet weak var LabelPersonal: UILabel!
    
    @IBOutlet weak var LabelSetLocation: UILabel!
    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mMapView.layer.cornerRadius = 10
        mMapView.layer.masksToBounds = true

        //Style UserName TestField
        TFUserName.layer.cornerRadius = 10.0
        TFUserName.layer.borderWidth = 1.0
        TFUserName.layer.masksToBounds = true
        
        //Style New Phone Number TestField
        TFEmail.layer.cornerRadius = 10.0
        TFEmail.layer.borderWidth = 1.0
        TFEmail.layer.masksToBounds = true
        
        //Style New Phone Number TestField
        TFPhoneNumber.layer.cornerRadius = 10.0
        TFPhoneNumber.layer.borderWidth = 1.0
        TFPhoneNumber.layer.masksToBounds = true
        
        IMVProfileModificationImage?.layer.cornerRadius = (IMVProfileModificationImage?.frame.size.width ?? 0.0) / 2
        IMVProfileModificationImage?.clipsToBounds = true
        IMVProfileModificationImage?.layer.borderWidth = 2.0
        IMVProfileModificationImage?.layer.borderColor = UIColor.black.cgColor
        
        
        var path = String("http://localhost:3000/"+UserDefaults.standard.string(forKey:"image")!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!

             path = path.replacingOccurrences(of: "%5C", with: "/", options: NSString.CompareOptions.literal, range: nil)
              let url = URL(string: path)!
              print(url)
        IMVProfileModificationImage.af.setImage(withURL: url)
        
        TFUserName.text = UserDefaults.standard.string(forKey:"userName")!
        TFEmail.text = UserDefaults.standard.string(forKey:"email")!
        TFPhoneNumber.text = UserDefaults.standard.string(forKey:"phoneNumber")!
        
        let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
    
        if (IsDark == true){
            overrideUserInterfaceStyle = .dark

        }else{
            overrideUserInterfaceStyle = .light
           
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        determineCurrentLocation()
        
            let IsDark = UserDefaults.standard.bool(forKey: "IsDark")
        
            if (IsDark == true){
                overrideUserInterfaceStyle = .dark

            }else{
                overrideUserInterfaceStyle = .light
               
            }
        
    }

    @IBAction func AddAvatrPhoto(_ sender: Any) {
        showActionSheet()
    }
    
    
    @IBAction func BtnUpdateProfile(_ sender: Any) {
        
        var clientU = Client()
        
        clientU._id = UserDefaults.standard.string(forKey:"_id")!
        clientU.userName = self.TFUserName.text!
        clientU.email = self.TFEmail.text!
        clientU.phoneNumber = self.TFPhoneNumber.text!
        
        print(clientU)
        ClientViewModal().updateUser(image: IMVProfileModificationImage.image!, client: clientU, successHandler:{client in
            //to add to userr defaults
            UserDefaults.standard.setValue(client.userName, forKey: "userName")
            UserDefaults.standard.setValue(client.email, forKey: "email")
            UserDefaults.standard.setValue(client.phoneNumber, forKey: "phoneNumber")
            UserDefaults.standard.setValue(client.image, forKey: "image")
            
            self.alertMethod(titre: "success", message: "updated successfully !")
        } , errorHandler:{
            self.alertMethod(titre: "warning", message: "not updated  !")
        } )


    }
    
    //methods
    //Set a pin at current location
    //CLLocationManagerDelegate Methods
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let mUserLocation:CLLocation = locations[0] as CLLocation

            let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
            let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

            mMapView.setRegion(mRegion, animated: true)
            
            // Get user's Current Location and Drop a pin
            let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
                mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
                mkAnnotation.title = self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
                mMapView.addAnnotation(mkAnnotation)
            
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                print("Error - locationManager: \(error.localizedDescription)")
            }
    
    //Intance Methods
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    //Intance Methods
    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) -> String {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)

        geoCoder.reverseGeocodeLocation(location) {(placemarks, error) -> Void in
            
            if(error) == nil {
                if placemarks!.count > 0 {
                    let placemark = placemarks?[0]
                    let address = "\(placemark?.locality ?? ""), \(placemark?.country ?? "")"
                    self.currentLocationStr = address
                }
            }
        }
        
        return currentLocationStr
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
      
      self.IMVProfileModificationImage.image = selectedImage
      
      
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
