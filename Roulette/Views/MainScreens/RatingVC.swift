//
//  RatingTableViewController.swift
//  Roulette
//
//  Created by Waliok on 17/08/2023.
//

import UIKit
import SnapKit

class RatingVC: UITableViewController {
    @Published var users: [DBUser] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        let backGround = UIImageView(image: .init(named: "Roulette"))
        backGround.contentMode = UIView.ContentMode.scaleToFill
        
        self.tableView.backgroundView = backGround
        self.navigationItem.title = "Rating"
        self.navigationController?.navigationBar.prefersLargeTitles = true
       
        Task {
            users = try await UserManager.shared.getAllUsers()
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "reuseIdentifier")

        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .systemYellow
        cell.detailTextLabel?.textColor = .systemOrange
        cell.detailTextLabel?.text = "Score: " + String(users[indexPath.row].credits)
        cell.textLabel?.text = "Name: " + (users[indexPath.row].name ?? "")

        return cell
    }
}

//MARK: - Preview

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct RatingVC_Preview: PreviewProvider {

    static var previews: some View {

        RatingVC()
            .showPreview()
            .ignoresSafeArea()
    }
}
#endif
