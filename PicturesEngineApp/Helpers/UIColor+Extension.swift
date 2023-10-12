//
//  UIColor+Extension.swift
//  PicturesEngineApp
//
//  Created by Faten Mahmoudi on 10/10/2023.
//

import Foundation
import UIKit

extension UIColor {
  static let backgroundColor: UIColor = {
    return UIColor(named: "backgroundColor") ?? .clear
  }()
  
  static let buttonColor: UIColor = {
    return UIColor(named: "buttonColor") ?? .clear
  }()
}
