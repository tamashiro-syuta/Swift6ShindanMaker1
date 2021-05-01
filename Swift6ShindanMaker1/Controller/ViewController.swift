//
//  ViewController.swift
//  Swift6ShindanMaker1
//
//  Created by 玉城秀大 on 2021/04/28.
//

import UIKit
import BubbleTransition
import Firebase
import FirebaseFirestore
import FirebaseAuth

class FeedItem {
    var meigen:String!
    var auther:String!
}

class ViewController: UIViewController,XMLParserDelegate,UIViewControllerTransitioningDelegate {
    
    var userName = String()
    
    @IBOutlet weak var meigenLabel: UILabel!
    
    @IBOutlet weak var toFeedButton: UIButton!
    
    let db = Firestore.firestore()
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    var parser = XMLParser()
    var feedItem = [FeedItem]() //FeedItem型の配列
    var currentElementName:String! //nilを許容
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toFeedButton.layer.cornerRadius = toFeedButton.frame.width/2 //ボタンを丸にする
        
        self.navigationController?.isNavigationBarHidden = true
        
        //XML解析
        let url = "http://meigen.doodlenote.net/api?c=1"
        let urlToSend = URL(string: url) //urlをURL型にキャスト
        parser = XMLParser(contentsOf: urlToSend!)!
        parser.delegate = self
        parser.parse()  //解析スタート
        
    }
    
    //データのキーを全て見ていく
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElementName = nil
        
        if elementName == "data" {
            self.feedItem.append(FeedItem()) //feedItemという配列の中にFeedItem型(辞書型)が初期化されて空の状態で入ってる
        }else {
            currentElementName = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.feedItem.count > 0 {
            //meigenとautherを処理していく
            
            //上で空の状態で定義したfeedItemに、meigenとautherという中身を入れていく
            let lastItem = self.feedItem[self.feedItem.count-1]
            
            switch self.currentElementName {
            case "meigen":
                lastItem.meigen = string //ここのstringは引数
                break
            case "auther":
                lastItem.auther = string
                
                meigenLabel.text = lastItem.meigen + "\n" + lastItem.auther
                break
            default:
                break
            }
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentElementName = nil
    }
    
    
    @IBAction func share(_ sender: Any) {
        //activityControllerを出す
        var postString = String()
        postString = "\(userName)さんを表す名言：\(meigenLabel.text!)\n#あなたを表す名言メーカー"
        
        let shareItems = [postString] as [String]
        let countroller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        present(countroller, animated: true, completion: nil)
        
    }
    
    @IBAction func sendData(_ sender: Any) {
        //FireStoreへ値を保存
        
        if let quote = meigenLabel.text, let userName = Auth.auth().currentUser?.uid {
            
            db.collection("feed").addDocument(data:
                ["userNanme":Auth.auth().currentUser?.displayName,
                 "quote":meigenLabel.text,
                 "photoURL":Auth.auth().currentUser?.photoURL?.absoluteString,
                 "createdAt":Date().timeIntervalSince1970]) { (error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
            }
        }
    }
    
    
    @IBAction func toFeedVC(_ sender: Any) {
        //画面遷移
        performSegue(withIdentifier: "feedVC", sender: nil)
        
    }
    
    
    @IBAction func logout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        self.navigationController?.popViewController(animated: true)
        do {
            try firebaseAuth.signOut()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as? FeedViewController
        controller!.transitioningDelegate = self
        controller!.modalPresentationStyle = .custom
        controller!.modalPresentationCapturesStatusBarAppearance = true
        controller!.interactiveTransition = interactiveTransition
        interactiveTransition.attach(to: controller!)
    }

       
       func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         transition.transitionMode = .present
         transition.startingPoint = toFeedButton.center
         transition.bubbleColor = toFeedButton.backgroundColor!
         return transition
       }
       
       
       func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
         transition.transitionMode = .dismiss
         transition.startingPoint = toFeedButton.center
         transition.bubbleColor = toFeedButton.backgroundColor!
         return transition
       }
       
       func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
         return interactiveTransition
       }
    
    
    
}

