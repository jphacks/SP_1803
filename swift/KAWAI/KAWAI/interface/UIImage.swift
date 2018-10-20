//
//  UIImage.swift
//  HakodateSweets
//
//  Created by FutaYamana on 2018/03/17.
//  Copyright © 2018年 HakodateSweets. All rights reserved.
//

import UIKit

extension UIImage {
    /// 画像を正方形にクリッピングする
    ///
    /// - Returns: クリッピングされた正方形の画像
    func cropping2square()-> UIImage!{
        let cgImage    = self.cgImage
        let width = (cgImage?.width)!
        let height = (cgImage?.height)!
        let cropCGImage = self.cgImage?.cropping(to: CGRect(x: width / 2 - 640 , y: height / 2 - 640, width: 1280, height: 1280))
        
        let cropImage = UIImage(cgImage: cropCGImage!)
        
        return cropImage
    }

    private func min(_ a : Int, _ b : Int ) -> Int {
        if a < b { return a}
        else { return b}
    }
}

extension UIImage {
    
    func rotatedBy(degree: CGFloat, isCropped: Bool = true) -> UIImage {
        let radian = -degree * CGFloat.pi / 180
        var rotatedRect = CGRect(origin: .zero, size: self.size)
        if !isCropped {
            rotatedRect = rotatedRect.applying(CGAffineTransform(rotationAngle: radian))
        }
        UIGraphicsBeginImageContext(rotatedRect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: rotatedRect.size.width / 2, y: rotatedRect.size.height / 2)
        context.scaleBy(x: 1.0, y: -1.0)
        
        context.rotate(by: radian)
        context.draw(self.cgImage!, in: CGRect(x: -(self.size.width / 2), y: -(self.size.height / 2), width: self.size.width, height: self.size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }
    
}
