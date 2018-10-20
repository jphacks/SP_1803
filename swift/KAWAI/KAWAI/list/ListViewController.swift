//
//  ListViewController.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/20.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import UIKit
import Kingfisher

protocol ListProtocol: class {
    func reloadFeed()
}

class ListViewController: UIViewController {
    
    private var presenter: ListPresenter!
    @IBOutlet weak var collectionView: UICollectionView!
    // cellのmargin
    private let margin: CGFloat = 24.0
    
    @IBOutlet weak var listNavBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        ナビゲーションアイテムのタイトルに画像を設定する。
        listNavBar.topItem?.titleView = UIImageView(image:UIImage(named:"header"))
        
        // make UIImageView instance
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.collectionView.frame.width, height: self.collectionView.frame.height))
        // read image
        let image = UIImage(named: "background_m")
        // set image to ImageView
        imageView.image = image
        // set alpha value of imageView
        imageView.alpha = 1.0
        // set imageView to backgroundView of TableView
        self.collectionView.backgroundView = imageView
        
        setCollectionView: do {
            collectionView.delegate   = self
            collectionView.dataSource = self
            collectionView.delaysContentTouches = false
            //自作セルをテーブルビューに登録する。
            let nib = UINib(nibName:"ListCollectionViewCell", bundle:nil)
            collectionView.register(nib, forCellWithReuseIdentifier: "ListCollectionViewCell")
        }
        setPresenter: do {
            presenter = ListPresenter(view: self)
            presenter.callGetSample()
        }
    }
    
    
}

extension ListViewController: ListProtocol {
    
    func reloadFeed() {
//        collectionView.reloadData()
    }
    
}

/*
 データ・ソース
 */
extension ListViewController : UICollectionViewDataSource{
    
    /*
     データ数
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    /*
     セクション数
     */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    /*
     cellの生成
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        
//        let url = URL(string: presenter.imageList(at: indexPath.row)?.image_url ?? "") ?? URL(fileURLWithPath: "https://2.bp.blogspot.com/-2yBvnEiXxXw/W64DVKH5_7I/AAAAAAABPF8/jE45dYz1D4cmCl0Cq6yqfsmvogoAjOc8gCLcBGAs/s800/bentou_businesswoman_cry.png")
//        cell.CardImage.kf.setImage(with: url)
        
        return cell
    }
    
    
}

/*
 セルタップ時の動作定義など
 */
extension ListViewController : UICollectionViewDelegate {
    
    /*
     画面遷移時の処理
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        画面遷移 https://yuu.1000quu.com/screen_transition_in_swift
        //        同一のstoryboard
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Test") as! SecondViewController
//        self.navigationController?.pushViewController(secondViewController, animated: true)
        //        別のstoryboard 初期(initial)にする場合 Is Initial View Controllerにチェックマーク
        //        let storyboard: UIStoryboard = UIStoryboard(name: "Main2", bundle: nil)
        //        let nextView = storyboard.instantiateInitialViewController() as! NextViewController
        //        self.presentViewController(nextView, animated: true, completion: nil)
        //        別のstoryboard
        //        let storyboard: UIStoryboard = UIStoryboard(name: "Main2", bundle: nil)
        //        let nextView = storyboard.instantiateViewControllerWithIdentifier("next") as! NextViewController
        //        self.presentViewController(nextView, animated: true, completion: nil)
        
        // 次の画面へ移動 segue
        //        performSegue(withIdentifier: "toVC", sender: nil)
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //
    //        if segue.identifier == "toVC" {
    //            let nextVC = segue.destination as! SecondViewController
    //        } else {
    //        }
    //    }
    
}

extension ListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth: CGFloat = UIScreen.main.bounds.width * 0.9
        let cellHeight = cellWidth

        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
}

