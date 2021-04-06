//
//  MessagesViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/20.
//

import UIKit

class MessagesViewController: UIViewController, UITextFieldDelegate {

  var messagesCollectionViewManager: MessagesCollectionViewManager!

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?

  override func loadView() {
    let messagesView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    messagesView.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
    messagesView.backgroundColor = .white

    messagesCollectionViewManager = MessagesCollectionViewManager(
      viewController: self,
      collectionView: messagesView
    )
    messagesCollectionViewManager.textFieldDelegate = self
    messagesView.delegate = messagesCollectionViewManager
    messagesView.dataSource = messagesCollectionViewManager

    self.view = messagesView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Messages"
  }

  // MARK: - UITextFieldDelegate

  @objc func dismissTextEditing(_ sender: Any?) {
    view.endEditing(true)
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    dismissTextEditingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTextEditing(_:)))
    navigationController?.view.addGestureRecognizer(dismissTextEditingTapRecognizer!)
    return true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if let _ = dismissTextEditingTapRecognizer {
      navigationController?.view.removeGestureRecognizer(dismissTextEditingTapRecognizer!)
    }
    dismissTextEditingTapRecognizer = nil
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
