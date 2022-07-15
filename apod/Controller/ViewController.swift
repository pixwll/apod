//
//  ViewController.swift
//  apod
//
//  Created by Sardana
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var apodManager = ApodManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apodManager.delegate = self
        apodManager.fetchApod()
        
        let blur = UIVisualEffectView (effect: UIBlurEffect (style: UIBlurEffect.Style.systemUltraThinMaterialDark))
        blur.frame = UIScreen.main.bounds
        blur.isUserInteractionEnabled = false
        bgImageView.addSubview(blur)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: ApodManagerDelegate {
    func didUpdateApodText(_ apodManager: ApodManager, apod: ApodModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = apod.title
            self.descriptionLabel.text = apod.description
        }
    }
    
    func didUpdateApodImage(_ apodManager: ApodManager, apod: ApodModel) {
        DispatchQueue.main.async {
            self.imageView.image = apod.image
            self.bgImageView.image = apod.image
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
