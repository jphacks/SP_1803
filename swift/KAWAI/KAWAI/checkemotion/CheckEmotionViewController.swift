//
//  CheckEmotionViewController.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/20.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import UIKit
import AVFoundation

protocol CheckEmotionProtocol: class {
    func reloadFeed()
}

class CheckEmotionViewController: UIViewController {
    
    var postImage: UIImage?
    // インジケータのインスタンス
    let indicator = UIActivityIndicatorView()
    @IBOutlet weak var previewImage: UIImageView!

    
    private var presenter: CheckEmotionPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let clip = postImage?.cropping2square()
        previewImage.image = postImage!
        setPresenter: do {
            presenter = CheckEmotionPresenter(view: self)
        }
        setIndicator: do {
            // UIActivityIndicatorView のスタイルをテンプレートから選択
            self.indicator.style = .whiteLarge
            
            // 表示位置
            self.indicator.center = self.view.center
            
            // 色の設定
            self.indicator.color = UIColor.red
            
            // アニメーション停止と同時に隠す設定
            self.indicator.hidesWhenStopped = true
            
            // 画面に追加
            self.view.addSubview(self.indicator)
            
            // 最前面に移動
            self.view.bringSubviewToFront(self.indicator)
        }
    }
    
    @IBAction func imageUpload(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "確認", message: "送信してもよろしいでしょうか？", preferredStyle:  UIAlertController.Style.actionSheet)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.presenter.callPostImage(postImage2: self.postImage ?? UIImage())
            UIImageWriteToSavedPhotosAlbum(self.postImage!, nil,nil,nil)
            
            // アニメーション開始
            self.indicator.startAnimating()
            
//            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Result") as! ResultViewController
//            secondViewController.postImage = self.postImage!
//            // 5秒後に実行
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
//                self.indicator.stopAnimating()
//                self.present(secondViewController, animated: true, completion: nil)
//            }
            
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backbutton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension CheckEmotionViewController: CheckEmotionProtocol {
    
    func reloadFeed() {
        self.indicator.stopAnimating()
//        debugPrint(self.presenter.numberOfSampleModel)

        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Result") as! ResultViewController
        secondViewController.postImage = self.postImage!
        secondViewController.clipData = (self.presenter.contentsLista?.data)!

        self.present(secondViewController, animated: true, completion: nil)
        
    }
    
}

