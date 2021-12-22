//
//  Node.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import Foundation

class Node<Value> {
    var value: Value
    var children: [Node]
    
    var childrenCount: Int {
        1 + children.reduce(0) { $0 + $1.childrenCount }
    }
    
    init(_ value: Value) {
        self.value = value
        children = []
    }
    
    init(_ value: Value, children: [Node]) {
        self.value = value
        self.children = children
    }
    
    func add(child: Node) {
        children.append(child)
    }
    
    func add(children: [Node]) {
        self.children.append(contentsOf: children)
    }
    
}

extension Node: CustomStringConvertible {
    
    var description: String {
        "\(value)"
    }
    
    func treeLines(_ nodeIndent: String = "", _ childIndent: String = "") -> [String] {
        return [ nodeIndent + description ] + children.enumerated()
            .map{ ($0 < children.count-1, $1) }
            .flatMap{ $0 ? $1.treeLines("┣╸","┃ ") : $1.treeLines("┗╸","  ") }
            .map{ childIndent + $0.description }
    }
    
    var treeDescription: String {
        treeLines().joined(separator:"\n")
    }
    
}

extension Node: Equatable where Value: Equatable {
    
    static func ==(lhs: Node, rhs: Node) -> Bool {
        lhs.value == rhs.value && lhs.children == rhs.children
    }
    
    func find(_ value: Value) -> Node? {
        if self.value == value {
            return self
        }
        for child in children {
            if let match = child.find(value) {
                return match
            }
        }
        return nil
    }
    
}
