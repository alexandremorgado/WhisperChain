//
//  Whisper.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import Foundation

struct Whisper: Identifiable, Equatable {
    let wid: String
    let heartedCount: Int
    let repliesCount: Int
    let text: String
    let urlString: String
    let parentID: String
    
    var id: String { wid }
    var url: URL? { URL(string: urlString) }
}

// MARK: - Codable

extension Whisper: Codable {
    enum CodingKeys: String, CodingKey {
        case wid, text
        case heartedCount = "me2"
        case repliesCount = "replies"
        case urlString = "url"
        case parentID = "in_reply_to"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        wid = try container.decode(String.self, forKey: .wid)
        heartedCount = try container.decode(Int.self, forKey: .heartedCount)
        repliesCount = try container.decode(Int.self, forKey: .repliesCount)
        text = try container.decode(String.self, forKey: .text)
        urlString = try container.decode(String.self, forKey: .urlString)
        parentID = try container.decode(String.self, forKey: .parentID)
    }
    
}

struct PopularWhispers: Decodable {
    let popular: [Whisper]
}

struct RepliesWhispers: Decodable {
    let replies: [Whisper]
}

// MARK: - Extensions

extension Whisper: CustomStringConvertible {
    var description: String {
        let textDesc = text.isEmpty ? "[empty]" : "\(text.prefix(12))..."
        return "\(textDesc) | ♥︎ \(heartedCount)"
    }
}

extension Node where Value == Whisper {
    
    var heartsCount: Int {
        value.heartedCount + children.reduce(0) { $0 + $1.value.heartedCount }
    }
    
    var allWhispers: [Whisper] {
        [value] + children.reduce([]) { $0 + [$1.value] }
    }
    
}

// MARK: - Mocks

extension Whisper {
    static var sample1: Whisper {
        Whisper(
            wid: "05d39a745201a1278cf0fa61ee8b48f2811e4c",
            heartedCount: 1,
            repliesCount: 1,
            text: "Nah one gift is enough. Its the thought that matter",
            urlString: "http://cdn-client.whisper.sh/05d39a745201a1278cf0fa61ee8b48f2811e4c.jpg?v=0",
            parentID: "undefined"
        )
    }
    
    static var sample2: Whisper {
        Whisper(
            wid: "05d39a893d4fafae6891cf4bb6930291ba445b",
            heartedCount: 0,
            repliesCount: 0,
            text: "I think the point is wanting to give your kids more than one gift wanting to be able to spoil them because you can see how much they deserve it. One gift might be enough but it’s more exciting w multi",
            urlString: "http://cdn-client.whisper.sh/05d39a893d4fafae6891cf4bb6930291ba445b.jpg?v=0",
            parentID: Whisper.sample1.id
        )
    }
}


