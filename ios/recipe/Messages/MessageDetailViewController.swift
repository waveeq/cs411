//
//  MessageDetailViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/24.
//

import UIKit

public class MessageDetailViewController: UIViewController {

  public required init(messageData: MessageData) {
    super.init(nibName: nil, bundle: nil)

    navigationItem.leftItemsSupplementBackButton = true
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: MessageNavBarFriendView(
      messageData: messageData
    ))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
  }
}
