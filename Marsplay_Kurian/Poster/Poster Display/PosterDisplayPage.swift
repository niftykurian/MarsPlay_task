//
//  PosterDisplayPage.swift
//  Marsplay_Kurian
//
//  Created by Kurian Ninan K on 08/01/20.
//  Copyright © 2020 kurian. All rights reserved.
//

import UIKit

class PosterDisplayPage: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    var apiController = APIController()
    var arrayPosterImages = [Any]()
    var currPage = 1
    var totalContentItems = String()
    
    var collectionItemsPerRow: CGFloat = 2
    var collectionPadding: CGFloat = 4
    
    @IBOutlet var collectionViewHomePage: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadImages()
        // Do any additional setup after loading the view.
    }
    
    func loadImages(){
        apiController.downloadPosterImages(currPage: currPage, withCompletion: { (result) in
            guard let dataResult = result["Search"]  else {
                                          return
                                      }
            guard let totalCount = result["totalResults"]  else {
                return
            }
            self.totalContentItems = totalCount as! String
            for customersDict in dataResult as! [AnyObject]{
                self.arrayPosterImages.append(customersDict)
            }
            self.collectionViewHomePage.reloadData()
        }) { (error) in
            print(error)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayPosterImages.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell : PosterDisplayCollectionViewCell = collectionViewHomePage.dequeueReusableCell(withReuseIdentifier: "posterCell", for: indexPath) as! PosterDisplayCollectionViewCell
           if(arrayPosterImages.isEmpty){
               return cell
           }
        let dictPosterDetail = arrayPosterImages[indexPath.row] as! [String:String]
        cell.labelTitle.text = dictPosterDetail["Title"]
        cell.labelYear.text = dictPosterDetail["Year"]
        cell.labelType.text = dictPosterDetail["Type"]
        let url = URL(string:dictPosterDetail["Poster"]! )!
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                cell.imageViewPoster.image = UIImage(data: data)
            }
        }
           return cell
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let imageFullScreenVC = storyBoard.instantiateViewController(withIdentifier: "posterFullScreen") as! DetailPosterViewController
                imageFullScreenVC.posterImageDetails = arrayPosterImages[indexPath.row] as! [String:String]
                self.present(imageFullScreenVC, animated:true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        let intTotalContentItems:Int = Int(totalContentItems)!
        if indexPath.row == arrayPosterImages.count - 1 { // check if last cell
            if intTotalContentItems > 0{
            if intTotalContentItems > arrayPosterImages.count { // whether more items to fetch
                currPage += 1
                loadImages()
                }else{
                    print("all data fetched")
                }
            }
        }else{
            return
        }
        }

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
       URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
   }
    
}

extension PosterDisplayPage: UICollectionViewDelegateFlowLayout {

    // MARK: flow layout delegate
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewHomePage.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = collectionPadding * collectionPadding + collectionPadding
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / collectionItemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionPadding, left: collectionPadding, bottom: collectionPadding, right: collectionPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
