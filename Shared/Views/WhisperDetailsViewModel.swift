//
//  WhisperDetailsViewModel.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import Foundation

class WhisperDetailsViewModel: ObservableObject {
    
    @Published var replies = [Whisper]()
    @Published var viewStatus = ViewStatus.fetching
    
    @Published var mostHeartedChain = [Whisper]()
    
    func fetchWhisperReplies(whisper: Whisper, limit: Int = 200) {
        viewStatus = .fetching
        
        guard whisper.repliesCount > 0 else {
            viewStatus = .empty
            return
        }
        
        guard let url = URL(string: "http://prod.whisper.sh/whispers/replies?limit=\(limit)&wid=\(whisper.wid)") else {
            viewStatus = .error(message: "wrong URL")
            return
        }
        let session = URLSession.shared
        
        let task = session
            .dataTask(
                with: url,
                completionHandler: { [weak self] data, response, error in
                    guard let responseData = data, error == nil else {
                        self?.viewStatus = .error(message: error?.localizedDescription ?? "error on loading")
                        return
                    }
                    
                    do {
                        let whispers = try JSONDecoder().decode(RepliesWhispers.self, from: responseData)
                        DispatchQueue.main.async {
                            self?.replies = whispers.replies
                            self?.viewStatus = whispers.replies.count > 0 ? .loaded : .empty
                            self?.setMostHeartedChain()
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self?.viewStatus = .error(message: error.localizedDescription)
                        }
                    }
                }
            )
        
        task.resume()
    }
    
    func setMostHeartedChain() {
        
    }
}


