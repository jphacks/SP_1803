//
//  PageMenuViewController.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/21.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import UIKit
import PageMenu

class PageMenuViewController: UIViewController {
    
    var pageMenu: CAPSPageMenu?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupPageMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        let naviHeight = UIApplication.shared.statusBarFrame.size.height + self.navigationController!.navigationBar.frame.height
        pageMenu!.view.frame = CGRect(x: 0.0, y: naviHeight, width: self.view.frame.width, height: self.view.frame.height - naviHeight)
        
    }
    
    func setupPageMenu() {
        //        別のstoryboard 初期(initial)にする場合 Is Initial View Controllerにチェックマーク
        let storyboard1: UIStoryboard = UIStoryboard(name: "List", bundle: nil)
        let vc1 = storyboard1.instantiateInitialViewController() as! ListViewController
        vc1.title = "りすと"
        
        let storyboard2: UIStoryboard = UIStoryboard(name: "Createmodel", bundle: nil)
        let vc2 = storyboard2.instantiateInitialViewController() as! CreatemodelViewController
        vc2.title = "さつえい"
        
        
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor.black),
            .selectedMenuItemLabelColor(UIColor.black),
            .menuItemSeparatorWidth(2.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(0.0)
        ]
        pageMenu = CAPSPageMenu(viewControllers: [vc1, vc2], frame: view.bounds, pageMenuOptions: parameters)
        self.addChild(pageMenu!)
        self.view.addSubview(pageMenu!.view)
    }
    
}

extension PageMenuViewController {
    func setupNC(){
        self.navigationItem.titleView = UIImageView(image:UIImage(named: "header"))
//        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action:#selector(Tap(_:)))
//        self.navigationItem.rightBarButtonItem = composeButton
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    
    @objc func Tap(_ sender: UIButton) {
        // 次の画面へ移動
        performSegue(withIdentifier: "toPostTalkVC", sender: nil)
    }
}

