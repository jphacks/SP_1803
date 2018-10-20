//
//  PreviewViewController.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/20.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import UIKit
import AVFoundation

protocol PreviewProtocol: class {
    func reloadFeed()
}

class PreviewViewController: UIViewController {
    
    var postImage: UIImage?
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    var pickerView: UIPickerView = UIPickerView()
    let list: [String] = ["かっこいい","かわいい","おもしろい","キモい"]
    
    private var presenter: PreviewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clip = postImage?.cropping2square()
        previewImage.image = clip?.rotatedBy(degree: 90)
        setPresenter: do {
            presenter = PreviewPresenter(view: self)
        }
        
        // ピッカー設定
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        // インプットビュー設定
        textField.inputView = pickerView
        textField.inputAccessoryView = toolbar
        
        // デフォルト設定
        pickerView.selectRow(2, inComponent: 0, animated: false)
    }
    
    @IBAction func imageUpload(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "確認", message: "送信してもよろしいでしょうか？", preferredStyle:  UIAlertController.Style.actionSheet)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.presenter.postImage(postImage: self.postImage ?? UIImage(),emotion_id: self.pickerView.selectedRow(inComponent: 0))
            UIImageWriteToSavedPhotosAlbum(self.previewImage.image!, nil,nil,nil)
            print("OK")
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
    
    // 決定ボタン押下
    @objc func done() {
        textField.endEditing(true)
        textField.text = "\(list[pickerView.selectedRow(inComponent: 0)])"
    }
    
    @IBAction func backbutton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension PreviewViewController: PreviewProtocol {
    
    func reloadFeed() {
        print("hoge")
    }
    
}

extension PreviewViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    // ドラムロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // ドラムロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    // ドラムロールの各タイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
    
}
