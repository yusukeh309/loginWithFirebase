//
//  HomeViewController.swift
//  LoginWithFirebaseApp
//
//  Created by Uske on 2020/03/02.
//  Copyright © 2020 Uske. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var user: User? {
        didSet {
            print("user?.name: ", user?.name)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBAction func tappedLogoutButton(_ sender: Any) {
        handleLogout()
    }
    
    private func handleLogout() {
        do {
            try Auth.auth().signOut()
            presentToSignUpViewController()
        } catch (let err) {
            print("ログアウトに失敗しました: \(err)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        logoutButton.layer.cornerRadius = 10
        
        if let user = user {
            nameLabel.text = user.name + "さんようこそ"
            emailLabel.text = user.email
            let dateString = dateFormatterForCreatedAt(date: user.createdAt.dateValue())
            dateLabel.text = "作成日：　" + dateString
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confirmLoggedInUser()
    }
    
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil || user == nil {
            presentToSignUpViewController()
        }
    }
    
    private func presentToSignUpViewController() {
        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: "ViewController") as! ViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }
    
    private func dateFormatterForCreatedAt(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}
