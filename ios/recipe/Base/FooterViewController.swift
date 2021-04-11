//
//  FooterViewController.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/17.
//

import UIKit

public protocol FooterDelegate: class {
  func footerButtonTapped(sender: Any?)
}

class FooterViewController: UIViewController {

  public weak var delegate: FooterDelegate? {
    didSet {
      if isViewLoaded, let footerView = view as? FooterView {
        footerView.delegate = delegate
      }
    }
  }

  override func loadView() {
    let footerView = FooterView()
    footerView.delegate = delegate
    
    self.view = footerView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

  }


}
