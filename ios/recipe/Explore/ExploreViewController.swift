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

public class ExploreViewController: UIViewController, UITextFieldDelegate {

  var exploreCollectionViewManager: ExploreCollectionViewManager!

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?

  public override func loadView() {
    let exploreView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )

    exploreCollectionViewManager = ExploreCollectionViewManager(
      viewController: self,
      collectionView: exploreView
    )

    exploreView.backgroundColor = .white

    exploreView.delegate = exploreCollectionViewManager
    exploreView.dataSource = exploreCollectionViewManager

    view = exploreView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    title = "Explore"

    fetchData()
  }

  // MARK: - Data Fetch

  func fetchData() {
    LoadingOverlayView.startOverlay()
    RecipeServices.sharedInstance.getExploreList(
      forUserID: AccountManager.sharedInstance.currentUserID
    ) { exploreModels in
      self.exploreCollectionViewManager.textFieldDelegate = self
      self.exploreCollectionViewManager.updateData(exploreModels: exploreModels!)
      LoadingOverlayView.stopOverlay()
    }
  }

  // MARK: - UITextFieldDelegate

  @objc func dismissTextEditing(_ sender: Any?) {
    view.endEditing(true)
  }

  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    dismissTextEditingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTextEditing(_:)))
    navigationController?.view.addGestureRecognizer(dismissTextEditingTapRecognizer!)
    return true
  }

  public func textFieldDidEndEditing(_ textField: UITextField) {
    if let _ = dismissTextEditingTapRecognizer {
      navigationController?.view.removeGestureRecognizer(dismissTextEditingTapRecognizer!)
    }
    dismissTextEditingTapRecognizer = nil
  }

  public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
