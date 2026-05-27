//
//  Item.swift
//  mirrorkit
//
//  Created by 王干 on 2026/5/27.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
