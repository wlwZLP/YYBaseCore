//
//  UIViewExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/10.
//

import Foundation

public extension UIView {
    /// 获取视图所在的控制器
    var viewController: UIViewController? {
        while let nextResponder = self.next {
            if let controller = nextResponder as? UIViewController {
                return controller
            }
        }
        return nil
    }
    
    /// 获取当前view的截图, 返回Image
    var screenshot: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}

// MARK: 视图Frame相关扩展
public extension UIView {
    var x: CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            frame.origin.y = newValue
        }
        get {
            return frame.origin.y
        }
    }
    
    var width: CGFloat {
        set {
            frame.size.width = newValue
        }
        get {
            return frame.size.width
        }
    }
    
    var height: CGFloat {
        set {
            frame.size.height = newValue
        }
        get {
            return frame.size.height
        }
    }
    
    var bottom: CGFloat {
        return y + height
    }
    
    var right: CGFloat {
        return x + width
    }
}
