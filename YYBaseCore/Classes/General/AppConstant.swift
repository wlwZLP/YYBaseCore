//
//  Constants.swift
//  Core
//
//  Created by Chris on 2022/3/11.
//

import Foundation
import Metal

/// 屏幕UI尺寸相关常量
public enum AppSizes {
    
    /// 当前屏幕Bounds
    public static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
    
    /// 当前屏幕宽度
    public static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    /// 当前屏幕高度
    public static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// 状态栏高度
    public static var statusHeight: CGFloat {
        let statusBarManager:UIStatusBarManager = UIApplication.shared.windows.first!.windowScene!.statusBarManager!
        return statusBarManager.statusBarFrame.size.height
    }
    
    /// 导航栏高度
    public static var navigationBarHeight: CGFloat {
        return 44 + statusHeight
    }
    
    /// TabBar高度
    public static var tabBarHeight: CGFloat {
        return 49 + bottomSafeAreaHeight
    }
    
    /// 底部的安全距离
    public static var bottomSafeAreaHeight: CGFloat {
        return UIScreen.isNotch ? 34 : 0
    }
    
}

/// App相关信息常量
public enum AppInfo {
    
    /// App显示名称
    public static let displayName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    
    /// App Bundle Identifier
    public static let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    
    /// App版本号
    public static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    
    /// App build版本号
    public static let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    
}

/// 字体大小常量
public struct AppFont {

    /// 10 特殊仅用于列表标题、和交易界面下的数额提示
    public static let tip: CGFloat = 10
    /// 12 次要字号
    public static let subtitle: CGFloat = 12
    /// 13 特殊仅用于历史订单页，交易价格的字号
    public static let historyTrade: CGFloat = 13
    /// 14 标准字号
    public static let normal: CGFloat = 14
    /// 15 大字号
    public static let big: CGFloat = 15
    /// 16 超大标准字体
    public static let normalBigTitle: CGFloat = 16
    /// 17 导航栏标题字号
    public static let navigationTitle: CGFloat = 17
    /// 18 导航栏标题字号
    public static let navigationBigTitle: CGFloat = 18
    /// 20 超大字号
    public static let superBig: CGFloat = 20
    /// 24 大字号
    public static let specialBig: CGFloat = 24
    /// 30 特殊仅用于验证码输入
    public static let verifyCode: CGFloat = 30
    /// 40 特殊标题
    public static let specialTitle: CGFloat = 40


}
