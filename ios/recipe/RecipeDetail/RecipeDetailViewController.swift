//
//  RecipeDetailViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/22.
//

import UIKit

public class RecipeDetailViewController: UIViewController, RecipeDetailViewDelegate {

  var recipeID: Int!

  var dismissTextEditingTapRecognizer: UIGestureRecognizer?


  required init(recipeID: Int) {
    super.init(nibName: nil, bundle: nil)

    title = "Recipe"
    self.recipeID = recipeID
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func loadView() {
    let recipeDetailView = RecipeDetailView()
    recipeDetailView.recipeDetailViewDelegate = self

    view = recipeDetailView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    let recipeDetailView = view as! RecipeDetailView

    LoadingOverlayView.startOverlay()
    RecipeServices.sharedInstance.getRecipeDetails(
      forUserID: 1,
      recipeID: recipeID
    ) { (recipeDetailModel) in

      if let recipeDetailModel = recipeDetailModel {
        recipeDetailView.updateData(recipeDetailModel)
      }
      LoadingOverlayView.stopOverlay()
    }
  }

  public override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    saveNotesChanges()
  }

  // MARK: - RecipeDetailViewDelegate

  public func favoriteButtonDidTap(_ favoriteButton: UIButton) {
    let recipeDetailView = view as! RecipeDetailView

    if favoriteButton.isSelected {
      if !recipeDetailView.isNotesEmpty {
        let alert = UIAlertController(
          title: nil,
          message: "Unfavoriting an item will delete the notes attached to it. Are you sure you want to proceed?",
          preferredStyle: .actionSheet
        )

        alert.addAction(
          UIAlertAction(title: "Unfavorite", style: .destructive, handler: { (action) in
            RecipeServices.sharedInstance.removeRecipeFromMyRecipeList(
              forUserID: AccountManager.sharedInstance.currentUserID,
              recipeID: self.recipeID
            ) { (success) in
              recipeDetailView.unsetRecipeAsFavorite()
            }
          })
        )
        alert.addAction(
          UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        )

        navigationController?.present(alert, animated: true, completion: nil)
      } else {
        RecipeServices.sharedInstance.removeRecipeFromMyRecipeList(
          forUserID: AccountManager.sharedInstance.currentUserID,
          recipeID: recipeID
        ) { (success) in
          recipeDetailView.unsetRecipeAsFavorite()
        }
      }
    } else {
      RecipeServices.sharedInstance.insertRecipeToMyRecipeList(
        forUserID: AccountManager.sharedInstance.currentUserID,
        recipeID: recipeID
      ) { (success) in
        recipeDetailView.setRecipeAsFavorite()
      }
    }
  }

  // MARK: - UITextViewDelegate

  @objc func dismissTextEditing(_ sender: Any?) {
    view.endEditing(true)
  }

  public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    dismissTextEditingTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTextEditing(_:)))
    view.addGestureRecognizer(dismissTextEditingTapRecognizer!)
    return true
  }

  public func textViewDidEndEditing(_ textView: UITextView) {
    if let _ = dismissTextEditingTapRecognizer {
      view.removeGestureRecognizer(dismissTextEditingTapRecognizer!)
    }
    dismissTextEditingTapRecognizer = nil

    let recipeDetailView = view as! RecipeDetailView
    if recipeDetailView.isNotesChanged {
      saveNotesChanges()
    }
  }

  public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    textView.resignFirstResponder()
    return true
  }

  // MARK: - Private

  func saveNotesChanges() {
    let recipeDetailView = view as! RecipeDetailView
    RecipeServices.sharedInstance.updateRecipeNotes(
      forUserID: AccountManager.sharedInstance.currentUserID,
      recipeID: recipeID,
      notes: recipeDetailView.currentNotes) { (completion) in
      // No-op.
    }
  }

}
