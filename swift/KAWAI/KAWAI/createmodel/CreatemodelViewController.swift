//
//  CreatemodelViewController.swift
//  KAWAI
//
//  Created by 横山新 on 2018/10/20.
//  Copyright © 2018年 恵庭艦隊トシキング. All rights reserved.
//

import UIKit
import AVFoundation

enum callMode: String {
    case emotion = "感情"
    case create = "投稿"
}

class CreatemodelViewController: UIViewController {

    // デバイスからの入力と出力を管理するオブジェクトの作成
    var captureSession = AVCaptureSession()
    // カメラデバイスそのものを管理するオブジェクトの作成
    // メインカメラの管理オブジェクトの作成
    var mainCamera: AVCaptureDevice?
    // インカメの管理オブジェクトの作成
    var innerCamera: AVCaptureDevice?
    // 現在使用しているカメラデバイスの管理オブジェクトの作成
    var currentDevice: AVCaptureDevice?
    // キャプチャーの出力データを受け付けるオブジェクト
    var photoOutput : AVCapturePhotoOutput?
    // プレビュー表示用のレイヤ
    var cameraPreviewLayer : AVCaptureVideoPreviewLayer?
    // シャッターボタン
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var maskView: UIView!
    
    @IBOutlet weak var modelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelabel.text = callMode.emotion.rawValue
        self.maskView.isHidden = true
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
//        styleCaptureButton()
        maskView.layer.borderColor = UIColor.yellow.cgColor
        maskView.layer.borderWidth = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // シャッターボタンが押された時のアクション
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        print("hoge")
        let settings = AVCapturePhotoSettings()
        // フラッシュの設定
        settings.flashMode = .auto
        // カメラの手ぶれ補正
        settings.isAutoStillImageStabilizationEnabled = true
        // 撮影された画像をdelegateメソッドで処理
        self.photoOutput?.capturePhoto(with: settings, delegate: self as AVCapturePhotoCaptureDelegate)
    }
    
    @IBAction func callCheckEmotion(_ sender: Any) {
        modelabel.text = callMode.emotion.rawValue
        self.maskView.isHidden = true
    }
    
    @IBAction func callCreateModel(_ sender: Any) {
        modelabel.text = callMode.create.rawValue
        self.maskView.isHidden = false
    }
    
}

//MARK: AVCapturePhotoCaptureDelegateデリゲートメソッド
extension CreatemodelViewController: AVCapturePhotoCaptureDelegate{
    // 撮影した画像データが生成されたときに呼び出されるデリゲートメソッド
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            // Data型をUIImageオブジェクトに変換
            let uiImage = UIImage(data: imageData)
            // 写真ライブラリに画像を保存
            UIImageWriteToSavedPhotosAlbum(uiImage!, nil,nil,nil)
            
            if modelabel.text == callMode.emotion.rawValue {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Emotion") as! CheckEmotionViewController
                secondViewController.postImage = uiImage
                self.present(secondViewController, animated: true, completion: nil)
//                self.navigationController?.pushViewController(secondViewController, animated: true)
            }else {
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "Preview") as! PreviewViewController
                secondViewController.postImage = uiImage
                self.present(secondViewController, animated: true, completion: nil)
//                self.navigationController?.pushViewController(secondViewController, animated: true)
            }
            
//            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
}

//MARK: カメラ設定メソッド
extension CreatemodelViewController{
    // カメラの画質の設定
    func setupCaptureSession() {
//        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        //640 480 4032 3024
    }
    
    // デバイスの設定
    func setupDevice() {
        // カメラデバイスのプロパティ設定
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        // プロパティの条件を満たしたカメラデバイスの取得
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                mainCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                innerCamera = device
            }
        }
        // 起動時のカメラを設定
        currentDevice = mainCamera
    }
    
    // 入出力データの設定
    func setupInputOutput() {
        do {
            // 指定したデバイスを使用するために入力を初期化
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
            // 指定した入力をセッションに追加
            captureSession.addInput(captureDeviceInput)
            // 出力データを受け取るオブジェクトの作成
            photoOutput = AVCapturePhotoOutput()
            // 出力ファイルのフォーマットを指定
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    // カメラのプレビューを表示するレイヤの設定
    func setupPreviewLayer() {
        // 指定したAVCaptureSessionでプレビューレイヤを初期化
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // プレビューレイヤが、カメラのキャプチャーを縦横比を維持した状態で、表示するように設定
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        // プレビューレイヤの表示の向きを設定
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        self.cameraPreviewLayer?.frame = view.frame
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }
    
    // ボタンのスタイルを設定
    func styleCaptureButton() {
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 5
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = min(cameraButton.frame.width, cameraButton.frame.height) / 2
    }
}
