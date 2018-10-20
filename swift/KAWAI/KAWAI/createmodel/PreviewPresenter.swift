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

struct ImageCreateModel: Codable {
    let user_id: Int
    let emotion_id: Int
    let gender: String
    let created_at: String
}


final class PreviewPresenter {
    typealias View = PreviewProtocol & PreviewViewController
    private var state: loadStatus = .initial
    private weak var view: View?
    private var contentsList: [ImageCreateModel] = []
    
    
    private var components = URLComponents()
    private let host = "http://35.221.98.97"
    
    var numberOfSampleModel: Int {
        return contentsList.count
    }
    
    init(view: View) {
        self.view = view
    }
    
    func sample(at index: Int) -> ImageCreateModel? {
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
    
    
    private func getSample(after: @escaping ([ImageCreateModel]) -> Void) {
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
                    let contents = try JSONDecoder().decode([ImageCreateModel].self, from: data)
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
    
    private func postSample(after: @escaping ([ImageCreateModel]) -> (), body: String) {
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
                    let contents = try JSONDecoder().decode([ImageCreateModel].self, from: data)
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
    
    func postImage(postImage: UIImage?, emotion_id: Int) {
        
        components.scheme = "http"
        components.host = "35.221.98.97"
        components.path = "/images"
        components.port = 8080
        
        print(components.url)
        // 現在時刻を取得
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let displayTime = formatter.string(from: Date())
        
        // pngへ変換
        let imageData = postImage?.pngData()
        
        // 送るmodel
        let record = ImageCreateModel(user_id: 0, emotion_id: emotion_id, gender: "male", created_at: displayTime)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // 送信する値の指定をここでします
                let encoder = JSONEncoder()
                do {
                    let data = try encoder.encode(record)
                    let jsonstr:String = String(data: data, encoding: .utf8)!
                    multipartFormData.append(data, withName: "prop", mimeType: "application/json")
                } catch {
                    print(error.localizedDescription)
                }
                multipartFormData.append(imageData!, withName: "image", fileName: "bobfile.png", mimeType: "image/png")
        },
            to: components.url ?? host,
            encodingCompletion: { encodingResult in //debugPrint(encodingResult)
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        // 成功
                        let responseData = response
                        print(responseData)
                    }
                case .failure(let encodingError):
                    // 失敗
                    print(encodingError)
                }
        }
        )
    }
    
}
