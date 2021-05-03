//
//  MessageDetailView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/05/02.
//

import UIKit

public protocol MessageDetailViewDelegate: class, UITextViewDelegate {
  func sendButtonDidTap(_ sendButton: UIButton, textView: UITextView)
}

public class MessageDetailView: UIView {

  let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
  let sendTextView = UITextView()
  let sendButton = UIButton()
  var sendTextViewBottomAnchor: NSLayoutConstraint!
  var sendTextViewHeightAnchor: NSLayoutConstraint!
  
  public weak var delegate: MessageDetailViewDelegate? {
    didSet {
      sendTextView.delegate = delegate
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .white

    // Send text view

    sendTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
    sendTextView.textAlignment = .left
    sendTextView.font = UIFont.systemFont(ofSize: 16)
    sendTextView.layer.borderWidth = 2
    sendTextView.layer.borderColor = UIColor.black.cgColor
    sendTextView.isScrollEnabled = true
    addSubview(sendTextView)

    sendTextView.translatesAutoresizingMaskIntoConstraints = false

    sendTextViewBottomAnchor = sendTextView.bottomAnchor.constraint(
      equalTo: safeAreaLayoutGuide.bottomAnchor,
      constant: -8
    )
    sendTextViewHeightAnchor = sendTextView.heightAnchor.constraint(equalToConstant: 44)
    NSLayoutConstraint.activate([
      sendTextView.leadingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.leadingAnchor,
        constant: 12
      ),
      sendTextView.trailingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.trailingAnchor,
        constant: -8 - 44
      ),
      sendTextViewBottomAnchor,
      sendTextViewHeightAnchor,
    ])

    // Send button

    sendButton.setImage(UIImage(systemName: "paperplane.circle.fill"), for: .normal)
    sendButton.imageView?.contentMode = .scaleAspectFit
    sendButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
    sendButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    sendButton.contentVerticalAlignment = .fill
    sendButton.contentHorizontalAlignment = .fill
    sendButton.tintColor = UIColor.black
    sendButton.addTarget(self, action: #selector(sendButtonDidTap(_:)), for: .touchUpInside)
    addSubview(sendButton)

    sendButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      sendButton.bottomAnchor.constraint(equalTo: sendTextView.bottomAnchor),
      sendButton.trailingAnchor.constraint(
        equalTo: safeAreaLayoutGuide.trailingAnchor,
        constant: -8
      ),
      sendButton.widthAnchor.constraint(equalToConstant: 44),
      sendButton.heightAnchor.constraint(equalToConstant: 44),
    ])
    sendButton.adjustsImageWhenDisabled = true
    sendButton.isEnabled = false

    // Collection view

    collectionView.backgroundColor = .white
    addSubview(collectionView)

    collectionView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: sendTextView.topAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])

    // Register KVO

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name:UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(notification:)),
      name:UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func updateOnTextViewChange() {
    let height = sendTextView.sizeThatFits(
      CGSize(width: sendTextView.frame.width, height: .infinity)
    ).height
    sendTextViewHeightAnchor.constant = max(min(height, CGFloat(128)), CGFloat(44))

    sendButton.isEnabled = sendTextView.text.count > 0
  }

  // MARK: - Target Actions

  @objc func sendButtonDidTap(_ sender: Any?) {
    delegate?.sendButtonDidTap(sendButton, textView: sendTextView)
  }

  // MARK: - KVO

  @objc func keyboardWillShow(notification:NSNotification){
    let userInfo = notification.userInfo!
    let keyboardFrame = convert(
      (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue,
      from: nil
    )

    UIView.animate(withDuration: 0.3) {
      self.sendTextViewBottomAnchor.isActive = false
      self.sendTextViewBottomAnchor =
        self.sendTextView.bottomAnchor.constraint(
          equalTo: self.bottomAnchor,
          constant: -keyboardFrame.height - 8
        )
      self.sendTextViewBottomAnchor.isActive = true
    }
  }

  @objc func keyboardWillHide(notification:NSNotification){
    UIView.animate(withDuration: 0.3) {
      self.sendTextViewBottomAnchor.isActive = false
      self.sendTextViewBottomAnchor = self.sendTextView.bottomAnchor.constraint(
        equalTo: self.safeAreaLayoutGuide.bottomAnchor,
        constant: -8
      )
      self.sendTextViewBottomAnchor.isActive = true
    }
  }
}
