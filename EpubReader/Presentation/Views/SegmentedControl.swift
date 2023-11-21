//
//  SegmentedControl.swift
//  EpubReader
//
//  Created by mac on 07/11/2022.
//

import UIKit

class SegmentedControl: UISegmentedControl {

    enum ShadowStyle {
        case none, light, regular
    }
    
    var contentWidth: CGFloat = 0
    var selectedSegmentFrame: CGRect = .zero
    var segmentUnderline: CALayer!
    
    init(segmentFrame: CGRect, highlightColour: UIColor, shadowStyle: ShadowStyle) {
        print("PurchaseView self init")
        super.init(frame: segmentFrame)
        
        // Cell Colours
        let titleColour = UIColor.color(with: .background)
        let segmentColour = UIColor.color(with: .hightlight)

        clipsToBounds = false
        
        self.backgroundColor = .clear
        self.tintColor = .clear
        if #available(iOS 13.0, *) {
            let newBackgroundImage = segmentColour.image()
            self.setBackgroundImage(newBackgroundImage, for: .normal, barMetrics: .default)
            self.selectedSegmentTintColor = .clear
        }

        let segFont = UIFont.font(with: .h5)
        let attr: [NSAttributedString.Key: Any] = [.font: segFont, .foregroundColor: titleColour.withAlphaComponent(0.5)]
        let attrSelected : [NSAttributedString.Key : Any] = [.font: segFont, .foregroundColor: titleColour]
        UISegmentedControl.appearance().setTitleTextAttributes(attr, for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(attrSelected, for: .selected)
        removeBorders()
        
        switch shadowStyle {
        case .light:
            layer.masksToBounds = false
            layer.shadowRadius = 21
            layer.shadowOffset = .init(width: 0, height: 4)
            layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
            layer.shadowOpacity = 1
        case .regular:
            layer.masksToBounds = false
            layer.shadowRadius = 3.84
            layer.shadowOffset = .init(width: 0, height: 2)
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.1
        case .none: break
        }
        
        segmentUnderline = CALayer()
        segmentUnderline.borderWidth = 2
        segmentUnderline.borderColor = highlightColour.cgColor
        self.layer.addSublayer(segmentUnderline)
        
        self.updateLayerFrames()
    }
    
    private override init(frame: CGRect) {
        print("override init")
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateLayerFrames() {
        updateSegmentUnderlineIfNeeded()
    }
    
    private func updateSegmentUnderlineIfNeeded() {
        guard numberOfSegments > 0 else { return }
        guard selectedSegmentIndex >= 0 else { return }
        
        let segmentOffset: CGFloat = 8
        let segmentTitleHorizontalPadding: CGFloat = 3
        let segmentHorizontalPadding: CGFloat = 24
        var segmentTitleWidths = [CGFloat]()

        for segmentIndex in 0..<numberOfSegments {
            let title = titleForSegment(at: segmentIndex)
            let size = title!.size(withAttributes: [NSAttributedString.Key.font: UIFont.font(with: .h5)])
            segmentTitleWidths.append(size.width+segmentTitleHorizontalPadding)
        }

        for segmentIndex in 0..<numberOfSegments {
            let width = segmentTitleWidths[segmentIndex] + segmentHorizontalPadding
            setWidth(width, forSegmentAt: segmentIndex)
            setContentOffset(.init(width: segmentOffset, height: 0), forSegmentAt: segmentIndex)
        }
        
        let selectedSegmentX = (0..<selectedSegmentIndex).reduce(0, { $0 + widthForSegment(at: $1 ) })
        let selectedSegmentPadding = (widthForSegment(at: selectedSegmentIndex) - segmentTitleWidths[selectedSegmentIndex])/2

        segmentUnderline.frame = CGRect(x: selectedSegmentX+selectedSegmentPadding+segmentOffset,
                                        y: frame.size.height-segmentUnderline.borderWidth,
                                        width: segmentTitleWidths[selectedSegmentIndex],
                                        height: segmentUnderline.borderWidth)
        let calculatedContentWidth = segmentTitleWidths
            .reduce(segmentHorizontalPadding, { $0 + $1 + segmentHorizontalPadding})
        contentWidth = max(UIScreen.main.bounds.size.width, calculatedContentWidth)
        selectedSegmentFrame = segmentUnderline.frame
        var selectedFrameSize = selectedSegmentFrame.size
        selectedFrameSize.width += 2 * segmentHorizontalPadding
        var selectedFrameOrigin = selectedSegmentFrame.origin
        selectedFrameOrigin.x -= segmentHorizontalPadding
        selectedSegmentFrame.origin = selectedFrameOrigin
        selectedSegmentFrame.size = selectedFrameSize
    }
    
    private func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }

    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0
        layer.borderWidth = 0
    }
}
