//
//  ApodModel.swift
//  apod
//
//  Created by Sardana
//

import Foundation
import UIKit

class ApodModel {
    let title: String
    let description: String
    var image: UIImage? = nil
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}
