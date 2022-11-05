//
//  UIWindowExtensions.swift
//  Core
//
//  Created by Chris on 2022/3/10.
//

import Foundation

public extension UIWindow {
    
    /// 当前window上的最上层的控制器
    var topViewController: UIViewController? {
        guard let root = rootViewController else {
            return nil
        }
        return visibleViewController(for: root)
    }
    
    private func visibleViewController(for controller: UIViewController) -> UIViewController {
        var result: UIViewController?
        if let presented = controller.presentedViewController {
            result = presented
        } else if let navigationController = controller as? UINavigationController,
                  let visible = navigationController.visibleViewController {
            result = visible
        } else if let tabBarController = controller as? UITabBarController,
                  let visible = (tabBarController.selectedViewController ??
                                    tabBarController.presentedViewController) {
            result = visible
        }
        if let result = result {
            return visibleViewController(for: result)
        } else {
            return controller
        }
    }
}
