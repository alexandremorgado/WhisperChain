//
//  ViewStatus.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import Foundation

enum ViewStatus: Equatable {
    case fetching
    case loaded
    case empty
    case error(message: String)
}
