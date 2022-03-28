//
//  UITableViewExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/10.
//

import Foundation

public extension UITableView {
    
    /// 从重用池中获取指定类型及索引位置的Cell
    /// 如果没有就新创建
    ///
    /// - Parameters:
    ///   - type: cell的类型
    ///   - indexPath: cell的索引位置
    /// - Returns: type类型的cell实例
    func dequeueCell<Cell: UITableViewCell>(for type: Cell.Type, at indexPath: IndexPath) -> Cell {
        return self.dequeueReusableCell(withIdentifier: identifier(for: type), for: indexPath) as! Cell
    }
    
    /// 从重用池中获取指定类型、指定索引位置及指定标识的Cell
    /// 如果没有就新创建
    ///
    /// - Parameters:
    ///   - type: cell的类型
    ///   - identifier: cell的重用标识
    ///   - indexPath: cell的索引位置
    /// - Returns: type类型的cell实例
    func dequeueCell<Cell: UITableViewCell>(for type: Cell.Type, withReuseIdentifier identifier: String, at indexPath: IndexPath) -> Cell {
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
    }
    
    /// 从重用池中获取指定类型及索引位置的 Header / Footer
    /// 如果没有就新创建
    ///
    /// - Parameters:
    ///   - type: Header / Footer 的类型
    /// - Returns: type类型的 Header / Footer 实例
    func dequeueReusableHeaderFooter<View: UITableViewHeaderFooterView>(for type: View.Type) -> View {
        return self.dequeueReusableHeaderFooterView(withIdentifier: identifier(for: type)) as! View
    }
    
    /// 注册指定类型的Cell
    ///
    /// - Parameters:
    ///   - class: cell的类型
    func registerCell<Cell: UITableViewCell>(for class: Cell.Type) {
        self.register(`class`, forCellReuseIdentifier: identifier(for: `class`))
    }

    /// 注册指定类型的 Header / Footer
    ///
    /// - Parameters:
    ///   - class: Header / Footer 的类型
    func registerHeaderFooter<View: UICollectionReusableView>(for class: View.Type) {
        self.register(`class`, forHeaderFooterViewReuseIdentifier: identifier(for: `class`))
    }
    
    /// 返回类类型的字符串
    ///
    /// - Parameters:
    ///   - type: 任意类的类型
    private func identifier(for type: AnyClass) -> String {
        return "\(type)".components(separatedBy: ".").last!
    }
}


