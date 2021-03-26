//
//  MyRecipesViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/20.
//

import UIKit

public class MyRecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  let cellIdentifier = "myRecipesCellIdentifer"
  let headerIdentifier = "myRecipesHeaderIdentifier"

  lazy var tempCellColors: [UIColor] = {
    var colors: [UIColor] = []
    for _ in 1...12 {
      colors.append(randomColor())
    }
    return colors
  }()

  public override func loadView() {
    let myRecipesView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    myRecipesView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    myRecipesView.backgroundColor = .white

    myRecipesView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    myRecipesView.register(
      MyRecipesSectionHeader.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerIdentifier
    )
    myRecipesView.delegate = self
    myRecipesView.dataSource = self

    self.view = myRecipesView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    title = "My Recipes"
  }
  
  // MARK: - UICollectionViewDataSource

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return tempCellColors.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
    cell.backgroundColor = tempCellColors[indexPath.row]

    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    if kind == UICollectionView.elementKindSectionHeader {
      let sectionHeader = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: headerIdentifier,
        for: indexPath
      ) as! MyRecipesSectionHeader
      sectionHeader.label.text = indexPath.section == 0 ? "Favorites" : "Recommended for You"
      return sectionHeader
    } else { //No footer in this case but can add option for that
         return UICollectionReusableView()
    }
  }

  // MARK: - UICollectionViewDelegate

  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    navigationController?.pushViewController(
      RecipeDetailViewController(recipeImageColor: tempCellColors[indexPath.row]),
      animated: true
    )
  }

  // MARK: - UICollectionViewDelegateFlowLayout

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 12
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 12
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return UIEdgeInsets(top: 8, left: 0, bottom: 32, right: 0)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let cellSize = (collectionView.frame.size.width / 3) - 16
    return CGSize(width: cellSize, height: cellSize)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    let collectionViewSafeArea = collectionView.frame.inset(by: collectionView.adjustedContentInset)
    return CGSize(width: collectionViewSafeArea.width, height: MyRecipesSectionHeader.height)
  }

  // Custom function to generate a random UIColor
  func randomColor() -> UIColor{
      let red = CGFloat(drand48())
      let green = CGFloat(drand48())
      let blue = CGFloat(drand48())
      return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
}


