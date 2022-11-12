//
//  ScrollUISegmentController.swift
//  EpubReader
//
//  Created by mac on 07/11/2022.
//

import UIKit

protocol ScrollUISegmentControllerDelegate: AnyObject {
    func selectItemAt(_ sender: SegmentedControl)
}

class ScrollUISegmentController: UIScrollView {
    public var segmentedControl: SegmentedControl!
    public var itemsCount: Int = 3
    public var segmentheight : CGFloat = 32.0
    
    private var shadowStyle: SegmentedControl.ShadowStyle = .none
    weak var segmentDelegate: ScrollUISegmentControllerDelegate?
    
    @IBInspectable
    public var segmentTintColor: UIColor = .black {
        didSet {
            self.segmentedControl.tintColor = self.segmentTintColor
        }
    }
    
    @IBInspectable
    public var highlightColour: UIColor = UIColor.color(with: .hightlight) {
        didSet {}
    }
    
    @IBInspectable
    public var itemWidth: CGFloat = 100 {
        didSet {}
    }
    
    public var segmentItems: Array = ["1","2","3"] {
        didSet {
            if oldValue != segmentItems {
                self.itemsCount = segmentItems.count
                self.createSegment()
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, shadowStyle: SegmentedControl.ShadowStyle) {
        super.init(frame: frame)
        self.shadowStyle = shadowStyle
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.segmentedControl != nil {
            segmentheight =  self.frame.height
            var width = CGFloat(self.itemWidth * CGFloat(self.itemsCount))
            if width < self.frame.width {
                width = self.frame.width
            }
            self.segmentedControl.frame = CGRect(x: 0 , y: 0, width: width, height: segmentheight)
            self.segmentedControl.updateLayerFrames()
            self.segmentedControl.backgroundColor = backgroundColor
            let contentHeight =  self.frame.height
            self.segmentedControl.frame = CGRect(x: 0 ,
                                                 y: 0,
                                                 width: segmentedControl.contentWidth,
                                                 height: segmentheight)
            self.contentSize = CGSize (width: segmentedControl.contentWidth,
                                       height: contentHeight)
        }
    }
    
    func createSegment() {
        if self.segmentedControl != nil {
            self.segmentedControl.removeFromSuperview()
        }
        self.segmentedControl = SegmentedControl(segmentFrame: .zero,
                                                 highlightColour: self.highlightColour,
                                                 shadowStyle: shadowStyle)
        self.segmentedControl.updateLayerFrames()
        self.addSubview(self.segmentedControl)
        self.backgroundColor = .clear
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        NSLayoutConstraint(item: self.segmentedControl as Any,
                           attribute: NSLayoutConstraint.Attribute.centerX,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: self,
                           attribute: NSLayoutConstraint.Attribute.centerX,
                           multiplier: 1,
                           constant: 0).isActive = true
        NSLayoutConstraint(item: self.segmentedControl as Any,
                           attribute: NSLayoutConstraint.Attribute.centerY,
                           relatedBy: NSLayoutConstraint.Relation.equal,
                           toItem: self,
                           attribute: NSLayoutConstraint.Attribute.centerY,
                           multiplier: 1,
                           constant: 0).isActive = true
        
        self.segmentedControl.selectedSegmentIndex = 0
        for item in segmentItems {
            self.segmentedControl.insertSegment(withTitle: item.uppercased(),
                                                at: (segmentItems.firstIndex(of: item))!,
                                                animated: false)
        }
        self.segmentedControl.addTarget(self, action: #selector(self.segmentChangeSelectedIndex(_:)), for: .valueChanged)
    }
    
    @objc func segmentChangeSelectedIndex(_ sender: SegmentedControl) {
        segmentDelegate?.selectItemAt(self.segmentedControl)
        print("\(self.segmentedControl.selectedSegmentIndex)")
        self.layoutSubviews()
        updateSelectedSegmentRect()
    }
    
    func updateSelectedSegmentRect() {
        scrollRectToVisible(segmentedControl.selectedSegmentFrame, animated: true)
    }
}
