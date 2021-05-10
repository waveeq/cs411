//
//  LoadingView.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/29.
//

import UIKit

public class LoadingOverlayView: UIView {

  static var sharedInstance: LoadingOverlayView?

  let loadingIndicatorSize: CGFloat = 64

  public static func startOverlay() {
    guard sharedInstance == nil,
          let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
    else { return }

    let overlayView = LoadingOverlayView()
    sharedInstance = overlayView

    window.addSubview(overlayView)
    overlayView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      overlayView.topAnchor.constraint(equalTo: window.topAnchor),
      overlayView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
      overlayView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
      overlayView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
    ])

    overlayView.alpha = 0
    UIView.animate(withDuration: 0.3) {
      overlayView.alpha = 1
    }
  }

  public static func stopOverlay() {
    guard let overlayView = sharedInstance, overlayView.layer.animationKeys() == nil else { return }

    UIView.animate(withDuration: 0.3, animations: {
      overlayView.alpha = 0
    }, completion: { (finished) in
      overlayView.removeFromSuperview()
    })

    sharedInstance = nil
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    addSubview(blurView)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      blurView.topAnchor.constraint(equalTo: topAnchor),
      blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
      blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
      blurView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
    blurView.alpha = 0.3

    let loadingIndicatorView = UIActivityIndicatorView()
    addSubview(loadingIndicatorView)
    loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
      loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
      loadingIndicatorView.heightAnchor.constraint(equalToConstant: loadingIndicatorSize),
      loadingIndicatorView.widthAnchor.constraint(equalToConstant: loadingIndicatorSize),
    ])

    loadingIndicatorView.startAnimating()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
