//
//  FeedViewController.swift
//  Swift6ShindanMaker1
//
//  Created by 玉城秀大 on 2021/04/29.
//

import UIKit
import BubbleTransition
import Firebase
import SDWebImage
import ViewAnimator
import FirebaseFirestore

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var interactiveTransition:BubbleInteractiveTransition?
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore() //DBをインスタンス化
    
    var feeds:[Feeds] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを1つ
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "feedCell")
        tableView.separatorStyle = .none
        loadData()

        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        //投稿されたものを受信する
        
        //DBを指定
        db.collection("feed").order(by: "createdAt").addSnapshotListener { (snapShot, error) in
            //addSnapshotListenerは、変更があればその都度、取得する
            self.feeds = []
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            //ドキュメントを全部取得して、snapshotDocに入れる
            if let snapShotDoc = snapShot?.documents{
                //ドキュメントの数だけ繰り返す
                for doc in snapShotDoc{
                    let data = doc.data() //そのドキュメントの子要素(データ)を取得
                    if let userName = data["useName"] as? String,
                       let quote = data["quote"] as? String,
                       let photoURL = data["photoURL"] as? String {
                        //データの中身に入っている値を変数に入れる
                        let newFeeds = Feeds(userName: userName, quote: quote, profileURL: photoURL)
                        //データを配列に入れる
                        self.feeds.append(newFeeds)
                        //新しい順に並べるため
                        self.feeds.reverse()
                        
                        //非同期通信の部分
                        DispatchQueue.main.async {
                            self.tableView.tableFooterView = nil
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
        interactiveTransition?.finish()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを構築
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
//        cell.userNameLabel.text = "\(feeds[indexPath.row].userName)さんを表す名言"
        cell.quoteLabel.text = "\(feeds[indexPath.row].userName)さんを表す名言" + "\n" + "\n" +  feeds[indexPath.row].quote
        cell.profileImageView.sd_setImage(with: URL(string: feeds[indexPath.row].profileURL), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セルの間に開けたい余白
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.size.height/10
    }

    //背景色
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
    }
    
    //フッターの設定
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude //非表示
    }
    
    

}
