//
//  ToyViewModal.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 21/11/2021.
//
import Foundation
import Alamofire

class ToyViewModal{

    static let shared: ToyViewModal = {
            let instance = ToyViewModal()
            return instance
        }()
    
    func deleteToy(toyId:String?,successHandler: @escaping (_ anomalyList: [Toy]) -> (),errorHandler: @escaping () -> ())  {
        
        let url = (Constantes.host + "Toy/delete/"+toyId!)
        print("delete toy : "+url)
        
        AF.request(url, method: .delete).validate().responseDecodable(of: [Toy].self, decoder: JSONDecoder()) { apiResponse in
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

    //---------------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------------
    
    //get Toys with alomofire
    func getToys(successHandler: @escaping (_ anomalyList: [Toy]) -> (),errorHandler: @escaping () -> ())  {
        
        let url = (Constantes.host + "Toy")
        print("getOwnerToy : "+url)
        
        AF.request(url, method: .get).validate().responseDecodable(of: [Toy].self, decoder: JSONDecoder()) { apiResponse in
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
    
    //get toys with ownerID
    func getOwnerToy(OwnerId:String, successHandler: @escaping (_ anomalyList: [Toy]) -> (),errorHandler: @escaping () -> ())
    {
        let url = (Constantes.host + "Toy/me/"+OwnerId)
        print("getOwnerToy : "+url)
        
        AF.request(url, method: .get).validate().responseDecodable(of: [Toy].self, decoder: JSONDecoder()) { apiResponse in
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
    
    //alomofire addToy
    func addToys(Image:UIImage,toy:Toy?,successHandler: @escaping () -> (),errorHandler: @escaping () -> (),noResponseHandler: @escaping () -> ())
    {
        let urlApi = (Constantes.host + "Toy/add")
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Content-Disposition" : "form-data"]
        var parameters = ["":""]
        
        if let Vtoy = toy
        {
            parameters = ["Name":Vtoy.Name!,"Description":Vtoy.Description!,"Price":Vtoy.Price!,"Size":Vtoy.Size!,"OwnerId":Vtoy.OwnerId!]
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Image.jpegData(compressionQuality: 0.5)!, withName: "Image" , fileName: "Image.jpeg", mimeType: "Image/jpeg")
            
            for (key, value) in parameters {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
                
            }
        },to: urlApi, method: .post ,headers: headers).response{ apiResponse in
                    
                guard apiResponse.response != nil else{
                    noResponseHandler()
                    return
                }
        
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
    
    //alomofire update toy
        func updateToys(Image:UIImage,toy:Toy?,successHandler: @escaping (_ toy: Toy?) -> (),errorHandler: @escaping () -> ())
        {
            let urlApi = (Constantes.host + "Toy/update/"+(toy?._id)!)
            print(urlApi)
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data"]

            let parameters = ["_id":toy?._id!,"Name":toy?.Name,"Description":toy?.Description,"Price":toy?.Price,"Size":toy?.Size]
        
            
        AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(Image.jpegData(compressionQuality: 0.5)!, withName: "Image" , fileName: "Image.jpeg", mimeType: "Image/jpeg")

                for (key, value) in parameters {
                    multipartFormData.append((value?.data(using: .utf8))!, withName: key)
                }
        },to: urlApi, method: .post , headers: headers).responseDecodable(of: Toy.self, decoder: JSONDecoder()) { apiResponse in

                guard apiResponse.response != nil else{
                    errorHandler()
                    return
                }
        
                switch apiResponse.response?.statusCode {
                    case 200:
                        successHandler(try! apiResponse.result.get())
                    case 500:
                    print("Error 500 update toy")
                        errorHandler()
                default:
                    errorHandler()
                }
            }
        
        }
    

}
