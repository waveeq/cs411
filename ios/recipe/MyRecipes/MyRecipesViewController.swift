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

  let loadingIndicatorView = UIActivityIndicatorView()

  lazy var tempCellColors: [UIColor] = {
    var colors: [UIColor] = []
    for _ in 1...36 {
      colors.append(randomColor())
    }
    return colors
  }()

  var myRecipeModels: [MyRecipeModel] = []
  var imageCaches: [Int:UIImage] = [:]

  public override func loadView() {
    let myRecipesView = UICollectionView(
      frame: .zero,
      collectionViewLayout: UICollectionViewFlowLayout()
    )
    myRecipesView.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 0, right: 12)
    myRecipesView.backgroundColor = .white

    myRecipesView.register(MyRecipesCell.self, forCellWithReuseIdentifier: cellIdentifier)

    myRecipesView.addSubview(loadingIndicatorView)
    loadingIndicatorView.hidesWhenStopped = true
    loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loadingIndicatorView.centerXAnchor.constraint(equalTo: myRecipesView.centerXAnchor),
      loadingIndicatorView.centerYAnchor.constraint(equalTo: myRecipesView.centerYAnchor),
      loadingIndicatorView.heightAnchor.constraint(equalToConstant: 64),
      loadingIndicatorView.widthAnchor.constraint(equalTo: loadingIndicatorView.heightAnchor),
    ])

    myRecipesView.delegate = self
    myRecipesView.dataSource = self
    self.view = myRecipesView
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    title = "My Recipes"

  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let myRecipesView = view as! UICollectionView

    loadingIndicatorView.startAnimating()
    RecipeServices.sharedInstance.getMyRecipeList(
      forUserID: AccountManager.sharedInstance.currentUserID
    ) { (myRecipeModels ) in

      self.myRecipeModels = myRecipeModels ?? []

      for myRecipeModel in self.myRecipeModels {
        if self.imageCaches.index(forKey: myRecipeModel.recipeID) == nil {
          self.imageCaches[myRecipeModel.recipeID] =
            try? UIImage(data: Data(contentsOf:  myRecipeModel.mainImage))
        }
      }

      myRecipesView.reloadSections(IndexSet(integer: 0))
      
      self.loadingIndicatorView.stopAnimating()
    }
  }
  
  // MARK: - UICollectionViewDataSource

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return myRecipeModels.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: cellIdentifier,
      for: indexPath
    ) as! MyRecipesCell

    cell.imageView.image = imageCaches[myRecipeModels[indexPath.row].recipeID]
    return cell
  }

  // MARK: - UICollectionViewDelegate

  public func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    navigationController?.pushViewController(
      RecipeDetailViewController(recipeID: myRecipeModels[indexPath.row].recipeID),
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
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let cellSize = (collectionView.frame.size.width / 3) - 16
    return CGSize(width: cellSize, height: cellSize)
  }

  // Custom function to generate a random UIColor
  func randomColor() -> UIColor{
      let red = CGFloat(drand48())
      let green = CGFloat(drand48())
      let blue = CGFloat(drand48())
      return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
}


