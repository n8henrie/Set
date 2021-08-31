//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Nathan Henrie on 20210310.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for idx in 0..<self.count {
            if self[idx].id == matching.id {
                return idx
            }
        }
        return nil
    }
}
