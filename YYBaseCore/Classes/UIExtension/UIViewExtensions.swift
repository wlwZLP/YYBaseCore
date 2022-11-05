//
//  UIViewExtensions.swift
//  Core
//
//  Created by Chris on 2022/3/10.
//

import Foundation

// MARK: 获取视图控制器、截图
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
    
    /// 视图frame的x
    var x: CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.x
        }
    }
    
    /// 视图frame的y
    var y: CGFloat {
        set {
            frame.origin.y = newValue
        }
        get {
            return frame.origin.y
        }
    }
    
    /// 视图的宽度
    var width: CGFloat {
        set {
            frame.size.width = newValue
        }
        get {
            return frame.size.width
        }
    }
    
    /// 视图的高度
    var height: CGFloat {
        set {
            frame.size.height = newValue
        }
        get {
            return frame.size.height
        }
    }
    
    /// 视图的宽高尺寸
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }
    
    /// 视图底部距离父视图顶部的距离
    var bottom: CGFloat {
        return y + height
    }
    
    /// 视图右边距离父视图左边的距离
    var right: CGFloat {
        return x + width
    }
}

// MARK: 圆角相关
public extension UIView {
    
    /// 设置视图圆角
    /// 注意：必须保证可以获取到视图的宽高尺寸
    ///
    /// - Parameters:
    ///   - conrners: 需要设置的圆角，如果有多个圆角可以写 [.topRight, .bottomRight]
    ///   - radius: 需要设置的圆角大小
    func cornerRadius(corners: UIRectCorner , radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
