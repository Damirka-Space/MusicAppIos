//
//  AuthService.swift
//  Damirka.Space
//
//  Created by Dam1rka on 02.09.2023.
//

import AVKit

final class AuthService : ObservableObject {
    @Published 
    private var isAuthorized = false
    
    @Published
    private var isProccessing = false
    
    @Published
    private var urlSession: URLSession
    
    @Published 
    var result: Result<TokenEntity, Error>?
    
    @Published
    private var username: String = "TEST4"
    
    @Published
    private var password: String = "TEST4"
    
    init() {
        urlSession = URLSession.init(configuration: URLSessionConfiguration.default)
    }
    
    func getCode() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "auth.dam1rka.duckdns.org"
        components.path = "/oauth2/authorize"

        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: "server"),
            URLQueryItem(name: "redirect_uri", value: "https://dam1rka.duckdns.org/user/authorized"),
            URLQueryItem(name: "scope", value: "music-server.read music-server.write")
        ]
        
        //print("Code URL: \(components.url!)")
        
        let request = URLRequest(url: components.url!)

        let task = urlSession.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error
                
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            //print("Response: \(response)")
            if response.statusCode == 200 {
                self.getCSRF()
            }
            else {
                self.isProccessing = false
                self.isAuthorized = false
            }
            
        }
        task.resume()
    }
    
    func getCSRF() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "auth.dam1rka.duckdns.org"
        components.path = "/login"
        
        let request = URLRequest(url: components.url!)
    
        let task = urlSession.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error
            
                return
            }
            
            guard response is HTTPURLResponse else { return }
            
            let res = String(data: data!, encoding: .utf8)!
                        
            let pattern = #"name="_csrf" value="([^"]+)""#
            let regex = try! NSRegularExpression(pattern: pattern, options: [])

            let range = NSRange(location: 0, length: res.utf16.count)
            
            if let match = regex.firstMatch(in: res, options: [], range: range) {
                let csrfTokenRange = Range(match.range(at: 1), in: res)!
                let csrfToken = String(res[csrfTokenRange])
                //print("CSRF Token: \(csrfToken)")
                
                self.loginPost(csrf: csrfToken)
                
            } else {
                print("CSRF Token not found.")
            }
        }
        task.resume()
    }
    
    func loginPost(csrf: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "auth.dam1rka.duckdns.org"
        components.path = "/login"
        
        components.queryItems = [
            URLQueryItem(name: "_csrf", value: csrf),
            URLQueryItem(name: "username", value: self.username),
            URLQueryItem(name: "password", value: self.password),
        ]
        
        var request = URLRequest(url: components.url!)

        request.httpMethod = "POST"
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error

                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            //print(response.statusCode)
            //print(response)
            
            if response.statusCode == 200 {
                //print(response)
                
                guard let url = URLComponents(string: response.url!.absoluteString) else { return }
                let code = url.queryItems?.first(where: { $0.name == "code" })?.value
                
                //print(code)
                
                if code != nil {
                    self.getOpaqueToken(code: code!)
                }
            }
            else {
                self.isProccessing = false
                self.isAuthorized = false
            }
            
            
            
            
        }
        task.resume()
    }
    
    private func getOpaqueToken(code: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "auth.dam1rka.duckdns.org"
        components.path = "/oauth2/token"
        
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://dam1rka.duckdns.org/user/authorized"),
            URLQueryItem(name: "client_id", value: "server"),
        ]
        
        var request = URLRequest(url: components.url!)

        request.httpMethod = "POST"
        
        request.setValue("Basic c2VydmVyOnNlY3JldA==", forHTTPHeaderField:"Authorization")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if error != nil {
                // Handle error

                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            print(response.statusCode)
            
            if response.statusCode == 200 {
                print(response)
                
                //print(String(data: data!, encoding: .utf8))

                DispatchQueue.main.async {
                    do {
                        let d = JSONDecoder()
                        d.keyDecodingStrategy = .convertFromSnakeCase
                        let json = try d.decode(TokenEntity.self, from: data!)
                        //print(json)
                        
                        self.isAuthorized = true
                        self.result = Result.success(json)
                        
                    } catch {
                        //print(error)
                        self.result = Result.failure(error)
                        //fatalError(error.localizedDescription)
                    }
                    
                    self.isProccessing = false
                }
            } else {
                self.isProccessing = false
            }
            
        }
        task.resume()
    }
    
    public func Authorized() -> Bool {
        return isAuthorized
    }
    
    public func Processing() -> Bool {
        return isProccessing
    }
    
    public func login(username: String, password: String) {
        //print(username, password)
        
        self.username = username
        self.password = password
        
        isProccessing = true
        
        getCode()
        
    }
    
    public func getAuthHeader() -> String {
        if(Authorized()) {
            do {
                let token = try result!.get()
                let tokenString = token.tokenType + " " + token.accessToken
                return tokenString
            } catch {
                return ""
            }
        }
        return ""
    }
}
