//
//  HomeView.swift
//  Damirka.Space
//
//  Created by Dam1rka on 20.07.2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var blocksModel = BlocksModel()

    let rows = [
        GridItem(.adaptive(minimum: 150, maximum: 150))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                switch(blocksModel.result) {
                case .success(let blocks):
                    ForEach(blocks.indices, id: \.self) { bId in
                        Text(blocks[bId].title).font(.title2)
                            .frame(width: 350, height: 30, alignment: .bottomLeading)
                        ScrollView(.horizontal) {
                            LazyHGrid(rows: rows, alignment: .center, spacing: 20) {
                                ForEach(blocks[bId].albums.indices, id: \.self) { aId in
                                    NavigationLink(value: blocks[bId].albums[aId]) {
                                        CardView(album: blocks[bId].albums[aId])
                                    }
                                    
                                }
                            }.padding()
                        }
                    }
                    
                case .failure(let error):
                    Text(error.localizedDescription)
                case nil:
                    ProgressView()
                        .onAppear(perform: blocksModel.apiCall)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: AlbumEntity.self) { album in
                AlbumView(album: album)
            }
            .navigationDestination(for: String.self) { dest in
                
                
                
                switch(dest) {
                case "Profile":
                    ProfileView()
                case "Find":
                    FindView()

                default:
                    Text("Undefined view")
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    NavigationLink(value: "Profile") {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                }
                    
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    NavigationLink(value: "Find") {
                        Label("Find", systemImage: "magnifyingglass")
                    }
                }
                
                ToolbarItemGroup(placement: .principal) {
                    Text("Damirka.Space")
                }
            }
        }
    }
}
