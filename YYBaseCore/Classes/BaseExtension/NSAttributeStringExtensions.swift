//
//  NSAttributeString.swift
//  Core
//
//  Created by Chris on 2022/3/9.
//

import Foundation


// MARK: - Properties
public extension NSAttributedString {

    /// 下划线
    var underlined: NSAttributedString {
        return applying(attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    /// 中间划线
    var strikethroughed: NSAttributedString {
        return applying(attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .baselineOffset : 0])
    }

    /// 属性集合
    var attributes: [NSAttributedString.Key: Any] {
        guard self.length > 0 else {
            return [:]
        }
        return attributes(at: 0, effectiveRange: nil)
    }

}

// MARK: - 方法

public extension NSAttributedString {
    
    /// 设置颜色并返回
    /// - Parameter color: 颜色
    /// - Returns: 设置颜色后的NSAttributedString
    func colored(with color: UIColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    
    
    /// 增加行间距并返回
    /// - Parameters:
    ///   - space: 行间距
    ///   - textAlignment: 对齐方式
    /// - Returns: 设置行间距后的NSAttributedString
    func lineSpaced(with space: CGFloat, alignment: NSTextAlignment = .left) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        paragraphStyle.alignment = alignment
        return applying(attributes: [.paragraphStyle: paragraphStyle])
    }
    
    
    /// 设置字间距并返回
    /// - Parameter space: 字间距
    /// - Returns: 设置行间距后的NSAttributedString
    func kerned(with space: CGFloat) -> NSAttributedString {
        return applying(attributes: [.kern: space])
    }
    
    /// 设置字体并返回
    /// - Parameter font: 字体
    /// - Returns: 设置字体后的NSAttributedString
    func font(with font: UIFont) -> NSAttributedString {
        return applying(attributes: [.font: font])
    }
    
    /// 设置对齐方式并返回
    /// - Parameter alignment: 对齐方式
    /// - Returns: 设置对齐方式后的NSAttributedString
    func textAlignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        return applying(attributes: [.paragraphStyle: paragraphStyle])
    }
    
    /// 为NSAttributedString添加属性并返回
    /// - Parameter attributes: 属性
    /// - Returns: 返回NSAttributedString
    func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)
        return copy
    }
    
    /// 创建图片NSAttributedString
    /// - Parameters:
    ///   - image: 图片
    ///   - bounds: 控制大小位置
    /// - Returns: 图片NSAttributedString
    func attributedString(with image: UIImage, bounds: CGRect) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = bounds
        return .init(attachment: imageAttachment)
    }
    
}

// MARK: 文本高度计算

public extension NSAttributedString {
    
    /// 计算属性文本的高
    ///
    /// - Parameter width: 最大宽度
    /// - Returns: 属性文本的高
    func height(with width: CGFloat) -> CGFloat {
        return ceil(size(with: width, height: CGFloat.greatestFiniteMagnitude).height)
    }
    
    /// 计算属性文本的宽
    ///
    /// - Parameter height: 最大高度
    /// - Returns: 属性文本的宽
    func width(with height: CGFloat) -> CGFloat {
        return ceil(size(with: CGFloat.greatestFiniteMagnitude, height: height).width)
    }
    
    /// 计算属性文本的宽高
    ///
    /// - Parameters:
    ///   - width: 最大宽度
    ///   - height: 最大高度
    /// - Returns: 属性文本的宽高
    private func size(with width: CGFloat, height: CGFloat) -> CGSize {
        guard length > 0 else {
            return .zero
        }
        guard width > 0, height > 0 else {
            return .zero
        }
        let rect = boundingRect(with: CGSize(width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
        return rect.size
    }
    
}
