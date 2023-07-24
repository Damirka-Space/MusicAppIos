//
//  BlocksModel.swift
//  Damirka.Space
//
//  Created by Dam1rka on 21.07.2023.
//

import SwiftUI

class BlocksModel : ObservableObject {
    private var urlApi = "https://damirka.space/api"
    @Published var result: Result<[BlockEntity], Error>?
    
    func apiCall() {
        guard let url = URL(string: self.urlApi + "/main") else {
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
