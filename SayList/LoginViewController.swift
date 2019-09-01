//
//  LoginViewController.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private let oauth = OAuthManager()
    private let oauthScopes: String
    
    init(scopes: String) {
        self.oauthScopes = scopes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func login(afterSuccess: @escaping (String) -> Void) {
        oauth.login(scope: oauthScopes) { result in
            switch result {
            case .success:
                afterSuccess(self.oauth.oauthToken!)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
