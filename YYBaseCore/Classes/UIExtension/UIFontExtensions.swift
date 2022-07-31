//
//  UIFontExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/9.
//

import Foundation

// MARK: UIFont
public extension UIFont {
    
    /// 从指定字体类型初始化字体
    /// - Parameters:
    ///   - name: 字体名称
    ///   - size: 字体大小
    /// - Returns: 字体
    static func font(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
        
    /// 从 Icon Font 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func iconFont(_ size: CGFloat) -> UIFont {
        // 注册自定义字体，生命周期内，只执行一次
        DispatchQueue.once(token: "bm.font.iconfont.token") {
            registerIconFont()
        }
        return UIFont.font(name: BMFont.iconfont.rawValue, size: size)
    }
    
    /// 从 pingFangSCMedium 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func pingFangSCMedium(size: CGFloat) -> UIFont {
        return UIFont.font(name: BMFont.pingFangSCMedium.rawValue, size: size)
    }
    
    /// 从 pingFangSCMedium 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func pingFangSCRegular(size: CGFloat) -> UIFont {
        return UIFont.font(name: BMFont.pingFangSCRegular.rawValue, size: size)
    }
    
    /// 从 pingFangSCSemiBold 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func pingFangSCSemiBold(size: CGFloat) -> UIFont {
        return UIFont.font(name: BMFont.pingFangSCSemibold.rawValue, size: size)
    }
    
    /// 从 DINRegular 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func dinRegular(size: CGFloat) -> UIFont {
        // 注册自定义字体，生命周期内，只执行一次
        DispatchQueue.once(token: "bm.font.dinRegular.token") {
            registerDINRegularFont()
        }
        return UIFont.font(name: BMFont.dinRegular.rawValue, size: size)
    }
    
    /// 从 DINBold 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func dinBold(size: CGFloat) -> UIFont {
        // 注册自定义字体，生命周期内，只执行一次
        DispatchQueue.once(token: "bm.font.dinBold.token") {
            registerDINBoldFont()
        }
        return UIFont.font(name: BMFont.dinBold.rawValue, size: size)
    }
    
    /// 从 DINMedium 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func dinMedium(size: CGFloat) -> UIFont {
        // 注册自定义字体，生命周期内，只执行一次
        DispatchQueue.once(token: "bm.font.dinMedium.token") {
            registerDINMediumFont()
        }
        return UIFont.font(name: BMFont.dinMedium.rawValue, size: size)
    }
    
    /// 从 sfProTextMedium 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func sfProTextMedium(size: CGFloat) -> UIFont {
        // 注册自定义字体，生命周期内，只执行一次
        DispatchQueue.once(token: "bm.font.sfProTextMedium.token") {
            registerSFProTextMediumFont()
        }
        return UIFont.font(name: BMFont.sfProTextMedium.rawValue, size: size)
    }
    
    /// 从 sfProTextSemibold 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func sfProTextSemibold(size: CGFloat) -> UIFont {
        // 注册自定义字体，生命周期内，只执行一次
        DispatchQueue.once(token: "bm.font.sfProTextSemibold.token") {
            registerSFProTextSemiboldFont()
        }
        return UIFont.font(name: BMFont.sfProTextSemibold.rawValue, size: size)
    }
    
    /// 从 arialBoldMT 初始化字体
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func arialBoldMT(size: CGFloat) -> UIFont {
        return UIFont.font(name: BMFont.arialBoldMT.rawValue, size: size)
    }
    
}

// MARK: 注册自定义字体
extension UIFont {
    
    /// 注册 IconFont 字体
    private static func registerIconFont() {
        registerFont(bundleName: "BMIconFont", resourceName: "iconfont", resourceSuffix: "ttf")
    }
    
    /// 注册 DIN-Bold 字体
    private static func registerDINBoldFont() {
        registerFont(bundleName: "BMFont", resourceName: "DIN-Bold", resourceSuffix: ".otf")
    }
    
    /// 注册 DIN-Medium 字体
    private static func registerDINMediumFont() {
        registerFont(bundleName: "BMFont", resourceName: "DIN-Medium", resourceSuffix: ".otf")
    }
    
    /// 注册 DIN-Regular 字体
    private static func registerDINRegularFont() {
        registerFont(bundleName: "BMFont", resourceName: "DIN-Regular", resourceSuffix: ".otf")
    }
    
    /// 注册 SF-Pro-Text-Medium 字体
    private static func registerSFProTextMediumFont() {
        registerFont(bundleName: "BMFont", resourceName: "SF-Pro-Text-Medium", resourceSuffix: ".otf")
    }
    
    /// 注册 SF-Pro-Text-Semibold 字体
    private static func registerSFProTextSemiboldFont() {
        registerFont(bundleName: "BMFont", resourceName: "SF-Pro-Text-Semibold", resourceSuffix: ".otf")
    }
    
    /// 通过指定的bundle及资源文件注册自定义字体
    /// - Parameters:
    ///   - bundleName: 字体资源文件所在的bundle名称
    ///   - resourceName: 字体资源文件名称
    ///   - resourceSuffix: 字体资源文件后缀
    private static func registerFont(bundleName: String, resourceName: String, resourceSuffix: String) {
        guard let bundle = Bundle.bundle(BMBundle.self)?.resourcesBundle(with: bundleName) else {
            return
        }
                
        guard let fontURL = bundle.url(forResource: resourceName, withExtension: resourceSuffix) else {
            return
        }
        
        UIFont.register(from: fontURL)
    }
    
    /// 通过指定的资源文件URL注册自定义字体
    /// - Parameter url: 资源文件URL
    static func register(from url: URL) {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            return
        }
        guard let font = CGFont(fontDataProvider) else {
            return
        }
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            return
        }
    }
    
}

// MARK: 用于在分类中获取Bundle

fileprivate class BMBundle { }

// MARK: 自定义字体

public enum BMFont: String {
    
    /// PingFangSC font
    case pingFangSCRegular = "PingFangSC-Regular"
    case pingFangSCSemibold = "PingFangSC-Semibold"
    case pingFangSCMedium = "PingFangSC-Medium"
    
    /// DIN font
    case dinRegular = "DIN-Regular"
    case dinBold = "DIN-Bold"
    case dinMedium = "DIN-Medium"
    
    /// SFProText font
    case sfProTextMedium = "SFProText-Medium"
    case sfProTextSemibold = "SFProText-Semibold"
    
    /// Arial-BoldMT font
    case arialBoldMT = "Arial-BoldMT"
    
    /// iconfont
    case iconfont = "iconfont"
}

// MARK: Icon Font

public enum BMIconFontMetadata: String {
    
    case account_icon_Alert = "\u{e669}"
    case account_icon_Payfees = "\u{e66a}"
    case account_icon_contact = "\u{e667}"
    case account_icon_deposit = "\u{e671}"
    case account_icon_faceid = "\u{e6c6}"
    case account_icon_fingerprint = "\u{e6c7}"
    case account_icon_invitefriends = "\u{e66f}"
    case account_icon_message = "\u{e668}"
    case account_icon_moon = "\u{e672}"
    case account_icon_security = "\u{e66b}"
    case account_icon_setting = "\u{e66c}"
    case account_icon_sun = "\u{e673}"
    case account_icon_tradehistory = "\u{e66e}"
    case account_icon_verification = "\u{e66d}"
    case account_icon_withdraw = "\u{e670}"
    
    case app_icon_announcement = "\u{e674}"
    case app_icon_arrow_down = "\u{e696}"
    case app_icon_arrow_left = "\u{e654}"
    case app_icon_arrow_right = "\u{e697}"
    case app_icon_arrow_up = "\u{e698}"
    case app_icon_check = "\u{e6c5}"
    case app_icon_checkbox_off = "\u{e69a}"
    case app_icon_checkbox_on = "\u{e69b}"
    case app_icon_close = "\u{e657}"
    case app_icon_down = "\u{e655}"
    case app_icon_download = "\u{e719}"
    case app_icon_download_arrow = "\u{e71b}"
    case app_icon_download_cloud = "\u{e71a}"
    case app_icon_failed = "\u{e6f1}"
    case app_icon_head = "\u{e6a8}"
    case app_icon_home = "\u{e658}"
    case app_icon_next = "\u{e656}"
    case app_icon_prompt = "\u{e65b}"
    case app_icon_search = "\u{e65a}"
    case app_icon_success = "\u{e6f0}"
    case app_icon_up = "\u{e702}"
    case app_icon_user = "\u{e659}"
    case app_icon_warning = "\u{e708}"
    case app_pic_loading = "\u{e6ca}"
    case app_pic_network = "\u{e6c9}"
    case app_pic_nodata = "\u{e6c8}"
    
    case assets_icon_address = "\u{e6e0}"
    case assets_icon_currency_default = "\u{e6b9}"
    case assets_icon_doubt = "\u{e6e7}"
    case assets_icon_eye = "\u{e65f}"
    case assets_icon_eye_off = "\u{e65c}"
    case assets_icon_scan = "\u{e65d}"
    case assets_icon_trash = "\u{e65e}"
    
    case camera_icon_album = "\u{e6bd}"
    case camera_icon_flash = "\u{e6c0}"
    case camera_icon_flash_auto = "\u{e6c1}"
    case camera_icon_flash_close = "\u{e6bf}"
    case camera_icon_photo = "\u{e6c4}"
    case camera_icon_reverse = "\u{e6be}"
    
    case change = "\u{e603}"
    case compare = "\u{e608}"
    
    case contact_icon_customerservice = "\u{e6e1}"
    case contact_img_email = "\u{e712}"
    case contact_img_facebook = "\u{e711}"
    case contact_img_moments = "\u{e715}"
    case contact_img_more = "\u{e718}"
    case contact_img_saveimg = "\u{e714}"
    case contact_img_telegram = "\u{e713}"
    case contact_img_twitter = "\u{e710}"
    case contact_img_wechat = "\u{e716}"
    case contact_img_weibo = "\u{e717}"
    case contracthei = "\u{e607}"
    case contracthui = "\u{e606}"
    
    case dauser = "\u{e611}"
    case dian = "\u{e612}"
    case diandian = "\u{e613}"
    case exchange_hei = "\u{e60d}"
    case home_hei = "\u{e609}"
    case huan = "\u{e610}"
    
    case icon_logo = "\u{e6e8}"
    case icon_trade_cny = "\u{e6dd}"
    case icon_trade_help = "\u{e6df}"
    case icon_trade_usd = "\u{e6de}"
    
    case kyc_icon_add = "\u{e69e}"
    case kyc_icon_alert = "\u{e695}"
    case kyc_icon_circle = "\u{e6a6}"
    case kyc_icon_failed = "\u{e69d}"
    case kyc_icon_security = "\u{e694}"
    case kyc_icon_success = "\u{e69f}"
    case kyc_icon_v1 = "\u{e6ba}"
    case kyc_icon_v2 = "\u{e6bb}"
    case kyc_icon_v3 = "\u{e6bc}"
    case kyc_pic_google_failed = "\u{e6d2}"
    case kyc_pic_google_success = "\u{e6ce}"
    case kyc_pic_message_failed = "\u{e6d0}"
    case kyc_pic_message_success = "\u{e6cb}"
    case kyc_pic_mobiel_failed = "\u{e6cf}"
    case kyc_pic_mobiel_success = "\u{e6cc}"
    case kyc_pic_verification_failed = "\u{e6d1}"
    case kyc_pic_verification_success = "\u{e6cd}"
    
    case menu = "\u{e60c}"
    case purse = "\u{e60a}"
    case scan_icon_angle = "\u{e6dc}"
    
    case security_icon_authorization_warning = "\u{e70f}"
    case security_icon_email_success = "\u{e70a}"
    case security_icon_google_success = "\u{e70c}"
    case security_icon_mobile_success = "\u{e70b}"
    case security_icon_verification_failed = "\u{e70e}"
    case security_icon_verification_success = "\u{e70d}"
    
    case success = "\u{e614}"
    case success_filling = "\u{e615}"
    case tab_icon_balance_selected = "\u{e6d8}"
    case tab_icon_balance_unselected = "\u{e6d7}"
    case tab_icon_home_selected = "\u{e6d4}"
    case tab_icon_home_unselected = "\u{e6d3}"
    case tab_icon_market_selected = "\u{e6d6}"
    case tab_icon_market_unselected = "\u{e6d5}"
    case tab_icon_trade_selected = "\u{e6da}"
    case tab_icon_trade_unselected = "\u{e6d9}"
    
    case trade_icon_favorite = "\u{e660}"
    case trade_icon_favorite_selected = "\u{e69c}"
    case trade_icon_filter = "\u{e662}"
    case trade_icon_kline = "\u{e6db}"
    case trade_icon_maximize = "\u{e664}"
    case trade_icon_minimize = "\u{e661}"
    case trade_icon_minus = "\u{e663}"
    case trade_icon_plus = "\u{e665}"
    case trade_icon_share = "\u{e666}"
    case trade_icon_triangle = "\u{e6a7}"
    case user_hei = "\u{e60b}"
    case user_hui = "\u{e60e}"
    case wallet_hei = "\u{e60f}"
}

// MARK: 字号规范

public struct Font {
    public struct Size {
        /// 40 特殊标题
        public static let specialTitle: CGFloat = 40
        /// 30 特殊仅用于验证码输入
        public static let verifyCode: CGFloat = 30
        /// 24 大字号
        public static let specialBig: CGFloat = 24
        /// 20 超大字号
        public static let superBig: CGFloat = 20
        /// 17 导航栏标题字号
        public static let navigationTitle: CGFloat = 17
        /// 16 超大标准字体
        public static let normalBigTitle: CGFloat = 16
        /// 15 大字号
        public static let big: CGFloat = 15
        /// 14 标准字号
        public static let normal: CGFloat = 14
        /// 13 特殊仅用于历史订单页，交易价格的字号
        public static let historyTrade: CGFloat = 13
        /// 12 次要字号
        public static let subtitle: CGFloat = 12
        /// 10 特殊仅用于列表标题、和交易界面下的数额提示
        public static let tip: CGFloat = 10
    }
}
