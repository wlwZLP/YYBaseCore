//
//  Encryptor.swift
//  Core
//
//  Created by Chris on 2022/3/15.
//

import Foundation
import CryptoSwift
import SwiftyRSA

/// 加密组件服务
/// 目前提供：
///  AES（不加盐）加密、解密
///  RSA（字符串ket）加密、解密
///  RSA（der证书）加密、解密
///  RSA（pem证书）加密、解密
public protocol Encryptor { }

// MARK: AES 加密/解密 默认实现

public extension Encryptor {
    
    /// AES（不加盐）加密
    /// 如果加密失败，则返回原数据
    ///
    /// - Parameters:
    ///   - text: 要加密的数据
    ///   - key: AES 密钥
    /// - Returns: 加密后的数据
    static func aesEncrypt(_ text: String, key: String) -> String {
        guard !text.isEmpty else {
            return text
        }
        
        guard !key.isEmpty else {
            return text
        }
        
        do {
            let encryptAES = try AES(key: Array(key.utf8), blockMode: ECB(), padding: .pkcs7).encrypt(text.bytes)
            let encryptData = Data(encryptAES)
            return encryptData.base64EncodedString()
        } catch {
            return text
        }
    }
    
    /// AES 解密
    /// 如果解密失败，则返回加密数据
    /// 
    /// - Parameters:
    ///   - text: 被加密的数据
    ///   - key: AES 密钥
    /// - Returns: 解密后的数据
    static func aesDecrypt(_ text: String, key: String) -> String {
        guard !text.isEmpty else {
            return text
        }
        
        guard let encryptData = Data(base64Encoded: text, options: .ignoreUnknownCharacters) else {
            return text
        }
        
        guard !key.isEmpty else {
            return text
        }
        
        do {
            let decryptAES = try AES(key: Array(key.utf8), blockMode: ECB(), padding: .pkcs7).decrypt(encryptData.bytes)
            return String(bytes: Data(decryptAES).bytes, encoding: .utf8) ?? text
        } catch {
            return text
        }
    }
    
}

// MARK: RSA 加密/解密 默认实现

public extension Encryptor {
    
    /// 通过指定的key加密数据
    /// - Parameters:
    ///   - text: 需要加密的数据
    ///   - stringKey: 加密使用的 key
    ///   - secPadding: 加密模式（默认为 PKCS1 ）
    /// - Returns: 加密后的 base64 字符串
    static func rsaStringEncrypt(with text: String, stringKey: String, secPadding: SecPadding = .PKCS1) -> String {
        // 对加密key先进行 base64 编码，如果失败，直接返回原数据
        guard let base64StringKey = stringKey.data(using: .utf8)?.base64EncodedString(options: .init(rawValue: 0)) else {
            return text
        }
        
        do {
            let publicKey = try PublicKey(base64Encoded: base64StringKey)
            return rsaEncrypt(with: text, publicKey: publicKey, secPadding: secPadding)
        } catch {
            return text
        }
    }
    
    /// 通过指定的key解密数据
    /// - Parameters:
    ///   - text: 被加密的数据
    ///   - stringKey: 解密使用的 key
    ///   - secPadding: 加密模式（默认为 PKCS1 ）
    /// - Returns: 解密后的 utf8 字符串
    static func rsaStringDecrypt(with text: String, stringKey: String, secPadding: SecPadding = .PKCS1) -> String {
        // 对加密key先进行 base64 编码，如果失败，直接返回原数据
        guard let base64StringKey = stringKey.data(using: .utf8)?.base64EncodedString(options: .init(rawValue: 0)) else {
            return text
        }
        
        do {
            let privateKey = try PrivateKey(base64Encoded: base64StringKey)
            return rsaDecrypt(with: text, privateKey: privateKey, secPadding: secPadding)
        } catch {
            return text
        }
    }
    
    /// 通过指定的 der 文件加密数据
    /// - Parameters:
    ///   - text: 需要加密的数据
    ///   - derName: der 文件的名称
    ///   - bundle: der 文件所在的 bundle
    ///   - secPadding: 加密模式（默认为 PKCS1 ）
    /// - Returns: 加密后的 base64 字符串
    static func rsaDerEncrypt(with text: String, derName: String, in bundle: Bundle, secPadding: SecPadding = .PKCS1) -> String {
        do {
            let publicKey = try PublicKey(derNamed: derName, in: bundle)
            return rsaEncrypt(with: text, publicKey: publicKey, secPadding: secPadding)
        } catch {
            return text
        }
    }
    
    /// 通过指定的 der 文件解密数据
    /// - Parameters:
    ///   - text: 被加密的数据
    ///   - derName: der 文件的名称
    ///   - bundle: der 文件所在的 bundle
    ///   - secPadding: 加密模式（默认为 PKCS1 ）
    /// - Returns: 解密后的 utf8 字符串
    static func rsaDerDecrypt(with text: String, derName: String, in bundle: Bundle, secPadding: SecPadding = .PKCS1) -> String {
        do {
            let privateKey = try PrivateKey(derNamed: derName, in: bundle)
            return rsaDecrypt(with: text, privateKey: privateKey, secPadding: secPadding)
        } catch {
            return text
        }
    }
    
    /// 通过指定的 pem 文件加密
    /// - Parameters:
    ///   - text: 需要加密的数据
    ///   - pemName: pem 文件的名称
    ///   - bundle: pem 文件所在的 bundle
    ///   - secPadding: 加密模式（默认为 PKCS1 ）
    /// - Returns: 加密后的 base64 字符串
    static func rsaPemEncrypt(with text: String, pemName: String, in bundle: Bundle, secPadding: SecPadding = .PKCS1) -> String {
        do {
            let publicKey = try PublicKey(pemNamed: pemName, in: bundle)
            return rsaEncrypt(with: text, publicKey: publicKey, secPadding: secPadding)
        } catch {
            return text
        }
    }
    
    /// 通过指定的 pem 文件解密
    /// - Parameters:
    ///   - text: 被加密的数据
    ///   - pemName: pem 文件的名称
    ///   - bundle: pem 文件所在的 bundle
    ///   - secPadding: 加密模式（默认为 PKCS1 ）
    /// - Returns: 解密后的 utf8 字符串
    static func rsaPemDecrypt(with text: String, pemName: String, in bundle: Bundle, secPadding: SecPadding = .PKCS1) -> String {
        do {
            let privateKey = try PrivateKey(pemNamed: pemName, in: bundle)
            return rsaDecrypt(with: text, privateKey: privateKey, secPadding: secPadding)
        } catch {
            return text
        }
    }
    
    /// RSA 加密
    /// - Parameters:
    ///   - text: 需要加密的数据
    ///   - publicKey: 公钥实例
    ///   - secPadding: 加密模式
    /// - Returns: 加密后的 base64 字符串
    private static func rsaEncrypt(with text: String, publicKey: PublicKey, secPadding: SecPadding) -> String {
        do {
            let message = try ClearMessage(string: text, using: .utf8)
            let encryptString = try message.encrypted(with: publicKey, padding: secPadding)
            
            return encryptString.base64String
        } catch {
            return text
        }
    }
    
    /// RSA 解密
    /// - Parameters:
    ///   - text: 被加密的数据
    ///   - privateKey: 私钥实例
    ///   - secPadding: 加密模式
    /// - Returns: 解密后的 utf8 字符串
    private static func rsaDecrypt(with text: String, privateKey: PrivateKey, secPadding: SecPadding) -> String {
        do {
            let message = try EncryptedMessage(base64Encoded: text)
            let decryptString = try message.decrypted(with: privateKey, padding: secPadding)
            let utf8String = try decryptString.string(encoding: .utf8)
            
            return utf8String
        } catch {
            return text
        }
    }
    
}

// MARK: AES 加密

extension String: Encryptor {
    
    /// AES（不加盐）加密
    /// 如果加密失败，则返回字符串本身
    ///
    /// - Parameter key: AES 密钥
    /// - Returns: 加密后的数据
    public func aesEncrypt(key: String) -> String {
        return Self.aesEncrypt(self, key: key)
    }
    
    /// AES 解密
    /// 如果解密失败，则返回加密字符串本身
    ///
    /// - Parameter key: AES 密钥
    /// - Returns: 解密后的数据
    public func aesDecrypt(key: String) -> String {
        return Self.aesDecrypt(self, key: key)
    }
    
}

// MARK: 摘要算法 加密

extension String {
    
    /// MD5 加密后的字符串
    public var md5: String {
        return self.md5()
    }
    
    /// SHA-1 加密后的字符串
    public var sha1: String {
        return self.sha1()
    }
    
    /// SHA-224 加密后的字符串
    public var sha224: String {
        return self.sha224()
    }
    
    /// SHA-256 加密后的字符串
    public var sha256: String {
        return self.sha256()
    }
    
    /// SHA-384 加密后的字符串
    public var sha384: String {
        return self.sha384()
    }
    
    /// SHA-512 加密后的字符串
    public var sha512: String {
        return self.sha512()
    }
    
}
