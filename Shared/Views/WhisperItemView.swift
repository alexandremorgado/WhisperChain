//
//  WhisperItemView.swift
//  WhisperChain
//
//  Created by Alexandre Morgado on 21/12/21.
//

import SwiftUI

enum FooterStyle: Equatable {
    case full
    case minimal
}

struct WhisperItemView: View {
    
    let whisper: Whisper
    let footerStyle: FooterStyle
    
    var heartsText: String {
        switch footerStyle {
        case .full:
            return whisper.heartedCount > 0 ? String(whisper.heartedCount) : "Heart"
        case .minimal:
            return String(whisper.heartedCount)
        }
    }
    
    var repliesText: String {
        switch footerStyle {
        case .full:
            return whisper.repliesCount > 0 ? "\(whisper.repliesCount)" : "Reply"
        case .minimal:
            return "\(whisper.repliesCount)"
        }
    }
    
    init(_ whisper: Whisper, footerStyle: FooterStyle = .full) {
        self.whisper = whisper
        self.footerStyle = footerStyle
    }
    
    var body: some View {
        VStack {
            AsyncImage(
                url: whisper.url,
                content: { image in
                    image
                        .resizable()
                        .cornerRadius(5)
                        .aspectRatio(contentMode: .fit)
                },
                placeholder: {
                    ProgressView("Loading image...")
                }
            )
            footerView
        }
    }
    
    var footerView: some View {
        HStack {
            Label(
                heartsText,
                systemImage: whisper.heartedCount > 0 ? "heart.fill" : "heart"
            )
            .foregroundColor(footerStyle == .full ? .red : .secondary)
            Spacer()
            if footerStyle == .full {
                Label(repliesText, systemImage: "arrowshape.turn.up.backward")
            }
        }
        .padding(.horizontal, 3)
    }
}

struct WhisperItemView_Previews: PreviewProvider {
    static var previews: some View {
        WhisperItemView(Whisper.sample2)
            .padding()
    }
}
