//
//  ResultViewController.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/21.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import UIKit

enum BOBOB {
    case cute_m
    case cute_w
    case disgusting_m
    case disgusting_2
    case good_m
    case good_w
    case interesting_m
    case interesting_w
}

class ResultViewController: UIViewController {
    
    @IBOutlet weak var ImageView: UIImageView!
    var postImage: UIImage?
    var clipData: [testModel] = []
    var arrayView: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frameX = Int(self.ImageView.frame.origin.x)
        let frameY = Int(self.ImageView.frame.origin.y)
        
        ImageView.image = postImage!
        for element in clipData {
            let recta = CGRect(x: element.x1/7 + frameX, y: element.y1/7 + frameY, width: (element.x2 - element.x1)/7, height: (element.y2 - element.y1)/7)
            let bobViewa = UIView(frame: recta)
            bobViewa.backgroundColor = UIColor.clear
            bobViewa.layer.borderColor = UIColor.magenta.cgColor
            bobViewa.layer.borderWidth = 10
            
            self.view.addSubview(bobViewa)
            
            let label = UILabel()
            
            if element.category == "cute_m" {
                label.text = "男 かわいい"
                
            }else if element.category == "cute_w" {
                label.text = "女 かわいい"
                
            }else if element.category == "disgusting_m" {
                label.text = "男 キモい"
                
            }else if element.category == "disgusting_w" {
                label.text = "女 キモい"
                
            }else if element.category == "good_m" {
                label.text = "男 かっこいい"
                
            }else if element.category == "good_w" {
                label.text = "女 かっこいい"
                
            }else if element.category == "interesting_m" {
                label.text = "男 おもしろい"
                
            }else {
                label.text = "女 おもしろい"
                
            }
    
            
//            label.text = "かわいい"
            label.textColor = UIColor.magenta
            
            label.frame = CGRect(x: element.x1/7 + frameX, y: element.y1/7 + frameY - 20, width: (element.x2 - element.x1)/7, height: (element.y2 - element.y1)/7)
            self.view.addSubview(label)
        }
        
//        var frameX = Int(self.ImageView.frame.origin.x)
//        var frameY = Int(self.ImageView.frame.origin.y)
        
        
        var rect = CGRect(x: self.clipData[0].x1/7 + frameX-20, y: self.clipData[0].y1/7 + frameY, width: (self.clipData[0].x2/7 - self.clipData[0].x1/7)/2, height: (self.clipData[0].y2/7 - self.clipData[0].y1/7)/2)
//        var rect = CGRect(x: 100, y:260, width:150, height:200)
        
        var bobView = UIView(frame: rect)
//        bobView.frame.size.width = CGFloat(self.clipData[0].x2 - self.clipData[0].x1)
//        bobView.frame.size.height = CGFloat(self.clipData[0].y2 - self.clipData[0].y1)
//        var bobView = UIView(frame: CGRect(x: ImageView.frame.origin.x + 163, y: ImageView.frame.origin.y + 200, width: 163, height: 200))
        
        bobView.backgroundColor = UIColor.clear
        bobView.layer.borderColor = UIColor.magenta.cgColor
        bobView.layer.borderWidth = 10
        // Screen Size の取得
        let screenWidth = self.postImage?.size.width
        let screenHeight = self.postImage?.size.height
        
//        let testDraw = TestDraw(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
//        self.view.addSubview(bobView)

        let label = UILabel()
        label.text = "かわいい"
        label.textColor = UIColor.magenta
//        label.frame = CGRect(x: 100, y:160, width:100, height:100)
        
        label.frame = CGRect(x: self.clipData[0].x1 + frameX, y: self.clipData[0].y1 + frameY-20, width: self.clipData[0].x2 - self.clipData[0].x1, height: self.clipData[0].y2 - self.clipData[0].y1)
//        self.view.addSubview(label)
    }
    
    @IBAction func back(_ sender: Any) {
       self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
