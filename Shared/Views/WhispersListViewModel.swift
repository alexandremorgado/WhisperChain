//
//  WhispersListViewModel.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import Foundation

class WhispersListViewModel: ObservableObject {
    
    @Published var popularWhispers = [Whisper]()
    @Published var viewStatus = ViewStatus.fetching
    
    func fetchPopularWhispers(limit: Int = 200) { 
        viewStatus = .fetching
        guard let url = URL(string: "http://prod.whisper.sh/whispers/popular?limit=\(limit)") else {
            viewStatus = .error(message: "wrong URL")
            return
        }
        let task = URLSession.shared
            .dataTask(
                with: url,
                completionHandler: { [weak self] data, response, error in
                    guard let responseData = data, error == nil else {
                        DispatchQueue.main.async {
                            self?.viewStatus = .error(message: error?.localizedDescription ?? "error on loading")
                        }
                        return
                    }
                    
                    do {
                        let whispers = try JSONDecoder().decode(PopularWhispers.self, from: responseData)
                        DispatchQueue.main.async {
                            self?.popularWhispers = whispers.popular
                            self?.viewStatus = .loaded
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
}

