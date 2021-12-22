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
        #if os(macOS)
        NavigationView {
            contentView
                .frame(width: 288)
            Text("Select a whisper")
        }
        #else
        NavigationView {
            contentView
        }
        #endif
    }
    
    var contentView: some View {
        VStack {
            switch viewModel.viewStatus {
            case .fetching:
                ProgressView("Loading...")
            case .loaded:
                whispersList
            case .empty:
                Text("No whispers loaded")
            case .error(let errorMessage):
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Popular whispers")
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
        #if os(iOS)
        .listStyle(.grouped)
        #endif
        .refreshable {
            viewModel.fetchPopularWhispers(limit: 200)
        }
    }
    
}


struct WhispersListView_Previews: PreviewProvider {
    
    static var previews: some View {
        WhispersListView()
    }
}
