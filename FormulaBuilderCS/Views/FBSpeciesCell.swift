//
//  FBSpeciesCell.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/21/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

protocol FBSpeciesCellDelegate: class {
    func cellHeight(_ height: CGFloat, removedValue: String?, title: String)
}

class FBSpeciesCell: FBBaseTableViewCell {

    weak var speciesDelegate: FBSpeciesCellDelegate?
    var values = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler(gestureRecognizer:)))
        tapGesture.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(tapGesture)
        
        configCollectionView()
    }
    
    func configure(with values: [String], index: IndexPath) {
        self.values = values
        collectionView.reloadData()
        
        indexPath = index
        speciesDelegate?.cellHeight(collectionView.collectionViewLayout.collectionViewContentSize.height, removedValue: nil, title: nameLabel.text!)
    }
    
    func configCollectionView() {
        collectionView.register(UINib(nibName: "FBValueCell", bundle: nil), forCellWithReuseIdentifier: kCell)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 5
        layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
        layout.itemSize = CGSize(width: 76, height: 26)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = spacing * 2
        collectionView.collectionViewLayout = layout
    }
    
    func tapGestureHandler(gestureRecognizer : UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else {
            return
        }
        
        let p = gestureRecognizer.location(in: self.collectionView)
        let indexPathOfPoint = self.collectionView.indexPathForItem(at: p)
        
        if (indexPathOfPoint == nil && indexPath != nil) {
            let vc = self.speciesDelegate as! FBAdvancedSearchViewController
            vc.tableView(vc.tableView, didSelectRowAt: self.indexPath!)
        }
    }
}

extension FBSpeciesCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCell, for: indexPath) as! FBValueCell
        let value = values[indexPath.row]
        cell.titleLabel.text = value
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let value = values[indexPath.row]
        
        values.remove(at: indexPath.row)
        
        collectionView.reloadData()
        
        speciesDelegate?.cellHeight(collectionView.collectionViewLayout.collectionViewContentSize.height, removedValue: value, title: nameLabel.text!)
    }
    
    
    
}
