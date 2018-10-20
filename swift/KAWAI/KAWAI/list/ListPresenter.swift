//
//  ListPresenter.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/20.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import Foundation
import URLQueryBuilder

//struct SampleModel: Codable {
//    let name: String
//    let email: String
//}


final class ListPresenter {
    typealias View = ListProtocol & ListViewController
    private var state: loadStatus = .initial
    private weak var view: View?
    private var contentsList: [ImageListModel] = []
    
    var numberOfImageListModel: Int {
        return contentsList.count
    }
    
    init(view: View) {
        self.view = view
    }
    
    func imageList(at index: Int) -> ImageListModel? {
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
    
//    func callPostSample() {
//        defer {
//            DispatchQueue.main.async {
//                self.view?.reloadFeed()
//            }
//        }
//        postSample(after: { str in
//            self.contentsList = str
//        },body: "hoge")
//    }
    
    
    private func getSample(after: @escaping ([ImageListModel]) -> Void) {
        guard state != .fetching else { return }
        state = .fetching
        let someDictionary: [String: Any] = ["emotion_id": "0"]
        let queryBuilder: URLQueryBuilder = URLQueryBuilder(dictionary: someDictionary)
        let api = ApiManager(path: "/images",queryString: queryBuilder.build())
        api.request(
            success: {
                (data: Data) in
                print(data)
                do {
                    let contents = try JSONDecoder().decode([ImageListModel].self, from: data)
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
    
//    private func postSample(after: @escaping ([SampleModel]) -> (), body: String) {
//        guard state != .fetching else { return }
//        state = .fetching
//        let parameters: [String: Any] = [
//            "name": body,
//            "email": body
//        ]
//        let api = ApiManager(path: "/post", method: .post, parameters: parameters, queryString: "")
//        api.request(
//            success: {
//                (data: Data) in
//                do {
//                    let contents = try JSONDecoder().decode([SampleModel].self, from: data)
//                    self.state = .success
//                    print(contents)
//                    after(contents)
//                } catch {
//                    self.state = .initial
//                    print(error)
//                }
//
//        },
//            fail: {
//                (error: Error?) in print(error)
//
//        }
//        )
//    }
    
}
