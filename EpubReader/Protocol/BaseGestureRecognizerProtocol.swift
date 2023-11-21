//
//  BaseGestureRecognizerProtocol.swift
//  EpubReader
//
//  Created by mac on 25/02/2023.
//

import Foundation
import UIKit

internal var ObjcMethodKeyProxy: UInt8 = 0

protocol LongPressProtocol: AnyObject {
    func longPressResult()
}

extension LongPressProtocol where Self: UIView {
    fileprivate var proxy: ObjcMethodProxy {
        get {
            var isTouching: Bool = false
            if let obj = objc_getAssociatedObject(self, &ObjcMethodKeyProxy) as? ObjcMethodProxy {
                return obj
            }
            
            let obj = ObjcMethodProxy { [weak self] press in
                if !isTouching {
                    self?.handleLongPress(press: press)
                    isTouching = true
                }
                if press.state == .ended {
                    isTouching = false
                }
            }
            self.proxy = obj
            return obj
        } set {
            objc_setAssociatedObject(self, &ObjcMethodKeyProxy, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addLongPressGestureRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: proxy, action: #selector(ObjcMethodProxy._handleLongPress(press:)))
        longPress.minimumPressDuration = 0.5
        self.addGestureRecognizer(longPress)
    }
    
    func handleLongPress(press: UILongPressGestureRecognizer) {
        longPressResult()
    }
}

fileprivate class ObjcMethodProxy {
    private let handleLongPress: (UILongPressGestureRecognizer) -> Void
    
    init(handleLongPress: @escaping (UILongPressGestureRecognizer) -> Void) {
        self.handleLongPress = handleLongPress
    }
    
    @objc func _handleLongPress(press: UILongPressGestureRecognizer) {
        handleLongPress(press)
    }
}
