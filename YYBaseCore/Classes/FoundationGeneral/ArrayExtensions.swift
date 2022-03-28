//
//  ArrayExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/8.
//

import Foundation

public extension Array {
    
    /// 在数组的最前面插入元素
    /// - Parameter newElement: 元素
    mutating func insertFront(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    
    /// 交换两个元素位置
    ///
    ///     [1, 2, 3, 4, 5].safeSwap(from: 3, to: 0) -> [4, 2, 3, 1, 5]
    ///
    /// - Parameters:
    ///   - index: 第一个元素位置
    ///   - otherIndex: 第二个元素位置
    mutating func safeSwap(from index: Index, to otherIndex: Index) {
        guard index != otherIndex else { return }
        guard startIndex..<endIndex ~= index else { return }
        guard startIndex..<endIndex ~= otherIndex else { return }
        swapAt(index, otherIndex)
    }
}
