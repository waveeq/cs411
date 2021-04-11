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

  let loadingIndicatorView = UIActivityIndicatorView()

  public override func loadView() {
    let exploreView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )

    exploreCollectionViewManager = ExploreCollectionViewManager(
      viewController: self,
      collectionView: exploreView
    )

    exploreView.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
    exploreView.backgroundColor = .white

    exploreView.addSubview(loadingIndicatorView)
    loadingIndicatorView.hidesWhenStopped = true
    loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loadingIndicatorView.centerXAnchor.constraint(equalTo: exploreView.centerXAnchor),
      loadingIndicatorView.centerYAnchor.constraint(equalTo: exploreView.centerYAnchor),
      loadingIndicatorView.heightAnchor.constraint(equalToConstant: 64),
      loadingIndicatorView.widthAnchor.constraint(equalTo: loadingIndicatorView.heightAnchor),
    ])

    view = exploreView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    title = "Explore"
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let exploreView = view as! UICollectionView

    loadingIndicatorView.startAnimating()
    RecipeServices.sharedInstance.getExploreList(forUserID: 1) { (exploreModels) in
      self.exploreCollectionViewManager.updateData(exploreModels: exploreModels!)
      self.exploreCollectionViewManager.textFieldDelegate = self
      exploreView.delegate = self.exploreCollectionViewManager
      exploreView.dataSource = self.exploreCollectionViewManager
      self.loadingIndicatorView.stopAnimating()
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
