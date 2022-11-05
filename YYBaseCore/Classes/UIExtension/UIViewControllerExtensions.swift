//
//  UIViewControllerExtensions.swift
//  Core
//
//  Created by Chris on 2022/3/10.
//

import Foundation

public extension UIViewController {
    
    /// 点击控制器任意地方可以收起键盘
    func dismissKeyboard() {
        let notification = NotificationCenter.default
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(tapAnywhereDismissKeyboard(gesture:)))
        
        let mainQueue = OperationQueue.main
        notification.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: mainQueue) { [weak self] _ in
            self?.view.addGestureRecognizer(singleTap)
        }
        notification.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: mainQueue) { [weak self] _ in
            self?.view.removeGestureRecognizer(singleTap)
        }
    }
    
    @objc private func tapAnywhereDismissKeyboard(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
