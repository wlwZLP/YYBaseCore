//
//  UICollectionViewExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/9.
//

import Foundation

public extension UICollectionView {
    
    /// 从重用池中获取指定类型及索引位置的Cell
    /// 如果没有就新创建
    ///
    /// - Parameters:
    ///   - type: cell的类型
    ///   - indexPath: cell的索引位置
    /// - Returns: type类型的cell实例
    func dequeueCell<Cell: UICollectionViewCell>(for type: Cell.Type, at indexPath: IndexPath) -> Cell {
        return self.dequeueReusableCell(withReuseIdentifier: identifier(for: type), for: indexPath) as! Cell
    }
    
    /// 从重用池中获取指定类型、指定索引位置及指定标识的Cell
    /// 如果没有就新创建
    ///
    /// - Parameters:
    ///   - type: cell的类型
    ///   - identifier: cell的重用标识
    ///   - indexPath: cell的索引位置
    /// - Returns: type类型的cell实例
    func dequeueCell<Cell: UICollectionViewCell>(for type: Cell.Type, withReuseIdentifier identifier: String, at indexPath: IndexPath) -> Cell {
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Cell
    }
    
    /// 从重用池中获取指定类型及索引位置的Header
    /// 如果没有就新创建
    ///
    /// - Parameters:
    ///   - type: Header的类型
    ///   - indexPath: Header的索引位置
    /// - Returns: type类型的Header实例
    func dequeueReusableHeader<View: UICollectionReusableView>(for type: View.Type, at indexPath: IndexPath) -> View {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier(for: type), for: indexPath) as! View
    }
    
    /// 从重用池中获取指定类型及索引位置的Footer
    /// 如果没有就新创建
    ///
    /// - Parameters:
    ///   - type: Footer的类型
    ///   - indexPath: Footer的索引位置
    /// - Returns: type类型的Footer实例
    func dequeueReusableFooter<View: UICollectionReusableView>(for type: View.Type, at indexPath: IndexPath) -> View {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier(for: type), for: indexPath) as! View
    }
    
    /// 注册指定类型的Cell
    ///
    /// - Parameters:
    ///   - class: cell的类型
    func registerCell<Cell: UICollectionViewCell>(for class: Cell.Type) {
        self.register(`class`, forCellWithReuseIdentifier: identifier(for: `class`))
    }

    /// 注册指定类型的Header
    ///
    /// - Parameters:
    ///   - class: Header的类型
    func registerHeader<View: UICollectionReusableView>(for class: View.Type) {
        self.register(`class`, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier(for: `class`))
    }

    /// 注册指定类型的Footer
    ///
    /// - Parameters:
    ///   - class: Footer的类型
    func registerFooter<View: UICollectionReusableView>(for class: View.Type) {
        self.register(`class`, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier(for: `class`))
    }
    
    /// 返回类类型的字符串
    ///
    /// - Parameters:
    ///   - type: 任意类的类型
    private func identifier(for type: AnyClass) -> String {
        return "\(type)".components(separatedBy: ".").last!
    }
    
}


