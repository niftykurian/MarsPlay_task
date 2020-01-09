//
//  DetailPosterViewController.swift
//  Marsplay_Kurian
//
//  Created by Kurian Ninan K on 09/01/20.
//  Copyright © 2020 kurian. All rights reserved.
//

import UIKit

class DetailPosterViewController: UIViewController {
    var posterImageDetails = [String:String]()
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelYear: UILabel!
    @IBOutlet var labelType: UILabel!
    @IBOutlet var imageViewPoster: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImageFullScreen()
        labelTitle.text = posterImageDetails["Title"]
        labelYear.text = posterImageDetails["Year"]
        labelType.text = posterImageDetails["Type"]
        // Do any additional setup after loading the view.
    }
    func loadImageFullScreen(){
        let url = URL(string:posterImageDetails["Poster"]! )!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imageViewPoster.image = UIImage(data: data)
            }
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
