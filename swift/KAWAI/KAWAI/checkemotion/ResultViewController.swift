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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageView.image = postImage!
        // Screen Size の取得
        let screenWidth = self.ImageView.bounds.width
        let screenHeight = self.ImageView.bounds.height
        
        let testDraw = TestDraw(frame: CGRect(x: ImageView.frame.origin.x, y: ImageView.frame.origin.y, width: screenWidth, height: screenHeight))
        self.view.addSubview(testDraw)
        // 不透明にしない（透明）
        testDraw.isOpaque = false
    }
    
    @IBAction func back(_ sender: Any) {
       self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
