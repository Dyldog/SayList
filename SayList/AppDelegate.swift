//
//  AppDelegate.swift
//  SayList
//
//  Created by Dylan Elliott on 1/9/19.
//  Copyright © 2019 Dylan Elliott. All rights reserved.
//

import UIKit
import OAuthSwift

class SayListCoordinator {
    var navigationController: UINavigationController!
    var oauthToken: String!
    
    func start(in navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        let loginViewController = LoginViewController(scopes: "playlist-read-collaborative")
        navigationController.viewControllers = [loginViewController]
        loginViewController.login { token in
            self.oauthToken = token
            self.startPostLogin()
        }
    }
    
    private func startPostLogin() {
        let viewController = initialisePlaylistListViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func newSpotifyClient() -> SpotifyClient {
        return SpotifyClient(token: oauthToken)
    }
    
    private func initialisePlaylistListViewController() -> UIViewController {
        let viewController = PlaylistListViewController()
        let presenter = PlayListListPresenter(
            spotify: newSpotifyClient(),
            display: viewController,
            onSelection: { playlist in
                let detailViewController = self.initialisePlaylistDetailViewController(playlist)
                self.navigationController.pushViewController(detailViewController, animated: true)
            }
        )
        viewController.presenter = presenter
        return viewController
    }
    
    private func initialisePlaylistDetailViewController(_ playlist: Playlist) -> UIViewController {
        let detailViewController = PlaylistDetailViewController()
        let detailPresenter = PlaylistDetailPresenter(spotify: newSpotifyClient(), playlist: playlist, display: detailViewController, onSelection: { song in
            let songDetailViewController = self.initialiseSongDetailViewController(song)
            self.navigationController.pushViewController(songDetailViewController, animated: true)
        })
        detailViewController.presenter = detailPresenter
        return detailViewController
    }
    
    private func initialiseSongDetailViewController(_ song: Song) -> UIViewController {
        let detailViewController = SongDetailViewController()
        let detailPresenter = SongDetailPresenter(song: song, display: detailViewController)
        detailViewController.presenter = detailPresenter
        return detailViewController
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coordinator = SayListCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        coordinator.start(in: navigationController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey  : Any] = [:]) -> Bool {
        if (url.host == "oauth-callback") {
            OAuthSwift.handle(url: url)
        }
        return true
    }

}

