//
//  RecipeDetailViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/22.
//

import UIKit

public class RecipeDetailViewController: UIViewController {

  let recipeImageColor: UIColor

  required init(recipeImageColor: UIColor) {
    self.recipeImageColor = recipeImageColor

    super.init(nibName: nil, bundle: nil)

    title = "Recipe"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func loadView() {
    let recipeDetailView = RecipeDetailView()
    view = recipeDetailView

    recipeDetailView.imageView.backgroundColor = recipeImageColor
  }
}
