//
//  MessagesSearchBar.swift
//  recipe
//
//  Created by Mochammad Dikra Prasetya on 2021/03/26.
//

import UIKit

public class MessagesSearchBar: UITextField {

  let inset: CGFloat = 8

  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.insetBy(dx: inset, dy: inset)
  }

  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: inset, dy: inset)
  }

  public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.insetBy(dx: inset, dy: inset)
  }
}
