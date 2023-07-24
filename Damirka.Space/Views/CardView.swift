//
//  CardView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//

import SwiftUI

struct CardView: View {
    
    private var album: AlbumEntity;
    
    init(album albumEntity: AlbumEntity) {
        self.album = albumEntity;
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: album.image.url)) { image in
                image.resizable()
                    .cornerRadius(10.0)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 150, height: 150)
            .shadow(color: .primary, radius: 5)
            
            Group {
                Text(album.title).font(.headline)
                    .frame(width: 150, height: 20, alignment: .leading)
                    .foregroundColor(.black)
                Text(album.description).font(.subheadline)
                    .frame(width: 150, height: 10, alignment: .leading)
                    .foregroundColor(.black)
            }
        }
        .frame(width: 170, height: 230)
        .background(Color.init(red: 0.85, green: 0.85, blue: 0.85).opacity(0.5))
        .cornerRadius(10.0)
    }
}
