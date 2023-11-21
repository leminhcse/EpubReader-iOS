//
//  ProgressBarView.swift
//  EpubReader
//
//  Created by mac on 27/08/2022.
//

import UIKit

class ProgressBarView: UIView {

    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    var button : UIImageView!
    var viewProgress : UIView!
    
    var progress: Float = 0 {
        willSet(newValue) {
            progressLayer.strokeEnd = CGFloat(newValue)
            if newValue == 1 {
                status = .finish
                progressLayer.strokeEnd = 0.0
            }
        }
    }
    
    var status: Constants.StatusDownloadAudio = .notDownloaded {
        willSet(newValue) {
            willSetStatus(value: newValue)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
        tintColor = UIColor(hex: "#555555")
        self.simpleShape()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.yellow
        bgPath = UIBezierPath()
        self.simpleShape()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = min(frame.width / 2, frame.height / 2)
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.path = UIBezierPath(arcCenter: center,
                                       radius: radius,
                                       startAngle: CGFloat(3*Double.pi/2),
                                       endAngle: CGFloat(7*Double.pi/2),
                                       clockwise: true).cgPath
        progressLayer.path = UIBezierPath(arcCenter: center,
                                          radius: radius,
                                          startAngle: CGFloat(3*Double.pi/2),
                                          endAngle: CGFloat(7*Double.pi/2),
                                          clockwise: true).cgPath
    }
    
    func willSetStatus(value: Constants.StatusDownloadAudio) {
        button.tintColor = .white
        switch value {
        case .finish:
            viewProgress.isHidden = true
            let imageName = "trash.png"
            button.image = UIImage.init(named: imageName)?.withRenderingMode(.alwaysTemplate)
            button.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            break
        case .inProgress:
            viewProgress.isHidden = false
            button.image = UIImage.init(named: "template_stop_square.png")?.withRenderingMode(.alwaysTemplate)
            button.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            break
        case .notDownloaded:
            viewProgress.isHidden = true
            button.image = UIImage.init(named: "download.png")?.withRenderingMode(.alwaysTemplate)
            button.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
            break
        }
    }
    
    private func createCirclePath() {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        print(x,y,center)
        bgPath.addArc(withCenter: center, radius: x/CGFloat(1), startAngle: CGFloat(3*Double.pi/2), endAngle: CGFloat(7*Double.pi/2), clockwise: true)
        bgPath.close()
    }
    
    private func simpleShape() {
        createCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.white.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = 2
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.strokeEnd = 0.0
        
        button = UIImageView()
        button.image = UIImage.init(named: "download.png")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = UIColor.black
        button.contentMode = .scaleAspectFit
        button.center = self.center
        button.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        button.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        viewProgress = UIView()
        viewProgress.frame =  CGRect(x: self.frame.origin.x,
                                     y: self.frame.origin.y,
                                     width: self.bounds.width, height: self.bounds.height)
        viewProgress.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.viewProgress.layer.addSublayer(shapeLayer)
        self.viewProgress.layer.addSublayer(progressLayer)
        self.addSubview(viewProgress)
        self.addSubview(button)
    }
}
