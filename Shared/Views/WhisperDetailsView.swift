//
//  WhisperDetailsView.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import SwiftUI

struct WhisperDetailsView: View {
    
    let whisper: Whisper
    @StateObject var viewModel = WhisperDetailsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                WhisperItemView(whisper)
                if whisper.repliesCount > 0 {
                    repliesList
                } else {
                    Text("NO REPLIES, BE THE FIRST!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            Spacer()
                .frame(height: 30)
        }
        .navigationTitle(whisper.text)
        .task {
            if whisper.repliesCount > 0 {
                do {
                    try await viewModel.loadReplies(for: whisper, limit: 200)
                } catch {
                    print("Error", error)
                }
            }
        }
    }
    
    var repliesList: some View {
        VStack(alignment: .leading, spacing: 6) {
            if viewModel.repliesViewStatus == .fetching {
                ProgressView("Loading replies...")
            } else {
                Text("REPLIES (\(viewModel.mostHeartedChain.count))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.mostHeartedChain) { whisper in
                            NavigationLink(
                                destination: { WhisperDetailsView(whisper: whisper) },
                                label: {
                                    WhisperItemView(whisper, footerStyle: .minimal)
                                        .frame(maxWidth: 200)
                                }
                            )
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
        }
    }
}

struct WhisperDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WhisperDetailsView(whisper: Whisper.sample1)
    }
}
