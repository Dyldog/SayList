//
//  PlaylistListPresenter.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import Foundation

protocol PlaylistListDisplay: Display {
    func setViewModel(_ viewModel: PlaylistListViewModel)
}

class PlayListListPresenter: Presenter {
    
    private let oauth = OAuthManager()
    private var spotify: SpotifyClient!
    private let display: PlaylistListDisplay
    private var playlists: [Playlist] = []
    
    init(display: PlaylistListDisplay) {
        self.display = display
    }
    
    func viewDidAppear() {
        display.setViewModel(.init(cellModels: []))
        login() {
            self.initializeSpotify()
            self.getPlaylists() {
                self.refreshDisplay()
            }
        }
    }
    
    private func login(afterSuccess: @escaping () -> Void) {
        oauth.login(scope: "playlist-read-collaborative") { result in
            switch result {
            case .success:
                afterSuccess()
                self.display.showAlert(title: "Success", message: "Logged in successfully")
            case .failure(let error):
                self.display.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // Must be done after OAuth login
    private func initializeSpotify() {
        self.spotify = SpotifyClient(token: oauth.oauthToken!)
    }
    
    private func getPlaylists(afterSuccess: @escaping () -> Void) {
        spotify.getUserPlaylists() { result in
            switch result {
            case .success(let playlists):
                self.playlists = playlists
                afterSuccess()
            case .failure(let error):
                self.display.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func refreshDisplay() {
        let cellModels = self.playlists.map {
            PlaylistListViewModel.CellModel(
                title: $0.title,
                subtitle: "\($0.songCount) songs"
            )
            
        }
        let viewModel = PlaylistListViewModel(cellModels: cellModels)
        DispatchQueue.main.async {
            self.display.setViewModel(viewModel)
        }
    }
}
