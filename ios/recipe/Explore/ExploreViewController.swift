//
//  ExploreViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/20.
//

import UIKit

class ExploreFilterCollectionView: UICollectionView {

  required override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)

    contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    clipsToBounds = false
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class ExploreViewController: UIViewController, UITextFieldDelegate {

  var exploreCollectionViewManager: ExploreCollectionViewManager!

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?

  override func loadView() {
    let exploreView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    exploreView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    exploreView.backgroundColor = .white

    exploreCollectionViewManager = ExploreCollectionViewManager(
      viewController: self,
      collectionView: exploreView
    )
    exploreCollectionViewManager.textFieldDelegate = self
    exploreView.delegate = exploreCollectionViewManager
    exploreView.dataSource = exploreCollectionViewManager

    self.view = exploreView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Explore"
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
