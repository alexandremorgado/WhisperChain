//
//  WhispersListView.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import SwiftUI

struct WhispersListView: View {
    
    @StateObject var viewModel = WhispersListViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.viewStatus {
                case .fetching:
                    ProgressView("Loading...")
                case .loaded:
                    whispersList
                case .empty:
                    Text("No whisper loaded")
                case .error(let errorMessage):
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Popular whispers")
        }
        .task {
            viewModel.fetchPopularWhispers(limit: 20)
        }
    }
    
    var whispersList: some View {
        List(viewModel.popularWhispers) { whisper in
            NavigationLink(
                destination: { WhisperDetailsView(whisper: whisper) },
                label: {
                    WhisperItemView(whisper)
                        .padding(.vertical)
                }
            )
            .buttonStyle(.plain)
        }
        .listStyle(.grouped)
    }
    
}


struct WhispersListView_Previews: PreviewProvider {
    
    static var previews: some View {
        WhispersListView()
    }
}
