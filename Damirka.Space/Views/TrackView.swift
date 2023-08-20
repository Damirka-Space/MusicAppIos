//
//  TrackView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//

import SwiftUI

struct TrackView: View {
    private let track: TrackEntity
    private let index: Int
    private let isAlbum: Bool
    
    init(track trackEntity: TrackEntity, index: Int, isAlbum : Bool) {
        self.track = trackEntity
        self.index = index
        self.isAlbum = isAlbum
    }
    
    var body: some View {
        HStack {
            if(isAlbum) {
                Text(index.description)
                    .font(.callout)
                    .frame(width: 25, height: 20, alignment: .leading)
            } else {
                AsyncImage(url: URL(string: track.metadataImageUrl)) { image in
                    image.resizable()
                        .cornerRadius(5.0)
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 40, height: 40, alignment: .center)
            }
            
            VStack {
                Text(track.title)
                    .font(.callout)
                    .frame(width: 300, height: 10, alignment: .leading)
                Text(track.author.joined(separator: ", "))
                    .font(.footnote)
                    .frame(width: 300, height: 10, alignment: .leading)
            }
            .contentShape(Rectangle())
            
            Image(systemName: "ellipsis")
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
