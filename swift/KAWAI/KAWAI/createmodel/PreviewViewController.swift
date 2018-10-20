//
//  PreviewViewController.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/20.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import UIKit

protocol PreviewProtocol: class {
    func reloadFeed()
}

class PreviewViewController: UIViewController {
    
    var postImage: UIImage?
    @IBOutlet weak var previewImage: UIImageView!
    
    private var presenter: PreviewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(postImage)
        previewImage.image = postImage
        setPresenter: do {
            presenter = PreviewPresenter(view: self)
            presenter.postImage(postImage: postImage ?? UIImage())
        }
    }
    
    
}

extension PreviewViewController: PreviewProtocol {
    
    func reloadFeed() {
        print("hoge")
    }
    
}
