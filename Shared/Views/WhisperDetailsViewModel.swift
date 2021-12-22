//
//  WhisperDetailsViewModel.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import Foundation

enum WhisperError: Error {
    case errorOnLoading
    case couldNotFindNode
}

class WhisperDetailsViewModel: ObservableObject {
    
    @Published var mostHeartedChain = [Whisper]()
    @Published var repliesViewStatus = ViewStatus.fetching
    
    var whisperTree: Node<Whisper>?
    
    func setReplies(for rootWhisper: Whisper, limit: Int = 200) async throws {
        let firstNode = Node(rootWhisper)
        whisperTree = firstNode
        guard rootWhisper.repliesCount > 0 else { repliesViewStatus = .empty; return }
        repliesViewStatus = .fetching
        try await loadReplies(for: rootWhisper, inNode: firstNode)
        setMostHeartedChain()
    }
    
    func loadReplies(for whisper: Whisper, inNode node: Node<Whisper>) async throws {
        let replies = try await fetchWhisperReplies(whisper: whisper)
        for childReply in replies  {
            let newNode = Node(childReply)
            node.add(child: newNode)
            if childReply.repliesCount > 0 {
                try await loadReplies(for: childReply, inNode: newNode)
            }
        }
    }
    
    func fetchWhisperReplies(whisper: Whisper, limit: Int = 200) async throws -> [Whisper] {
        guard let url = URL(string: "http://prod.whisper.sh/whispers/replies?limit=\(limit)&wid=\(whisper.wid)") else {
            throw WhisperError.errorOnLoading
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let whispers = try JSONDecoder().decode(RepliesWhispers.self, from: data)
            return whispers.replies
        } catch {
            throw error
        }
    }
    
    func setMostHeartedChain() {
        guard let tree = whisperTree,
            let heartedSubtree = tree.children.sorted(by: { $0.heartsCount > $1.heartsCount } ).first else {
            return
        }
        #if DEBUG
        print("Full tree: \n\(tree.treeDescription)\n\n")
        print("Most hearted subtree: \n\(heartedSubtree.treeDescription)")
        #endif
        DispatchQueue.main.async {
            self.mostHeartedChain = heartedSubtree.allWhispers
            self.repliesViewStatus = heartedSubtree.allWhispers.count > 0 ? .loaded : .empty
        }
    }
    
}
