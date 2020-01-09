//
//  APIManager.swift
//  Marsplay_Kurian
//
//  Created by Kurian Ninan K on 09/01/20.
//  Copyright © 2020 kurian. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIManager: NSObject {
    
    func downloadPosterImages(currPage: Int,withCompletion completionHandler: @escaping (_ result: NSDictionary) -> Void, withFailureResult failureCompletionHandler: @escaping (_ error: Error) -> Void) {
        let request = "http://www.omdbapi.com/?"+"s=Batman&page=\(currPage)&apikey=eeefc96f"
        Alamofire.request(request, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                debugPrint(response)
                
                if response.result.value != nil{
                    // Response type-1
                    let swiftyJsonVar = JSON(response.result.value ?? "error")
                    let dictJson :NSDictionary
                    if swiftyJsonVar.dictionaryObject != nil {
                        dictJson = swiftyJsonVar.dictionaryObject! as NSDictionary
                    }else{
                        dictJson = [String: String]() as NSDictionary
                    }
                    completionHandler(dictJson)
                }else{
                    if let error = response.result.error as? AFError {
                        failureCompletionHandler(error)
                    }
                }
        }
    }
}
