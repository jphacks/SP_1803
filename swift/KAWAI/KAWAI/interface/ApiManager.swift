//
//  ApiManager.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/20.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import Alamofire
import Foundation

enum loadStatus {
    case initial
    case fetching
    case success
}

struct ApiManager {
    private let host = "http://35.221.98.97:8080"
    private let method: HTTPMethod
    private var parameters: Parameters?
    private var components = URLComponents()
    
    init(path: String, method: HTTPMethod = .get, parameters: Parameters = [:], queryString: String ) {
        self.method = method
        if parameters.count != 0 {
            self.parameters = parameters
        }else {
            self.parameters = nil
        }
        components.scheme = "http"
        components.host = "35.221.98.97:8080"
        components.query = queryString
        components.path = path
        //        components.port = 8080
    }
    
    func request(success: @escaping (_ data: Data) -> Void, fail: @escaping (_ error: Error?) -> Void) {
        Alamofire.request(components.url ?? host, method: method, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            debugPrint(response)
            switch response.result {
            case .success:
                success(response.data!)
            case .failure(let error):
                fail(error)
            }
        }
    }
}
