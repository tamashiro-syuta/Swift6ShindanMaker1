//
//  LoginViewController.swift
//  Swift6ShindanMaker1
//
//  Created by 玉城秀大 on 2021/04/28.
//

import UIKit
import FirebaseAuth //DB
import NVActivityIndicatorView //ロードでグルグル回るやつ

class LoginViewController: UIViewController {
    
    var provider:OAuthProvider?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.provider = OAuthProvider(providerID: TwitterAuthProviderID)
        provider?.customParameters = ["lang":"ja"] //日本語設定

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
    }

    @IBAction func twitterLogin(_ sender: Any) {
        
        self.provider = OAuthProvider(providerID: TwitterAuthProviderID) //認証を受ける
        provider?.customParameters = ["force_login":"true"] //強制ログイン
        
        //ログインが確認されたらcredenitalに値が渡る。これをログイン処理の部分でAuthに渡す。Authが完了したら(ユーザーが入ったら)resultの中に全ての情報が入る。ユーザーに情報が入らない時はエラーが入る。 (これがクロージャーの処理)
        provider?.getCredentialWith(nil, completion: { (credential, error) in
            //クロージャー
            
            //ActivityIndivcatorView
            let activityView = NVActivityIndicatorView(frame: self.view.bounds, type: .ballBeat, color: .magenta, padding: .none)
            self.view.addSubview(activityView) //上で作ったActivityIndivcatorViewをviewに貼り付け
            activityView.stopAnimating() //アニメーションスタート
            
            //ログイン処理
            Auth.auth().signIn(with: credential!) { (result, error) in
                //もし、エラーだったら
                if error != nil {
                    return //下の処理まで行かせない
                }
                
                activityView.stopAnimating()
                
                //画面遷移
                let viewVC = self.storyboard?.instantiateViewController(identifier: "viewVC") as! ViewController
                //resultに入ってるユーザー情報を格納
                viewVC.userName = (result?.user.displayName)!
                self.navigationController?.pushViewController(viewVC, animated: true)
                
            }
            
        })

        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
