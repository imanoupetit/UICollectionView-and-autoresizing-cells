
import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel! {
        didSet { label.numberOfLines = 0 }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        return layoutAttributes
    }
    
}

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    init(minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        self.estimatedItemSize = self.itemSize
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        guard let collectionView = collectionView else { return layoutAttributes }
        layoutAttributes.bounds.size.width = collectionView.bounds.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        return layoutAttributesArray.flatMap { layoutAttributes in
            if case .cell = layoutAttributes.representedElementCategory {
                return layoutAttributesForItem(at: layoutAttributes.indexPath)
            } else {
                return layoutAttributes
            }
        }
    }
    
}

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let columnLayout = CustomFlowLayout(
        minimumInteritemSpacing: 20,
        minimumLineSpacing: 20,
        sectionInset: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    )
    let items = ["Lorem", "Lorem\nIpsum\nDolor\nSit\nAmet", "Lorem\nIpsum\nDolor", "Lorem\nIpsum", "Lorem\nIpsum\nDolor\nSit\nAmet", "Lorem\nIpsum\nDolor\nSit", "Lorem", "Lorem\nIpsum\nDolor", "Lorem\nIpsum", "Lorem\nIpsum\nDolor\nSit", "Lorem", "Lorem\nIpsum\nDolor\nSit\nAmet", "Lorem", "Lorem\nIpsum", "Lorem\nIpsum\nDolor\nSit"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.collectionViewLayout = columnLayout
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = items[indexPath.row]
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
}
