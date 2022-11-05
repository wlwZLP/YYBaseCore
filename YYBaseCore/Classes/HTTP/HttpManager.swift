//
//  HttpManager.swift
//  Core
//
//  Created by Chris on 2021/9/29.
//

import Foundation
import Alamofire

public class HttpManager {
    /// 单例
    public static let shared = HttpManager()
    /// 请求成功状态码
    /// 默认 200, 具体业务值可在子类的 Request 实例中, 在 setHttpsConfig 中设置
    public var successCode: Int = 200
    /// 请求失败通用状态码
    /// 默认 0, 具体业务值可在子类的 Request 实例中, 在 setHttpsConfig 中设置
    public var failureCode: Int = 0
    /// 请求超时时间
    /// 默认 20, 具体业务值可在子类的 Request 实例中, 在 setHttpsConfig 中设置
    public var requestTimeout: TimeInterval = 20
    /// 响应拦截器集合
    public var responseInterceptors: [ResponseInterceptor] = []
    
    /// Get请求接口数据
    /// - Parameters:
    ///   - request: 请求实例 ( 必须初始化 )
    ///   - success: 请求成功回调 ( HTTP状态200, 且业务code为成功 )
    ///   - failure: 请求失败回调
    public func get(with request: BaseRequest, success: ((Response<Any>) -> Void)?, failure:((Response<Any>) -> Void)?) {
        self.request(httpMethod: .get, request: request, success: success, failure: failure)
    }
    
    /// Post请求接口数据
    /// - Parameters:
    ///   - request: 请求实例 ( 必须初始化 )
    ///   - success: 请求成功回调 ( HTTP状态200, 且业务code为成功 )
    ///   - failure: 请求失败回调
    public func post(with request: BaseRequest, success: ((Response<Any>) -> Void)?, failure:((Response<Any>) -> Void)?) {
        self.request(httpMethod: .post, request: request, success: success, failure: failure)
    }
    
    /// Put请求接口数据
    /// - Parameters:
    ///   - request: 请求实例 ( 必须初始化 )
    ///   - success: 请求成功回调 ( HTTP状态200, 且业务code为成功 )
    ///   - failure: 请求失败回调
    public func put(with request: BaseRequest, success: ((Response<Any>) -> Void)?, failure:((Response<Any>) -> Void)?) {
        self.request(httpMethod: .put, request: request, success: success, failure: failure)
    }
    
    /// Delete请求接口数据
    /// - Parameters:
    ///   - request: 请求实例 ( 必须初始化 )
    ///   - success: 请求成功回调 ( HTTP状态200, 且业务code为成功 )
    ///   - failure: 请求失败回调
    public func delete(with request: BaseRequest, success: ((Response<Any>) -> Void)?, failure:((Response<Any>) -> Void)?) {
        self.request(httpMethod: .delete, request: request, success: success, failure: failure)
    }
    
    fileprivate func request(httpMethod: HTTPMethod = .post, request: BaseRequest, success: ((Any) -> Void)?, failure:((Response<Any>) -> Void)?) {
        // 调用请求配置
        request.setHttpsConfig()
        // 如果url不正确, 则直接返回自定义失败
        guard (request.baseUrl?.appending(request.path!)) != nil else {
            let response = Response<Any>.responseUrlFailure()
            if let failure = failure {
                failure(response)
            }
            return
        }


    }
    
    fileprivate func request(httpMethod: HTTPMethod, request: BaseRequest, success: ((Response<Any>) -> Void)?, failure:((Response<Any>) -> Void)?) {
        self.request(httpMethod: httpMethod, request: request, success: {
            [weak self] data in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.parsingData(request: request, response: data, success: success, failure: failure)
        }, failure: failure)
    }
    
    private func parsingData(request: BaseRequest, response data: Any?, success: ((Response<Any>) -> Void)?, failure:((Response<Any>) -> Void)?) {
        guard data is [String: Any] else {
            if let failure = failure {
                failure(Response<Any>.responseParsingFailure())
            }
            return
        }
        

    }
    
}

open class BaseRequest {
    
    public init() { }
    /// 请求域名
    open var baseUrl: String?
    /// 请求地址短链接
    open var path: String?
    /// 请求参数
    open var parameters: [String: Any]?
    /// 自定义部分的请求头
    open var headers: [String: String]?
    /// 设置请求配置
    /// 该方法会在发送请求前自动调用, 子类按需自定义实现即可, 无需手动调用
    open func setHttpsConfig() {
        
    }
}

public class Response<T> {
    
    public required init() { }
    
    /// Http返回的状态码
    public var code: Int = 0
    /// Http返回的提示信息
    public var message: String?
    /// Http返回的业务原始数据
    public var data: Any?
    /// 根据Http返回的业务原始数据data, 内部转化为model
    public var result: T?
    /// 根据Http返回的业务原始数据data, 内部转化为model的集合
    public var results: [T]?
    
    /// 请求失败时, 返回的错误信息
    public var error: Error?
    
    /// 判断Http请求返回的状态是否为成功
    /// true - 成功, false - 失败
    public var isSucc: Bool {
        return code == HttpManager.shared.successCode
    }
}


public extension Response {
    /// Http 请求错误时 ( http错误 ) 快速初始化
    /// - Parameters:
    ///   - code: http状态码
    ///   - message: 错误描述
    ///   - error: http错误信息
    /// - Returns: response实例
    static func responseHttpFailure(code: Int, message: String?, error: Error?) -> Self {
        let response = Response()
        response.code = code
        response.message = message
        response.error = error
        return response as! Self
    }
    
    /// url 错误, 快速初始化
    static func responseUrlFailure() -> Self {
        let response = Response()
        response.code = -1
        response.message = "请求url错误"
        return response as! Self
    }
    
    /// 解析请求返回的数据失败, 快速初始化
    static func responseParsingFailure() -> Self {
        let response = Response()
        response.code = -2
        response.message = "响应数据解析失败"
        return response as! Self
    }
    
    /// 请求超时失败, 快速初始化
    static func responseTimeoutFailure() -> Self {
        let response = Response()
        response.code = -3
        response.message = "接口请求超时\n请检查网络设置"
        return response as! Self
    }
    
    /// 无网络连接请求失败, 快速初始化
    static func responseNoConnectFailure() -> Self {
        let response = Response()
        response.code = -4
        response.message = "无网络连接\n请检查网络设置"
        return response as! Self
    }
    
    /// 网络连接丢失请求失败, 快速初始化
    static func responseConnectLostFailure() -> Self {
        let response = Response()
        response.code = -5
        response.message = "网络连接丢失\n请检查网络设置"
        return response as! Self
    }
}



// MARK: Interceptor
public protocol ResponseInterceptor {
    
    /// 响应拦截器
    /// - Parameters:
    ///   - request: 请求实例
    ///   - response: 响应实例
    /// - Returns: 是否拦截
    func interceptor(request: BaseRequest, response: Response<Any>) -> Bool
}

public extension ResponseInterceptor {
    
    /// 响应拦截器
    /// - Parameters:
    ///   - request: 请求实例
    ///   - response: 响应实例
    /// - Returns: 是否拦截
    func interceptor(request: BaseRequest, response: Response<Any>) -> Bool {
        return false
    }
}
