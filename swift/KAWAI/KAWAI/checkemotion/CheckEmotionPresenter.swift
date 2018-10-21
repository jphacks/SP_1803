//
//  CheckEmotionPresenter.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/21.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import Foundation
import URLQueryBuilder
import Alamofire

struct testArray: Codable {
    let data: [testModel]
}

struct testModel: Codable {
    let category: String
    let probability: Float
//    let coordinate: [Int]
    let x1: Int
    let y1: Int
    let x2: Int
    let y2: Int
}


final class CheckEmotionPresenter {
    typealias View = CheckEmotionProtocol & CheckEmotionViewController
    private var state: loadStatus = .initial
    private weak var view: View?
    var contentsList: [testModel] = []
    var contentsLista: testArray?


    private var components = URLComponents()
    private let host = "http://35.221.98.97"

    var numberOfSampleModel: Int {
        return contentsList.count
    }

    init(view: View) {
        self.view = view
    }

    func sample(at index: Int) -> testModel? {
        guard index < contentsList.count else { return nil }
        return contentsList[index]
    }

//    func callGetSample() {
//        defer {
//            DispatchQueue.main.async {
//                self.view?.reloadFeed()
//            }
//        }
//        getSample(after: { str in
//            self.contentsList = str
//        })
//    }
//
//    func callPostSample() {
//        defer {
//            DispatchQueue.main.async {
//                self.view?.reloadFeed()
//            }
//        }
//        postSample(after: { str in
//            self.contentsList = str
//        }, body: "hoge")
//    }
    
    func callPostImage(postImage2: UIImage?) {
        postImage(after: { str in
            self.contentsLista = str
            defer {
                DispatchQueue.main.async {
                    self.view?.reloadFeed()
                }
            }
        }, postImage: postImage2)
        
    }


    private func getSample(after: @escaping ([ImageCreateModel]) -> Void) {
        guard state != .fetching else { return }
        state = .fetching
        let someDictionary: [String: Any] = ["name": "bob"]
        let queryBuilder: URLQueryBuilder = URLQueryBuilder(dictionary: someDictionary)
        let api = ApiManager(path: "/get", queryString: queryBuilder.build())
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

    private func postImage(after: @escaping (testArray) -> (), postImage: UIImage?) {
        guard state != .fetching else { return }
        state = .fetching

        components.scheme = "http"
        components.host = "192.168.179.7"
        components.port = 5000

        print(components.url)
        // 現在時刻を取得
        let formatter = DateFormatter()
        // タイムスタンプによる被りを避けるために，ランダムで生成
        let id = String(Int.random(in: 0 ... 100))
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let filename = formatter.string(from: Date()) + String(id) + ".png"

        // pngへ変換
        let imageData = postImage?.jpegData(compressionQuality: 1.0)

        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // 送信する値の指定をここでします
                multipartFormData.append(imageData!, withName: "image", fileName: filename, mimeType: "image/jpeg")
            },
            to: components.url ?? host,
            encodingCompletion: { encodingResult in //debugPrint(encodingResult)
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        // 成功
                        let responseData = response.data!
//                        debugPrint(responseData)
                        do {
                            let contents = try JSONDecoder().decode(testArray.self, from: responseData)
                            self.state = .success
//                            print(contents)
                            after(contents)
                        } catch {
                            self.state = .initial
                            print(error)
                        }
                    }
                case .failure(let encodingError):
                    // 失敗
                    print(encodingError)
                }
            }
        )
    }

}

