//
//  FooterButton.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/04/04.
//

import UIKit

public class FooterButton: UIButton {

  public private(set) var targetTabType: TabType

  var normalImageSystemName: String? {
    didSet {
      if !isSelected {
        setImage(UIImage(systemName: normalImageSystemName!), for: .normal)
      }
    }
  }
  var highlightedImageSystemName: String? {
    didSet {
      setImage(UIImage(systemName: highlightedImageSystemName!), for: .highlighted)
      if isSelected {
        setImage(UIImage(systemName: highlightedImageSystemName!), for: .normal)
      }
    }
  }

  public override var isSelected: Bool {
    didSet {
      if isSelected, let highlightedImageSystemName = highlightedImageSystemName {
        setImage(UIImage(systemName: highlightedImageSystemName), for: .normal)
      }

      if !isSelected, let normalImageSystemName = normalImageSystemName {
        setImage(UIImage(systemName: normalImageSystemName), for: .normal)
      }

      if isSelected {
        layer.shadowColor = UIColor.systemGray2.cgColor
        layer.shadowOffset = CGSize(width: 0.1, height: 0.1)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
      } else {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
      }
    }
  }

  required init(targetTabType: TabType, frame: CGRect) {
    self.targetTabType = targetTabType

    super.init(frame: frame)

    tintColor = UIColor(white: 0.3, alpha: 1)
    setTitleColor(UIColor(white: 0.3, alpha: 1), for: .normal)
    titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .black)
  }

  public convenience init(targetTabType: TabType) {
    self.init(targetTabType: targetTabType, frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()

    let imageSize = imageView!.frame.size;
    let titleSize = titleLabel!.frame.size;
    let totalHeight = (imageSize.height + titleSize.height + 20);


    imageEdgeInsets = UIEdgeInsets(
      top: -(totalHeight - imageSize.height) + 16,
      left: 0,
      bottom: 0,
      right: -titleSize.width
    )

    titleEdgeInsets = UIEdgeInsets(
      top: 0,
      left: -imageSize.width,
      bottom: -(totalHeight - titleSize.height) + 8,
      right: 0
    )

    contentEdgeInsets = UIEdgeInsets(
      top: 16,
      left: 0,
      bottom: titleSize.height,
      right: 0
    );
  }
}
