//
//  ViewController.swift
//  UICollectionView_PagingItem
//
//  Created by Lê Hoàng Anh on 13/10/2020.
//

import UIKit

class ViewController: UIViewController {

    let itemsSpacing: CGFloat = 10
    let itemWidth: CGFloat = 300
    let leftRightSpacing: CGFloat = 20
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var veloc: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        cell.backgroundColor = UIColor.gray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: 200)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        veloc = velocity.x
        updateContentOffset()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateContentOffset()
    }
    
    func getXPositionOfItems(atIndex index: CGFloat) -> CGFloat {
        return itemWidth * index + (itemsSpacing * (index - 1)) + leftRightSpacing
    }
    
    func updateContentOffset() {
        let currentIndex: Int
        if veloc < 0 {
            currentIndex = Int(((collectionView.contentOffset.x + veloc) / (itemWidth + itemsSpacing)).rounded(.down))
        } else if veloc == 0 {
            currentIndex = Int(((collectionView.contentOffset.x) / (itemWidth + itemsSpacing)).rounded())
        } else {
            currentIndex = Int(((collectionView.contentOffset.x + veloc) / (itemWidth + itemsSpacing)).rounded(.up))
        }
        
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
    }
}
