//
//  OAuthManager.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation
import OAuthSwift

extension OAuthSwiftError {
    var asOAuthManagerError: OAuthManager.Error {
        return .error(self)
    }
}

class OAuthManager {
    enum Error: Swift.Error {
        case error(OAuthSwiftError)
        
        var localizedDescription: String {
            switch self {
            case .error(let oauthSwiftError):
                return oauthSwiftError.description
            }
        }
    }
    
    private var oauthClient: OAuth2Swift
    private let clientID = "3483e728fbf14d14a061688ab5dfe37f"
    private let clientSecret = "69958acd12504157b6748d61eb58e7b6"
    private let authorizeURL = "https://accounts.spotify.com/authorize"
    private let callbackURL = "saylist://oauth-callback/spotify"
    private let accessTokenURL = "https://accounts.spotify.com/api/token"
    private let responseType = "code"
    
    var oauthToken: String?
    
    init() {
        oauthClient = OAuth2Swift(
            consumerKey:    clientID,
            consumerSecret: clientSecret,
            authorizeUrl: authorizeURL,
            accessTokenUrl: accessTokenURL,
            responseType: responseType
        )
    }
    
    func login(scope: String, completion: @escaping (Result<Void, Error>) -> Void) {
        oauthClient.authorize(withCallbackURL: URL(string: callbackURL)!,
                              scope: scope, state:UUID().uuidString) { result in
            switch result {
            case .success(let (credential, _, _)):
                self.oauthToken = credential.oauthToken
                completion(.success(()))
            case .failure(let error):
                print("OAUTHMANAGER: ERROR: \(error.description)")
                completion(.failure(error.asOAuthManagerError))
            }
        }
    }
    
}
