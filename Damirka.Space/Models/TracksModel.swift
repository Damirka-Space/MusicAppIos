//
//  TracksModel.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//


import SwiftUI

class TracksModel : ObservableObject {
    private var urlApi = "https://api.dam1rka.duckdns.org"
    @Published var result: Result<[TrackEntity], Error>?
    
    func apiCall(albumId: Int) {
        guard let url = URL(string: self.urlApi + "/album/tracks/get/" + albumId.description) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error
                return
            }
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let json = try JSONDecoder().decode([TrackEntity].self, from: data)
                    //print(json)
                    self.result = Result.success(json)
                } catch {
                    //print(error)
                    self.result = Result.failure(error)
                    //fatalError(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}

