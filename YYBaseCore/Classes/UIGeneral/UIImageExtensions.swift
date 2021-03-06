//
//  UIImageExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/10.
//

import Foundation

// MARK: 纯色UIImage、自定义尺寸UIImage、UIImage自动回正

public extension UIImage {
    
    /// 初始化一个纯色的Image
    /// - Parameter color: 需要初始化的image的颜色
    /// - Returns: 返回一个新创建的image
    static func imageWithColor(_ color: UIColor) -> UIImage {
        // 描述矩形
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        // 开启位图上下文
        UIGraphicsBeginImageContext(rect.size)
        // 获取位图上下文
        let context = UIGraphicsGetCurrentContext()
        // 使用color演示填充上下文
        context?.setFillColor(color.cgColor)
        // 按照尺寸渲染上下文
        context?.fill(rect)
        // 从上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 结束上下文
        UIGraphicsEndImageContext()
        
        return image ?? UIImage()
    }
    
    /// 通过view初始化一个image
    /// - Parameter view: 初始化image的指定视图
    /// - Returns: 新的image
    static func imageWithView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.layer.bounds.size, view.layer.isOpaque, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        view.layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    /// 通过指定大小重新绘制image，并返回一个新的image
    /// - Parameter size: 需要重新绘制的image的尺寸
    /// - Returns: 新尺寸的image
    func resize(with size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    /// 重新绘制一个宽高都不超过指定尺寸的image，并返回
    /// - Parameter maxLength: 需要重新绘制的image的最大尺寸
    /// - Returns: 新尺寸的image
    func resize(to maxLength: CGFloat) -> UIImage {
        let length = max(size.width * scale, size.height * scale)
        guard length > maxLength else {
            return self
        }
        
        let lengthRatio = maxLength / length
        let newSize = CGSize(width: size.width * scale * lengthRatio, height: size.height * scale * lengthRatio)
        return resize(with: newSize)
    }
    
    /// 相机拍照的图片自动旋转90度的回正方法
    /// - Returns: 返回调整以后的Image
    func fixImageOrientation() -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        if self.imageOrientation == UIImage.Orientation.up  {
            return self
        }
        
        let width = self.size.width
        let height = self.size.height
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: width, y: height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.rotated(by: CGFloat.pi * 0.5)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: height)
            transform = transform.rotated(by: CGFloat.pi * -0.5)
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        guard let colorSpace = cgImage.colorSpace else {
            return nil
        }
        
        guard let context = CGContext(data: nil,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: cgImage.bitsPerComponent,
                                      bytesPerRow: 0,
                                      space: colorSpace,
                                      bitmapInfo: UInt32(cgImage.bitmapInfo.rawValue))
        else {
            return nil
        }
        
        context.concatenate(transform)
        
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        guard let newCGImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: newCGImage)
    }
    
}

// MARK: iconFont UIImage

public extension UIImage {
    
    /// 通过指定的iconFont样式及配置，初始化一个Image
    /// - Parameters:
    ///   - meta: iconFont 样式
    ///   - size: iconFont 大小
    ///   - textColor: iconFont 文字颜色
    ///   - backgroundColor: 背景色
    ///   - borderColor: 边框颜色，当设置边框时，文字颜色无效
    ///   - borderWidth: 边框宽度
    /// - Returns: 绘制的Image
    static func iconFont(with meta: BMIconFontMetadata, size: CGSize, textColor: UIColor = .white, backgroundColor: UIColor = .clear, borderColor: UIColor = .clear, borderWidth: CGFloat = 0) -> UIImage {
        // 防止崩溃，宽高最小为1px
        let safeSize = CGSize(width: max(size.width, 1), height: max(size.height, 1))

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let fontSize = min(safeSize.width, safeSize.height)

        let strokeWidth = borderWidth
        let iconFont = UIFont.iconFont(fontSize)

        let attributedString = NSAttributedString(string: meta.rawValue, attributes: [.font: iconFont, .foregroundColor: textColor, .backgroundColor: backgroundColor, .paragraphStyle: paragraph, .strokeWidth: strokeWidth, .strokeColor: borderColor])

        UIGraphicsBeginImageContextWithOptions(safeSize, false, UIScreen.main.scale)
        attributedString.draw(in: CGRect(x: 0, y: (safeSize.height - fontSize) / 2.0, width: safeSize.width, height: fontSize))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = image else {
            return UIImage()
        }

        return image.withRenderingMode(.alwaysOriginal)
    }
    
}


