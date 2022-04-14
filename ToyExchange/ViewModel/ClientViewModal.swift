//
//  ClientViewModal.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 10/11/2021.
//
import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON


extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}


class ClientViewModal :ObservableObject {
    //var
    static let sharedInstance = ClientViewModal()
    
    var tokenString :String?
    
    var ClientToken : Client?
    let defaultUserToken = UserDefaults.standard
    
  
    //-------------------------------------------------------------------------------------------------------------------------
    //login releted
    func login(email:String,password:String,successHandler: @escaping (_ token : JSON ) -> (),errorHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Client/loginClient" )

        let parameters = ["email":email,"password":password] as [String : Any]
        let defaults = UserDefaults.standard
        
        AF.request(urlApi,method: .post,parameters: parameters).response{ apiResponse in

                switch apiResponse.response?.statusCode {
                    case 200:
                       
                        self.defaultUserToken.removeObject(forKey: "jsonwebtoken")
                        defaults.setValue(self.tokenString, forKey: "jsonwebtoken")
                    
                    successHandler(JSON(try! apiResponse.result.get()!))
                    case 500:
                        errorHandler()
                default:
                    errorHandler()
                }
        }
    
    }
    
    func getuserfromtoken(token : String,successHandler: @escaping (_ client : Client) -> (),errorHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Client/findToken" )

        let parameters = ["token":token] as [String : Any]
        //let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        //request.addValue(token, forHTTPHeaderField: "authorization")
        
        let headers : HTTPHeaders    = [ "Authorization" : token ]
        AF.request(urlApi,method: .post,parameters: parameters,headers: headers).responseDecodable(of: Client.self, decoder: JSONDecoder()){ apiResponse in
                guard apiResponse.response != nil else{
                    errorHandler()
                    return
                }
            
                switch apiResponse.response?.statusCode {
                    case 200:
                        successHandler(try! apiResponse.result.get())
                    case 500:
                        errorHandler()
                default:
                    errorHandler()
                }
        }
    
    }
    //-------------------------------------------------------------------------------------------------------------------------
    //loginGoogle releted
    func loginGoogle(email:String,password:String,username:String,phonenumber:String,successHandler: @escaping (_ token : JSON ) -> (),errorHandler: @escaping () -> ())
    {
        let urlApi = ( Constantes.host + "Client/auth" )

        let parameters = ["email":email,"password":password,"userName":username,"phoneNumber":phonenumber] as [String : Any]
        //let defaults = UserDefaults.standard
        
        AF.request(urlApi,method: .post,parameters: parameters).response{ apiResponse in

                switch apiResponse.response?.statusCode {
                    case 200:
                       
                        self.defaultUserToken.removeObject(forKey: "jsonwebtoken")
                    self.defaultUserToken.setValue(self.tokenString, forKey: "jsonwebtoken")
                    
                    successHandler(JSON(try! apiResponse.result.get()!))
                    case 500:
                        errorHandler()
                default:
                    errorHandler()
                }
        }
    
    }

    //------------logout----------------------
    func signout() {

        self.defaultUserToken.removeObject(forKey: "_id")
        self.defaultUserToken.removeObject(forKey: "userName")
        self.defaultUserToken.removeObject(forKey: "email")
        self.defaultUserToken.removeObject(forKey: "phoneNumber")
        self.defaultUserToken.removeObject(forKey: "image")

    }
    //-------------------------------------------------------------------------------------------------------------------------
    
    //-------------------------------------------------------------------------------------------------------------------------
    //-------------------------------------------------------------------------------------------------------------------------
    
    //-------------------------------------------------------------------------------------------------------------------------
    //SignUp releted
    func createClient(username:String,email:String,password:String,phone:String,successHandler: @escaping () -> (),errorHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Client/add" )

        let parameters = ["userName":username,"email":email,"password":password,"phoneNumber":phone] as [String : Any]
        
        AF.request(urlApi,method: .post,parameters: parameters).response{ apiResponse in
        
                switch apiResponse.response?.statusCode {
                    case 200:
                        successHandler()
                    case 500:
                        errorHandler()
                default:
                    errorHandler()
                }
        }
    
    }
    //-------------------------------------------------------------------------------------------------------------------------
    //update Password
    func updatePassword(id:String,newPassword:String,oldPassword:String,successHandler: @escaping () -> (),errorHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Client/updatePassword/" + id )

        let parameters = ["newPassword":newPassword,"oldPassword":oldPassword] as [String : Any]
        
        AF.request(urlApi,method: .post,parameters: parameters).response{ apiResponse in
        
                switch apiResponse.response?.statusCode {
                    case 200:
                        successHandler()
                    case 500:
                        errorHandler()
                default:
                    errorHandler()
                }
        }
    
    }
    //-------------------------------------------------------------------------------------------------------------------------
    //reinitialise Password
    func reinitialisePassword(email:String,newPassword:String,successHandler: @escaping () -> (),errorHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Client/ReinitialisePassword")
        let parameters = ["newPassword":newPassword,"email":email] as [String : Any]
        
        AF.request(urlApi,method: .post,parameters: parameters).response{ apiResponse in
        
                switch apiResponse.response?.statusCode {
                    case 200:
                        successHandler()
                    case 500:
                        errorHandler()
                default:
                    print("error")
                    errorHandler()
                }
        }
        
    }
    
    //-------------------------------------------------------------------------------------------------------------------------
    func sendEmail(email:String,code:Int,successHandler: @escaping () -> (),errorHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Client/sendEmail")
        let parameters = ["email":email,"code":code] as [String : Any]
        
        AF.request(urlApi,method: .post,parameters: parameters).response{ apiResponse in
        
                switch apiResponse.response?.statusCode {
                    case 200:
                        successHandler()
                    case 500:
                        errorHandler()
                default:
                    print("error")
                    errorHandler()
                }
        }
        
    }
    
    //alamofire update profile
    func updateUser(image:UIImage,client:Client?,successHandler: @escaping (_ client: Client) -> (),errorHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Client/update/"+(client?._id)!)
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        let parameters = ["userName":client?.userName,"email":client?.email,"phoneNumber":client?.phoneNumber]
        
    AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: "image" , fileName: "image.jpeg", mimeType: "image/jpeg")

            for (key, value) in parameters {
                multipartFormData.append((value?.data(using: .utf8))!, withName: key)
            }
        
        },to: urlApi, method: .post , headers: headers).responseDecodable(of: Client.self, decoder: JSONDecoder()) { apiResponse in
            guard apiResponse.response != nil else{
                errorHandler()
                return
            }
    
            switch apiResponse.response?.statusCode {
                case 200:
                    successHandler(try! apiResponse.result.get())
                case 500:
                    errorHandler()
                    
            default:
                errorHandler()
            }
        }
    
    }
    
    //-------------------------------------------------------------------------------------------------------------------------
    func getAllClients ( successHandler: @escaping (_ anomalyList: [Client]) -> (),errorHandler: @escaping () -> ())
    {
        let url = (Constantes.host + "Client/")
        
        AF.request(url, method: .get).validate().responseDecodable(of: [Client].self, decoder: JSONDecoder()) { apiResponse in
            guard apiResponse.response != nil else{
                errorHandler()
                return
            }
            
            switch apiResponse.response?.statusCode {
                
                case 200:
                successHandler(try! apiResponse.result.get())

                case 500:
                errorHandler()
           
            default:
              errorHandler()
                
            }
            
        }
        
    }
    
    //-------------------------------------------------------------------------------------------------------------------------
    func recupererToutUtilisateur( completed: @escaping (Bool, [Client]?) -> Void ) {
            AF.request(Constantes.host + "Client",
                       method: .get)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    switch response.result {
                    case .success:
                        print(response)
                        var clients : [Client]? = []
                        for singleJsonItem in JSON(response.data!) {
                            clients!.append(self.makeItem(jsonItem: singleJsonItem.1))
                            
                        }
                        completed(true, clients)
                    case let .failure(error):
                        debugPrint(error)
                        completed(false, nil)
                    }
                }
    }
    
    //-------------------------------------------------------------------------------------------------------------------------
    func makeItem(jsonItem: JSON) -> Client {
                return Client(
                    _id: jsonItem["_id"].stringValue,
                    userName: jsonItem["userName"].stringValue,
                    email: jsonItem["email"].stringValue,
                    password: jsonItem["password"].stringValue,
                    phoneNumber: jsonItem["phoneNumber"].stringValue,
                    image: jsonItem["image"].stringValue
                )
    }
    
}
