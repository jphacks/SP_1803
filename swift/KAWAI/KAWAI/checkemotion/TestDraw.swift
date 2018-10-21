import UIKit

class TestDraw: UIView {
    
    var color_id = 1
    var x0 = 50
    var y0 = 50
    var x1 = 100
    var y1 = 100
    
//    var color_id: Int
//    var x0: Int
//    var y0: Int
//    var x1: Int
//    var y1: Int
    
//    init() {
//        // 全てのプロパティを初期化する前にインスタンスメソッドを実行することはできない
//        // printName() → コンパイルエラー
//        self.color_id = 1
//        self.x0 = 50
//        self.y0 = 50
//        self.x1 = 100
//        self.y1 = 100
//
//    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // 初期化などをここに記述
//        self.color_id = 1
//        self.x0 = 50
//        self.y0 = 50
//        self.x1 = 100
//        self.y1 = 100
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // UIBezierPath のインスタンス生成
        let line = UIBezierPath();
        // 起点
        line.move(to: CGPoint(x: x0, y: y0));
        // 帰着点
        line.addLine(to: CGPoint(x: x1, y: y0));
        line.addLine(to: CGPoint(x: y1, y: y1));
        line.addLine(to: CGPoint(x: x0, y: y1));
        // ラインを結ぶ
        line.close()
        
        switch color_id {
        case 1:
            UIColor.red.setStroke()
            break
        case 2:
            UIColor.blue.setStroke()
            break
        case 3:
            UIColor.green.setStroke()
            break
        case 4:
            UIColor.yellow.setStroke()
            break
        default:
            UIColor.red.setStroke()
            break
        }
        // 色の設定
        //UIColor.red.setStroke()
        // ライン幅
        line.lineWidth = 4
        // 描画
        line.stroke();
    }
}
