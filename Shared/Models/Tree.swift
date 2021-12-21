//
//  Tree.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import Foundation

struct Node<Value> {
    var value: Value
    var children: [Node]
}
