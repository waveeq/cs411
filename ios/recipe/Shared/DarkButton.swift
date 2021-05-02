//
//  ProfileDarkButton.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/03.
//

import UIKit

public class DarkButton: UIButton {

  public override var isEnabled: Bool {
    didSet {
      disabled = !isEnabled
      updateColor()
    }
  }

  var highlight: Bool = false {
    didSet {
      updateColor()
    }
  }
  
  var disabled: Bool = false {
    didSet {
      updateColor()
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    setTitleColor(.white, for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 16)
    backgroundColor = .black
    addTarget(self, action: #selector(highlightButton(_:)), for: .touchDown)
    addTarget(self, action: #selector(unhighlightButton(_:)), for: .touchUpInside)
    addTarget(self, action: #selector(unhighlightButton(_:)), for: .touchUpOutside)
    addTarget(self, action: #selector(unhighlightButton(_:)), for: .touchCancel)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func highlightButton(_ sender: Any?) {
    highlight = true
  }

  @objc func unhighlightButton(_ sender: Any?) {
    highlight = false
  }

  func updateColor() {
    let alpha: CGFloat = disabled ? 0.5 : 1
    let white: CGFloat = highlight ? 0.3 : 0

    backgroundColor = UIColor(white: white, alpha: alpha)
  }
}
