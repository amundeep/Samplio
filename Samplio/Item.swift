//
//  Item.swift
//  Samplio
//
//  Created by Amundeep Singh on 10/7/25.
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
