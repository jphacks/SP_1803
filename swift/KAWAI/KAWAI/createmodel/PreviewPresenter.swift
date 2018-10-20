//
//  PreviewPresenter.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/20.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import Foundation
import URLQueryBuilder
import Alamofire

struct SampleModel: Codable {
    let name: String
    let email: String
}


final class PreviewPresenter {
    typealias View = PreviewProtocol & PreviewViewController
    private var state: loadStatus = .initial
    private weak var view: View?
    private var contentsList: [SampleModel] = []
    
    var numberOfSampleModel: Int {
        return contentsList.count
    }
    
    init(view: View) {
        self.view = view
    }
    
    func sample(at index: Int) -> SampleModel? {
        guard index < contentsList.count else { return nil }
        return contentsList[index]
    }
    
    func callGetSample() {
        defer {
            DispatchQueue.main.async {
                self.view?.reloadFeed()
            }
        }
        getSample(after: { str in
            self.contentsList = str
        })
    }
    
    func callPostSample() {
        defer {
            DispatchQueue.main.async {
                self.view?.reloadFeed()
            }
        }
        postSample(after: { str in
            self.contentsList = str
        },body: "hoge")
    }
    
    
    private func getSample(after: @escaping ([SampleModel]) -> Void) {
        guard state != .fetching else { return }
        state = .fetching
        let someDictionary: [String: Any] = ["name": "bob"]
        let queryBuilder: URLQueryBuilder = URLQueryBuilder(dictionary: someDictionary)
        let api = ApiManager(path: "/get",queryString: queryBuilder.build())
        api.request(
            success: {
                (data: Data) in
                print(data)
                do {
                    let contents = try JSONDecoder().decode([SampleModel].self, from: data)
                    self.state = .success
                    after(contents)
                } catch {
                    self.state = .initial
                }
        },
            fail: {
                (error: Error?) in print(error)
                
        }
        )
        
    }
    
    private func postSample(after: @escaping ([SampleModel]) -> (), body: String) {
        guard state != .fetching else { return }
        state = .fetching
        let parameters: [String: Any] = [
            "name": body,
            "email": body
        ]
        let api = ApiManager(path: "/post", method: .post, parameters: parameters, queryString: "")
        api.request(
            success: {
                (data: Data) in
                do {
                    let contents = try JSONDecoder().decode([SampleModel].self, from: data)
                    self.state = .success
                    print(contents)
                    after(contents)
                } catch {
                    self.state = .initial
                    print(error)
                }
                
        },
            fail: {
                (error: Error?) in print(error)
                
        }
        )
    }
    
    func postImage(postImage: UIImage?) {
        print("あれれ")
        debugPrint(postImage?.pngData())
        
        let imageData = postImage?.pngData()
        
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // 送信する値の指定をここでします
                multipartFormData.append(imageData!, withName: "bob", fileName: "bobfile", mimeType: "image/png")
//                multipartFormData.append(sendmsg.data(using: String.Encoding.utf8)!, withName: "userId")
        },
            to: "http://~~~.com/image-upload//images",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        // 成功
                        let responseData = response
                        print(responseData ?? "成功")
                    }
                case .failure(let encodingError):
                    // 失敗
                    print(encodingError)
                }
        }
        )
    }
    
}
