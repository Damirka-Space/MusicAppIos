//
//  BlocksModel.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//

import SwiftUI

class BlocksModel : ObservableObject {
    private var urlApi = "https://api.dam1rka.duckdns.org"
    @Published var result: Result<[BlockEntity], Error>?
    
    var authService: AuthService?
    
    func setup(authService: AuthService) {
        self.authService = authService
    }
    
    func apiCall() {
        guard let url = URL(string: self.urlApi + "/main") else {
            return
        }
        
        var request = URLRequest(url: url)
        
        request.setValue(authService?.getAuthHeader(), forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error
                
                print(error?.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let json = try JSONDecoder().decode(BlocksEntity.self, from: data)
                    //print(json)
                    
                    self.result = Result.success(json.blocks)
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
