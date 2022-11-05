//
//  UIScreenExtensions.swift
//  Core
//
//  Created by Chris on 2022/3/10.
//

import Foundation

public extension UIScreen {
    
    /// 判断是否是刘海屏
    static var isNotch: Bool {
        guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
            return false
        }
        
        if unwrapedWindow.safeAreaInsets.bottom > 0 {
            return true
        }
        
        return false
    }
        
}
