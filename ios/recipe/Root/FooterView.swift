//
//  FooterView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import UIKit

class FooterView: UIView {

  let height = 60
  let buttonSize: CGFloat = 44

  let footerStack = UIStackView()
  let myrecipeButton = FooterButton(targetTabType: .myRecipes)
  let exploreButton = FooterButton(targetTabType: .explore)
  let messageButton = FooterButton(targetTabType: .messages)

  public weak var delegate: FooterDelegate?

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    addSubview(blurView)

    blurView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      blurView.topAnchor.constraint(equalTo: topAnchor),
      blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
      blurView.heightAnchor.constraint(equalTo: heightAnchor),
      blurView.widthAnchor.constraint(equalTo: widthAnchor)
    ])

    addSubview(footerStack)
    footerStack.axis = .horizontal
    footerStack.alignment = .fill
    footerStack.distribution = .fillEqually

    self.footerStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      footerStack.topAnchor.constraint(equalTo: topAnchor),
      footerStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      footerStack.leftAnchor.constraint(equalTo: leftAnchor),
      footerStack.rightAnchor.constraint(equalTo: rightAnchor)
    ])

    myrecipeButton.isSelected = true
    myrecipeButton.normalImageSystemName = "heart"
    myrecipeButton.highlightedImageSystemName = "heart.fill"
    myrecipeButton.addTarget(self, action: #selector(footerButtonTapped(sender:)), for: .touchUpInside)

    exploreButton.normalImageSystemName = "magnifyingglass"
    exploreButton.highlightedImageSystemName = "text.magnifyingglass"
    exploreButton.addTarget(self, action: #selector(footerButtonTapped(sender:)), for: .touchUpInside)

    messageButton.normalImageSystemName = "bubble.left"
    messageButton.highlightedImageSystemName = "bubble.left.fill"
    messageButton.addTarget(self, action: #selector(footerButtonTapped(sender:)), for: .touchUpInside)

    myrecipeButton.translatesAutoresizingMaskIntoConstraints = false
    exploreButton.translatesAutoresizingMaskIntoConstraints = false
    messageButton.translatesAutoresizingMaskIntoConstraints = false

    self.footerStack.addArrangedSubview(self.myrecipeButton)
    self.footerStack.addArrangedSubview(self.exploreButton)
    self.footerStack.addArrangedSubview(self.messageButton)
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: -1, height: height)
  }

  @objc func footerButtonTapped(sender: NSObject?) {
    UIView.animate(withDuration: 0.2, animations: {
      self.myrecipeButton.isSelected = sender == self.myrecipeButton
      self.exploreButton.isSelected = sender == self.exploreButton
      self.messageButton.isSelected = sender == self.messageButton
    })

    delegate?.footerButtonTapped(sender: sender)
  }
}
