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
    }
    
    @IBAction func back(_ sender: Any) {
       self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
