//
//  ApodManager.swift
//  apod
//
//  Created by Sardana
//

import Foundation
import UIKit

protocol ApodManagerDelegate {
    func didUpdateApodText(_ apodManager: ApodManager, apod: ApodModel)
    func didUpdateApodImage(_ apodManager: ApodManager, apod: ApodModel)
    func didFailWithError(error: Error)
}

struct ApodManager {
    let apodURL = "https://api.nasa.gov/planetary/apod"
    
    var delegate: ApodManagerDelegate?
    
    func fetchApod() {
        var keys: NSDictionary?
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
               keys = NSDictionary(contentsOfFile: path)
           }
        if let dict = keys {
            let APIkey = dict["API key"] as? String
            let urlString = "\(apodURL)?api_key=\(APIkey!)"
            performRequest(urlString)
        }
    }
    
    func performRequest(_ urlString: String) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let apod = self.parseJSON(safeData) {
                        self.delegate?.didUpdateApodText(self, apod: apod)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ apodData: Data) -> ApodModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(ApodData.self, from: apodData)
                let title = decodedData.title
                let description = decodedData.explanation
                let url = decodedData.url
                
                let apod = ApodModel(title: title, description: description)
                fetchImage(url, apod)
                return apod
                
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
    
    
    func fetchImage(_ url: String, _ apod: ApodModel) {
        guard let url = URL(string: url) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [apod] data, _, error in
            guard let data = data, error == nil else {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            DispatchQueue.main.async {
                apod.image = UIImage(data: data)
                self.delegate?.didUpdateApodImage(self, apod: apod)
            }
        }
        task.resume()
    }
}
