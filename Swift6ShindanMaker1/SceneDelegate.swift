//
//  SceneDelegate.swift
//  Swift6ShindanMaker1
//
//  Created by 玉城秀大 on 2021/04/28.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //ログインしてたら別画面からにする処理
        
        //ユーザーがログインしてたら
        if Auth.auth().currentUser?.uid != nil {
            
            let window = UIWindow(windowScene: scene as! UIWindowScene)
            self.window = window //windowを初期化
            window.makeKeyAndVisible()
            
            //storyboardの名前を設定
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            //そのstoryboard上のIDが"viewVC"のものをインスタンス化
            let viewVC = storyBoard.instantiateViewController(identifier: "viewVC")
            //上でインスタンス化されたものをrootViewController(根っこ、元々のコントローラー)としてインスタンス化する処理
            let navVC = UINavigationController(rootViewController: viewVC)
            //windowの元々のコントローラとして上でインスタンス化したものを、rootとして設定
            window.rootViewController = navVC
        }else{
            let window = UIWindow(windowScene: scene as! UIWindowScene)
            self.window = window
            window.makeKeyAndVisible()
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let viewVC = storyBoard.instantiateViewController(identifier: "loginVC")
            let navVC = UINavigationController(rootViewController: viewVC)
            window.rootViewController = navVC
        }
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

