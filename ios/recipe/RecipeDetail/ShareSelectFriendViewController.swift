//
//  ShareSelectFriendViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/03.
//

import UIKit

public class ShareSelectFriendViewController: UIViewController, UITextFieldDelegate {

  let recipeDetailModel: RecipeDetailModel
  var shareSelectFriendCollectionViewManager: ShareSelectFriendCollectionViewManager!

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?

  required init(recipeDetailModel: RecipeDetailModel) {
    self.recipeDetailModel = recipeDetailModel

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    let topGrabberView = UIView()
    topGrabberView.backgroundColor = .systemGray
    topGrabberView.layer.cornerRadius = 2
    topGrabberView.layer.cornerCurve = .continuous
    view.addSubview(topGrabberView)

    topGrabberView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topGrabberView.topAnchor.constraint(equalTo: view.topAnchor, constant:12),
      topGrabberView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1),
      topGrabberView.heightAnchor.constraint(equalToConstant: 4),
      topGrabberView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])

    let titleLabel = UILabel()
    titleLabel.text = "Select a friend to share the recipe with:"
    titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    titleLabel.adjustsFontSizeToFitWidth = false
    titleLabel.numberOfLines = 1
    titleLabel.sizeToFit()

    view.addSubview(titleLabel)

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topGrabberView.bottomAnchor, constant:24),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
    ])

    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    collectionView.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
    collectionView.backgroundColor = .white

    shareSelectFriendCollectionViewManager = ShareSelectFriendCollectionViewManager(
      viewController: self,
      collectionView: collectionView
    )
    shareSelectFriendCollectionViewManager.textFieldDelegate = self
    collectionView.delegate = shareSelectFriendCollectionViewManager
    collectionView.dataSource = shareSelectFriendCollectionViewManager
    view.addSubview(collectionView)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant:12),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    
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
