//
//  ViewController.swift
//  UICollectionView_PagingItem
//
//  Created by Lê Hoàng Anh on 13/10/2020.
//

import UIKit

class ViewController: UIViewController {

    let itemsSpacing: CGFloat = 0
    let itemWidth: CGFloat = UIScreen.main.bounds.width - 140
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var layout: UICollectionViewFlowLayout? {
        collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    var veloc: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing = 0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.updateScaleFactor()
        }
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScaleFactor()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        veloc = velocity.x
        updateContentOffset()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateContentOffset()
    }
    
    func updateScaleFactor() {
        collectionView.visibleCells.forEach { cell in
            let centerX = view.center.x
            
            if cell.globalFrame().minX < 60 {
                let cellX = cell.globalFrame().midX
                let scaleFactor = (1 - (centerX - cellX) / itemWidth) / 10 + 0.9
                cell.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            } else {
                let minX = cell.globalFrame().minX
                let targetX = view.center.x + itemWidth / 2
                
                let scaleFactor = ((targetX - minX) / itemWidth) / 10 + 0.9
                cell.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
            }
        }
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
        if currentIndex < collectionView.numberOfItems(inSection: 0) {
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
        }
    }
}

extension UIView {
    func globalFrame() -> CGRect {
        var x = frame.minX
        var y = frame.minY
        
        var responder: UIResponder? = self
        while responder is UIView {
            responder = responder!.next
            x += (responder as? UIView)?.frame.origin.x ?? 0
            y += (responder as? UIView)?.frame.origin.y ?? 0
            
            if responder is UIScrollView {
                x -= (responder as? UIScrollView)?.contentOffset.x ?? 0
                y -= (responder as? UIScrollView)?.contentOffset.y ?? 0
            }
        }
        return CGRect(x: x, y: y, width: bounds.width, height: bounds.height)
    }
}
