//
//  ResultViewController.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/21.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var ImageView: UIImageView!
    var postImage: UIImage?
    var clipData: [testModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageView.image = postImage!
        for element in clipData {
            print(element)
        }
        
        var frameX = Int(self.ImageView.frame.origin.x)
        var frameY = Int(self.ImageView.frame.origin.y)
        
        
        var rect = CGRect(x: self.clipData[0].x1 + frameX, y: self.clipData[0].y1 + frameY, width: self.clipData[0].x2 - self.clipData[0].x1, height: self.clipData[0].y2 - self.clipData[0].y1)
        var bobView = UIView(frame: rect)
//        bobView.frame.size.width = CGFloat(self.clipData[0].x2 - self.clipData[0].x1)
//        bobView.frame.size.height = CGFloat(self.clipData[0].y2 - self.clipData[0].y1)
//        var bobView = UIView(frame: CGRect(x: ImageView.frame.origin.x + 163, y: ImageView.frame.origin.y + 200, width: 163, height: 200))
        bobView.backgroundColor = UIColor.clear
        bobView.layer.borderColor = UIColor.yellow.cgColor
        bobView.layer.borderWidth = 10
        
        // Screen Size の取得
        let screenWidth = self.postImage?.size.width
        let screenHeight = self.postImage?.size.height
        
//        let testDraw = TestDraw(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.view.addSubview(bobView)
        // 不透明にしない（透明）
//        testDraw.isOpaque = false
    }
    
    @IBAction func back(_ sender: Any) {
       self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
