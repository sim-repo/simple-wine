//
//  Array + Extensions.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 13.03.2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation

extension Array {
    func at(index: Int) -> Array.Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
}

extension Array where Element: Equatable {
    
    @discardableResult mutating func remove(object: Element) -> Bool {
        if let index = index(of: object) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    @discardableResult mutating func remove(where predicate: (Array.Iterator.Element) -> Bool) -> Bool {
        if let index = self.index(where: { (element) -> Bool in
            return predicate(element)
        }) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
}
