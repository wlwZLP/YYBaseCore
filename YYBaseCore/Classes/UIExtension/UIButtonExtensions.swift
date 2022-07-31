//
//  UIButtonExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/9.
//

import Foundation


public extension UIButton {
    
    enum BMButtonImagePosition {
        /// 图片在上，文字在下，整体居中
        case top
        /// 图片在左，文字在右，整体居中
        case left
        /// 图片在下，文字在上，整体居中
        case bottom
        /// 图片在右，文字在左，整体居中
        case right
    }
    
    /// 设置Button内容的排版位置
    /// - Parameters:
    ///   - position: 图片的位置 ( 上, 左, 下, 右 )
    ///   - spacing: 图片和文字之间的间距
    func contentPosition(at position: BMButtonImagePosition, spacing: CGFloat) {
        guard let imageRect = self.imageView?.frame,
              let titleRect = self.titleLabel?.frame
        else {
            return
        }
        
        let buttonWidth = self.frame.size.width
        let buttonHeight = self.frame.size.height
        let totalHeight = titleRect.size.height + spacing + imageRect.size.height
        
        switch position {
        case .top:
            self.titleEdgeInsets = UIEdgeInsets(top: ((buttonHeight - totalHeight) / 2 + imageRect.size.height + spacing - titleRect.origin.y), left: (buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2, bottom: -((buttonHeight - totalHeight) / 2 + imageRect.size.height + spacing - titleRect.origin.y), right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: ((buttonHeight - totalHeight) / 2 - imageRect.origin.y), left: (buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), bottom: -((buttonHeight - totalHeight) / 2 - imageRect.origin.y), right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
        case .left:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: spacing / 2, bottom: 0, right: -spacing / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing / 2, bottom: 0, right: spacing / 2)
        case .bottom:
            self.titleEdgeInsets = UIEdgeInsets(top: ((buttonHeight - totalHeight) / 2 - titleRect.origin.y), left: (buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2, bottom: -((buttonHeight - totalHeight) / 2 - titleRect.origin.y), right: -(buttonWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (buttonWidth - titleRect.size.width) / 2)
            self.imageEdgeInsets = UIEdgeInsets(top: ((buttonHeight - totalHeight) / 2 + titleRect.size.height + spacing - imageRect.origin.y), left: (buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2), bottom: -((buttonHeight - totalHeight) / 2 + titleRect.size.height + spacing - imageRect.origin.y), right: -(buttonWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
        case .right:
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageRect.size.width + spacing / 2), bottom: 0, right: (imageRect.size.width + spacing / 2))
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: (titleRect.size.width + spacing / 2), bottom: 0, right: -(titleRect.size.width +  spacing / 2))
        }
    }
   
}
