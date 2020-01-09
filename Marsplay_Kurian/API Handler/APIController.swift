//
//  APIController.swift
//  Marsplay_Kurian
//
//  Created by Kurian Ninan K on 09/01/20.
//  Copyright © 2020 kurian. All rights reserved.
//

import UIKit

class APIController: NSObject {

    var apiManager = APIManager()
    
    func downloadPosterImages(currPage: Int,withCompletion completionHandler: @escaping (_ result: NSDictionary) -> Void, withFailureResult failureCompletionHandler: @escaping (_ error: Error) -> Void) {
        apiManager.downloadPosterImages(currPage: currPage, withCompletion: { (result) in
            completionHandler(result)
        }) { (error) in
            failureCompletionHandler(error)
        }
    }
}
